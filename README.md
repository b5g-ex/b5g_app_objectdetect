# B5GAppObjectdetect

**物体検出 Phoenix アプリケーションです。**

## 動作環境
- Erlang 25 以降
- Elixir 1.14 以降

## 準備

```sh
$ git clone https://github.com/b5g-ex/b5g_app_objectdetect.git
$ cd b5g_app_objectdetect
$ mix setup
```

## 起動
事前に [`yolov3_wrapper_ex`](https://github.com/b5g-ex/yolov3_wrapper_ex) (画像認識用 Backend Server)を起動しておくこと。
```sh
# 全設定がデフォルト値の場合
$ ./start_node.sh

# 設定を変更する場合 (例: DEFAULT_BACKEND_SERVER を変更)
$ DEFAULT_BACKEND_SERVER="{:yolov3_wrapper_ex, :\"yolov3_wrapper_ex@127.0.0.1\"}" ./start_node.sh
```
ブラウザから [`localhost:4000`](http://localhost:4000) にアクセスする。

## 設定 (環境変数)
| 項目 | 初期値 | 説明 |
| --- | --- | --- |
| NODE_NAME | "b5g_app_objectdetect" | 起動する `node` の名前 |
| NODE_IPADDR | "127.0.0.1" | 起動する `node` のIPアドレス（`ifconfig` や `ip a` 等のコマンドで確認後入力してください） |
| COOKIE | "idkp" | COOKIEの値 |
| DEFAULT_BACKEND_SERVER | "{:yolov3_wrapper_ex, :\\"yolov3_wrapper_ex@127.0.0.1\\"}" | 画像認識用 Backend Server の名前 (参照: [GenServer.call/3](https://hexdocs.pm/elixir/1.14.4/GenServer.html#call/3), [Name Registration](https://hexdocs.pm/elixir/1.14.4/GenServer.html#module-name-registration)) \| 画面で `Backend` に `local` を選択した際の通信先 |
| USE_GIOCCI | "false" | Giocci 連携の有効 / 無効設定 (`false`, `true`) |
| TARGET_GIOCCI_RELAY_NAME | "{:global, :relay}" | 通信するGiocciRelayの名前 |

## Giocci 連携時の手続き
アプリケーション起動後、iex から GiocciRelayに Node.connect() してErlangクラスタを構築してください。
