# My Book List

My Book Listはシンプルに設計された読書記録ウェブサービスです。
書誌情報にはAmazon Product Web Service API を用い、ウェブフレームワークには Padrino を使用しています。

## 必要なライブラリ

* ruby ( >= 1.9.3 )
* memcached
* SQLite

## インストール手順

まず必要なgemをインストールします。

```bash
$ gem install bundler
$ bundle install
```

次にデータベースのマイグレーションと初期データの登録を行います。

```bash
$ padrino rake ar:create
$ padrino rake ar:migrate
$ padrino rake seed
```

設定ファイルを編集します。
設定ファイルにはあらかじめ入手しておいたAmazonのAPIキーを記述します。

```bash
$ cp config/application.yml.sample config/application.yml
$ vim config/application.yml
```

その後、アプリケーションを起動します。

```bash
$ padrino start -p 3000
```

http://localhost:3000/ にアクセスして画面が表示されればインストールの成功です。

## cron登録
MyBookListにはAmazonのAPI結果を自動的にキャッシュするcronジョブを用意しています。
以下のコマンドを叩いて、 出力されたcronジョブを crontab -e でcronに登録してください。

    $ whenever --set 'environment=development'
    0 * * * * /bin/bash -l -c 'cd /path/to/project && padrino rake amazon:cache:all -e development >> log/cron.log'
    ## [message] Above is your schedule file converted to cron syntax; your crontab file was not updated.
    ## [message] Run `whenever --help' for more options.

cronジョブの登録に成功すると、1時間ごとに登録された本に関するAmazon APIのキャッシュを更新します。

## ライセンス
MITライセンスです。詳しくは LICENSE を御覧ください。
