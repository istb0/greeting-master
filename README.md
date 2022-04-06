# Gremas - あいさつマスター -

### https://gremas.jp

## サービス概要
マスク着用時でも確実に相手に届く、気持ちの良い挨拶を身につける手助けをするサービスです。<br>
入力音声を感情分析することで、自分の挨拶が相手にどう聞こえているか客観な評価を知ることができます。

## 本サービスを開発した背景

コロナ禍でマスク着用により表情が見えなくなり、「声」が感情を伝える要素の大部分を占めるようになったと感じます。<br>
特に日常的な挨拶のシーンでは、無愛想な挨拶になっていないか、そもそも挨拶が届いているのか不安になることがあります。<br>
そこで、自分の挨拶がどう捉えられているか、客観的に測定できるサービスがあれば、現状を把握でき、繰り返し練習をすることで改善に役立つと考えました。

## 主な機能
ログインなしでできること
- 挨拶測定
- Twitter共有
- ランキング閲覧
- ユーザー登録

ログイン後にできること
- 測定履歴の閲覧、削除
- ランキング参加
## 使用技術
バックエンド
- Ruby 3.0.3
- Ruby on Rails 6.1.4

主要Gem
- sorcery
- faraday
- seed-fu
- meta-tags
- aws-sdk-s3

フロントエンド
- JavaScript
- TailwindCSS

インフラ
- Heroku
- PostgreSQL
- Amazon S3

その他
- Empath API（音声感情分析）
- Web Audio API（音声録音）
- Web Speech API（音声認識）

## ER図
![ER図](https://user-images.githubusercontent.com/87421354/161946177-2f6140ef-9918-4a51-88d0-ed283a533d36.png)

## 画面遷移図
https://www.figma.com/file/rk7au8RENEd7LvVcVWUTkY/Gremas?node-id=0%3A1

## 最後に
挨拶はコミュニケーションの第一歩。<br>
日々の些細なシーンを少しでも気持ちの良いものにしたいです。
