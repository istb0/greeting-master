import axios from 'axios';
axios.defaults.headers['X-Requested-With'] = 'XMLHttpRequest';
axios.defaults.headers['X-CSRF-TOKEN'] = document
  .getElementsByName('csrf-token')[0]
  .getAttribute('content');

const mic = document.getElementById('mic');
const notice = document.getElementById('notice');

const transcript = document.getElementById('transcript');
const phrase = document.getElementById('phrase').dataset.phrase;

let isRecording = false;

let audioStream = null;
let source = null;
let scriptProcessor = null;
let biquadFilter = null;
let audioBlob = null;
let audioCtx = null;

let audioData = []; // 録音データ
let bufferSize = 1024;

//録音部分
let handleSuccess = () => {
  //EmpathAPI用にサンプリングレートを固定
  window.AudioContext = window.AudioContext || window.webkitAudioContext;
  audioCtx = new AudioContext({ sampleRate: 11025 });

  //MediaStreamAudioSourceNodeオブジェクトを生成
  source = audioCtx.createMediaStreamSource(audioStream);

  //ScriptProcessorNodeオブジェクトを作成
  scriptProcessor = audioCtx.createScriptProcessor(bufferSize, 1, 1);

  //ローパスフィルターの設定
  if (wearingMask == true) {
    biquadFilter = audioCtx.createBiquadFilter();
    biquadFilter.type = 'lowpass';
    biquadFilter.frequency.value = 2000;
    //マスクフィルターONの場合はBiquadFilterNodeを接続
    source.connect(biquadFilter);
    biquadFilter.connect(scriptProcessor);
    scriptProcessor.connect(audioCtx.destination);
  } else {
    //各ノードの接続
    source.connect(scriptProcessor);
    scriptProcessor.connect(audioCtx.destination);
  }

  //1024bitのバッファサイズに達するごとにaudioDataにデータを追加する
  scriptProcessor.onaudioprocess = (e) => {
    let input = e.inputBuffer.getChannelData(0);
    let bufferData = new Float32Array(bufferSize);
    for (let i = 0; i < bufferSize; i++) {
      bufferData[i] = input[i];
    }
    audioData.push(bufferData);
  };

  //5秒後に録音を停止
  setTimeout(() => {
    if (isRecording == true) {
      //forceRetry();
      stopRecording();
    }
  }, 5000);
};

//WAVに変換
let exportWAV = () => {
  let encodeWAV = (samples, sampleRate) => {
    let buffer = new ArrayBuffer(44 + samples.length * 2);
    let view = new DataView(buffer);

    let writeString = (view, offset, string) => {
      for (let i = 0; i < string.length; i++) {
        view.setUint8(offset + i, string.charCodeAt(i));
      }
    };

    let floatTo16BitPCM = (output, offset, input) => {
      for (let i = 0; i < input.length; i++, offset += 2) {
        let s = Math.max(-1, Math.min(1, input[i]));
        output.setInt16(offset, s < 0 ? s * 0x8000 : s * 0x7fff, true);
      }
    };

    writeString(view, 0, 'RIFF'); // RIFFヘッダ
    view.setUint32(4, 32 + samples.length * 2, true); // これ以降のファイルサイズ
    writeString(view, 8, 'WAVE'); // WAVEヘッダ
    writeString(view, 12, 'fmt '); // fmtチャンク
    view.setUint32(16, 16, true); // fmtチャンクのバイト数
    view.setUint16(20, 1, true); // フォーマットID
    view.setUint16(22, 1, true); // チャンネル数
    view.setUint32(24, sampleRate, true); // サンプリングレート
    view.setUint32(28, sampleRate * 2, true); // データ速度
    view.setUint16(32, 2, true); // ブロックサイズ
    view.setUint16(34, 16, true); // サンプルあたりのビット数
    writeString(view, 36, 'data'); // dataチャンク
    view.setUint32(40, samples.length * 2, true); // 波形データのバイト数
    floatTo16BitPCM(view, 44, samples); // 波形データ

    return view;
  };

  let mergeBuffers = (audioData) => {
    let sampleLength = 0;
    for (let i = 0; i < audioData.length; i++) {
      sampleLength += audioData[i].length;
    }
    let samples = new Float32Array(sampleLength);
    let sampleIdx = 0;
    for (let i = 0; i < audioData.length; i++) {
      for (let j = 0; j < audioData[i].length; j++) {
        samples[sampleIdx] = audioData[i][j];
        sampleIdx++;
      }
    }
    return samples;
  };

  let dataview = encodeWAV(mergeBuffers(audioData), audioCtx.sampleRate);
  //できあがったwavデータをBlobにする
  audioBlob = new Blob([dataview], { type: 'audio/wav' });
};

//WAV音声データをバックエンドに送信
let sendToBackend = () => {
  let formData = new FormData();
  const greeting_id = document.getElementById('phrase').dataset.id;
  formData.append('voice', audioBlob);
  formData.append('greeting_id', greeting_id);
  axios
    .post(`/greetings/${greeting_id}/results`, formData, {
      headers: {
        'content-type': 'multipart/form-data',
      },
    })
    .then((response) => {
      if (response.data.url != undefined) {
        window.location.href = response.data.url;
      } else {
        forceRetry(response.data);
      }
    })
    .catch((error) => {
      console.log(error.response);
    });
};

//音声認識
//let startRecognition = () => {
//  window.SpeechRecognition =
//    window.SpeechRecognition || window.webkitSpeechRecognition;
//  recognition = new SpeechRecognition(audioStream);
//  recognition.lang = 'ja-JP';
//
//  //音声を捕捉したら発火
//  recognition.onaudiostart = () => {
//    startRecording(audioStream);
//  };
//
//  //音声認識サービスから結果が返されたときに発火
//  recognition.onresult = (e) => {
//    isRecording = false;
//    let resultTranscript = e.results[0][0].transcript;
//    transcript.textContent = `聞こえた声：${resultTranscript}`;
//    if (resultTranscript == phrase) {
//      recognition.stop();
//      stopRecording();
//    } else {
//      forceRetry();
//    }
//  };
//  recognition.start();
//};
//
////リトライを促す
let forceRetry = (responce) => {
  isRecording = 'forceRetry';
  //recognition.stop();
  mic.style.pointerEvents = 'auto';
  notice.innerHTML = `『${phrase}』が聞こえませんでした<br>リトライしてください(>_<)`;
  transcript.textContent = `聞こえた声：${responce}`;
};

//録音START
let startRecording = () => {
  isRecording = true;
  notice.innerHTML = '〜録音中〜<br>※5秒以内に挨拶してね';
  //transcript.textContent = '';
  handleSuccess(audioStream);
};

//録音STOP
let stopRecording = () => {
  notice.textContent = '〜録音完了*音声処理中〜';

  //接続の停止
  scriptProcessor.disconnect();
  source.disconnect();
  audioCtx.close();

  //取得した音声データをwavファイルに変換する
  exportWAV(audioData);

  //WAV音声データをバックエンドに送信する
  sendToBackend(audioBlob);
};

//マイク利用許可〜録音開始へ
mic.addEventListener('click', () => {
  if (isRecording == 'forceRetry') {
    location.reload();
  } else {
    notice.textContent = '〜録音準備中〜';
    mic.style.pointerEvents = 'none';
    let constraints = {
      audio: {
        echoCancellation: true,
        echoCancellationType: 'system',
        noiseSuppression: false,
      },
      video: false,
    };
    navigator.mediaDevices
      .getUserMedia(constraints)
      .then((stream) => {
        audioStream = stream;
        console.log('supported');
        //startRecognition(audioStream);
        startRecording(audioStream);
      })
      .catch((error) => {
        notice.innerHTML =
          '▲非対応のブラウザもしくは端末です▲<br>PCからご利用ください！';
        notice.style.color = 'red';
        console.error('error:', error);
      });
  }
});

//以下マスク表示部分
const maskfilter = document.getElementById('maskfilter');
const mask = document.getElementById('mask');

let wearingMask = maskfilter.checked;

maskfilter.addEventListener('click', () => {
  wearingMask = maskfilter.checked;
  wearingMask ? mic.appendChild(mask) : mic.removeChild(mask);
});
