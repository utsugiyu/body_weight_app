Name
====

### [Body-Weight App](https://body-w.herokuapp.com/)

## Description
体重を記録してグラフで表示することができます。体重計メーカーであるタニタが提供している「[ヘルスプラネット](https://www.healthplanet.jp/)」と連携することで自動で体重を登録することが可能です(ヘルスプラネットに登録されたデータは10分以内に反映されます)。タニタが販売している[Wi-Fi、Bluetooth対応の体重計](https://www.healthplanet.jp/index.do#model)を使用すれば、入力の手間は完全になくなります。

## Requirement
「[ヘルスプラネット](https://www.healthplanet.jp/)」との連携を利用する場合には、あらかじめヘルスプラネットのアカウントが必要です。

## Usage
![ログイン画面](https://i.gyazo.com/4139cee149c06f6a1662f6a9d41d5fd8.png)

↑メールアドレスとパスワードを入力してログインしてください。アカウントをまだ作成していない場合には、「Sign up now!」から新規登録をお願いします。　　

「Remember・・・」のチェックボックスにチェックを入れるとcookieを使用したログインが可能になります。  

![画面](https://i.gyazo.com/1ff1566382a856b43a9e21e31e0e9ef8.png)
↑メイン画面の上部です。体重は手動で登録することもできます(最小0.01kg単位)。グラフ上部のタブをクリックすることでグラフの期間指定が可能です。グラフ内の点にカーソルを合わせる（スマートフォンの場合はクリックする）とその点が示す体重が表示されます。

![画面](https://i.gyazo.com/f3e705523fe241ad581be109a96761eb.png)
↑メイン画面の下部です。登録された体重はグラフ下部にリストで表示されます。当該記録の「Delete」リンクをクリックすることで記録の削除が可能です。

![画面](https://i.gyazo.com/18205d1ed8140d16a6580cc7677fda4c.png)  
↑ログイン後のMenu内には以下の項目があります。  
* Home  
グラフの期間指定、リストのページネーションがリセットされた状態でメイン画面を表示します。  

* Settings  
アカウントの「Name」「Email」「Password」の変更が可能です。

* Health Planet  
「[ヘルスプラネット](https://www.healthplanet.jp/)」との連携を開始します。画面の遷移に沿って、あらかじめ作成しておいたヘルスプラネットのアカウントID・パスワードの入力、「認証する」ボタンのクリックを行ってください(ヘルスプラネットに登録されたデータは10分以内に反映されます)。「[ヘルスプラネット](https://www.healthplanet.jp/)」の利用方法は[公式サイト](https://www.healthplanet.jp/index.do#service)や体重計の説明書を参考にしてください。

* Log Out  
ログアウトします。

## Author
[Yu Utsugi](https://twitter.com/YuUtsugi)
