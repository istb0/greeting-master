import axios from 'axios';
axios.defaults.headers['X-Requested-With'] = 'XMLHttpRequest';
axios.defaults.headers['X-CSRF-TOKEN'] = document.getElementsByName('csrf-token')[0].getAttribute('content');

const record = document.querySelector('.record');

record.disabled = false;

let isRecording = false;

let audioStream = null;
let source = null;
let processor = null;
let audioBlob = null;
let context = null;

let audioData = []; // 録音データ
let bufferSize =1024;

//録音部分
let handleSuccess = () => {

  //EmpathAPI用にサンプリングレートを固定
  context = new AudioContext({ sampleRate: 11025 });
  console.log('sampleRate:', context.sampleRate);

  //MediaStreamAudioSourceNodeオブジェクトを生成
	source = context.createMediaStreamSource(audioStream);

	//処理を行うプロセッサーを出力先とするために作成する
	processor = context.createScriptProcessor(bufferSize,1,1);
	//直接destinationに繋ぐとスピーカーからそのまま音が出てしまう
	source.connect(processor);
	processor.connect(context.destination);

	//1024bitのバッファサイズに達するごとにaudioDataにデータを追加する
	processor.onaudioprocess = (e) => {

		let input = e.inputBuffer.getChannelData(0);
		let bufferData = new Float32Array(bufferSize);
			for (let i = 0; i < bufferSize; i++) {
				bufferData[i] = input[i];
			}
		audioData.push(bufferData);
	};

  //5秒後に録音を停止
	setTimeout( () => {
    if (isRecording == true) {
      console.log("5 sec passed");
			stopRecording(audioData);
    }
	}, 5000);
};

//WAVに変換
let exportWAV = () => {

	let encodeWAV = (samples, sampleRate) =>{
		let buffer = new ArrayBuffer(44 + samples.length * 2);
		let view = new DataView(buffer);

		let writeString = (view, offset, string) => {
			for (let i = 0; i < string.length; i++){
				view.setUint8(offset + i, string.charCodeAt(i));
			}
		};

		let floatTo16BitPCM = (output, offset, input) => {
			for (let i = 0; i < input.length; i++, offset += 2){
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

	let dataview = encodeWAV(mergeBuffers(audioData), context.sampleRate);
  // console.log(dataview);
	//できあがったwavデータをBlobにする
	audioBlob = new Blob([dataview], { type: 'audio/wav' });
  //console.log(audioBlob);

	// let downloadLink = document.getElementById('download');
	// //BlobへのアクセスURLをダウンロードリンクに設定する
	// downloadLink.href = URL.createObjectURL(audioBlob);
	// downloadLink.download = 'test.wav';

	let audio = document.getElementById('audio');
	//オーディオ要素にもBlobをリンクする
	audio.src = URL.createObjectURL(audioBlob);
	//音声を再生する
	//audio.play();
};

//WAV音声データをバックエンドに送信
let sendToBackend = () => {
	let formData = new FormData();
	const greeting_id = document.getElementById('greeting_id').value;
  formData.append('voice', audioBlob)
	formData.append('greeting_id', greeting_id);
  axios.post(`/greetings/${greeting_id}/results`,  formData, {
    headers: {
      'content-type': 'multipart/form-data',
    }
  })
  .then(response => {
    //console.log(response.data)
    window.location.href = response.data.url
  })
  //バックエンドからのレスポンスをformに格納
	//.then(response => {
  //  let data = response.data.body
	////console.log(data)
  ////window.location.href = data.url
	//
  //  let q = document.createElement('input');
  //  q.type = 'hidden';
  //  q.name = 'data';
  //  q.value = data;
  //  document.forms[0].appendChild(q);
	//
  //  stop.disabled = true;
  //  result.disabled = false;
  //})
  .catch(error => {
    console.log(error.response)
  })
};

//録音START
let startRecording = () => {
	isRecording = true;
	record.disabled = false;
  console.log('record start');
  handleSuccess(audioStream);
};

//録音STOP
let stopRecording = () => {
	isRecording = false;
	record.disabled = true;
  console.log('record stop');

  //接続の停止
  processor.disconnect();
  source.disconnect();
  context.close();

  //取得した音声データをwavファイルに変換する
  exportWAV(audioData);

  //WAV音声データをバックエンドに送信する
	sendToBackend(audioBlob);
};

//マイクデバイスの利用許可の確認を行う
record.addEventListener("click", () => {
	if (isRecording == true) {
		stopRecording(audioData);
	} else {
		record.disabled = true;
  	let constraints = {
  	  audio: {
  	    echoChancellation: true,
  	    echoCancellationType: 'system',
  	    noiseSuppression: false
  	  },
  	  video: false
  	}
  	navigator.mediaDevices.getUserMedia(constraints)
  	.then((stream) => {
  	  audioStream = stream;
  	  console.log('supported');
			startRecording(audioStream);
  	})
  	.catch((error) => {
  	  console.error('error:', error);
  	})
	}
});
