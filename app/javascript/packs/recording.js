import { wearingMask } from './mask.js';
import { exportWAV } from './export-wav.js';

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
let audioCtx = null;
let audioData = []; // 録音データ

//録音部分
let handleSuccess = () => {
  //EmpathAPI用にサンプリングレートを固定
  window.AudioContext = window.AudioContext || window.webkitAudioContext;
  audioCtx = new AudioContext({ sampleRate: 11025 });

  //MediaStreamAudioSourceNodeオブジェクトを生成
  source = audioCtx.createMediaStreamSource(audioStream);

  //ScriptProcessorNodeオブジェクトを作成
  let bufferSize = 1024;
  scriptProcessor = audioCtx.createScriptProcessor(bufferSize, 1, 1);

  //ローパスフィルターの設定
  if (wearingMask == true) {
    let biquadFilter = audioCtx.createBiquadFilter();
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
      stopRecording();
    }
  }, 5000);
};

//WAV音声データをバックエンドに送信
let sendToBackend = (audioBlob) => {
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

//リトライを促す
let forceRetry = (responce) => {
  isRecording = 'forceRetry';
  mic.style.pointerEvents = 'auto';
  notice.innerHTML = `『${phrase}』が聞こえませんでした<br>リトライしてください(>_<)`;
  transcript.textContent = `聞こえた声：${responce}`;
};

//録音START
let startRecording = () => {
  isRecording = true;
  notice.innerHTML = '〜録音中〜<br>※5秒以内に挨拶してね';
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
  const audioBlob = exportWAV(audioData, audioCtx);

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
    const constraints = {
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
