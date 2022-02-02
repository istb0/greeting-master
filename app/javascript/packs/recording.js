import axios from 'axios';

axios.defaults.headers['X-Requested-With'] = 'XMLHttpRequest';
axios.defaults.headers['X-CSRF-TOKEN'] = document.getElementsByName('csrf-token')[0].getAttribute('content');

const record = document.querySelector('.record');
const stop = document.querySelector('.stop');
const result = document.querySelector('.result');

let audio_sample_rate = null;
let audioContext = null;
let audioBlob = null;
let audioData = [];
let bufferSize = 1024;

record.disabled = false;
stop.disabled = true;
result.disabled = true;

//WAVに変換
let exportWAV = function (audioData) {
  let encodeWAV = function (samples, sampleRate) {
    let buffer = new ArrayBuffer(44 + samples.length * 2);
    let view = new DataView(buffer);

    let writeString = function (view, offset, string) {
      for (let i = 0; i < string.length; i++) {
        view.setUint8(offset + i, string.charCodeAt(i));
      }
    };

    let floatTo16BitPCM = function (output, offset, input) {
      for (let i = 0; i < input.length; i++ , offset += 2) {
        let s = Math.max(-1, Math.min(1, input[i]));
        output.setInt16(offset, s < 0 ? s * 0x8000 : s * 0x7FFF, true);
      }
    };

    writeString(view, 0, 'RIFF');  // RIFFヘッダ
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

  let mergeBuffers = function (audioData) {
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

  let dataview = encodeWAV(mergeBuffers(audioData), audio_sample_rate);
  audioBlob = new Blob([dataview], { type: 'audio/wav' });
  console.log(dataview);

  let myURL = window.URL || window.webkitURL;
  let url = myURL.createObjectURL(audioBlob);
  return url;
};

// save audio data
const onAudioProcess = function (e) {
  const input = e.inputBuffer.getChannelData(0);
  const output = e.outputBuffer.getChannelData(0);
  for (let i = 0; i < input.length; i++) output[i] = input[i];
  const bufferData = new Float32Array(bufferSize);
  for (let i = 0; i < bufferSize; i++) {
    bufferData[i] = input[i];
  }

  audioData.push(bufferData);
};

//getusermedia
let handleSuccess = function (stream) {
  audioContext = new AudioContext();
  audio_sample_rate = audioContext.sampleRate;
  let scriptProcessor = audioContext.createScriptProcessor(bufferSize, 1, 1);
  let mediastreamsource = audioContext.createMediaStreamSource(stream);
  mediastreamsource.connect(scriptProcessor);
  scriptProcessor.onaudioprocess = onAudioProcess;
  scriptProcessor.connect(audioContext.destination);
  console.log('record start');
  setTimeout(function () {
    if (stop.disabled == false) {
      stop.click();
      console.log("10 sec");
    }
  }, 10000);
};

// 録音開始
record.onclick = function () {
  navigator.mediaDevices.getUserMedia({
    video: false,
    audio: true
  })
  .then((handleSuccess));
  record.disabled = true;
  stop.disabled = false;
};

//録音停止
stop.onclick = function() {
  exportWAV(audioData);
  audioContext.close().then(function () {
    stop.disabled = true;
    result.disabled = false;
  });
  console.log(audioBlob);
};

//録音音声をサーバーへ送信
result.onclick = function() {
  let formData = new FormData();
  formData.append('voice', audioBlob)
  axios.post('/results',  formData, {
    headers: {
      'content-type': 'multipart/form-data',
    }
  })
  .then(response => {
    let data = response.data
    window.location.href = data.url
  })
  .catch(error => {
    console.log(error.response)
  })
};
