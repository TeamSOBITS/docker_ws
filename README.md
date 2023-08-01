# docker_ws

Docker環境セットアップの方法とDockerfileをまとめたリポジトリです．


## Install Docker

```bash
# docker_wsパッケージをダウンロードする．
$ git clone https://gitlab.com/TeamSOBITS/docker_ws.git

# インストールのフォルダへ移動する．
$ cd docker_ws/setup_sh

# 必要なリソースをインストールする．
$ bash install_docker.sh

# Dockerコンテナ内でGPUを使う場合．以下のコマンドも実行する．
$ bash install_nvidia_docker.sh

# オーディオをセットアップする．
$ bash setup_audio.sh

# コンテナを可視化するため，以下のコマンドも実行してください．
$ sudo apt-get update
$ sudo apt-get install -y python3-tk tk-dev 

# GUIを表示されたら，インストール完了．
$ python3 -m tkinter
```

## How to use

パッケージ内に様々なDocker環境が用意されていますので．
そのコンテナの環境情報や起動方法等については，各ディレクトリの中にあるREADMEを参照してください．


## Container Executer

![Container Executer](img/container_executer.png)

ビルドされたコンテナの一覧を表示し，起動・再起動・停止・ターミナルの操作ができます．

```bash
# 実行方法
$ python3 ~/{docker_ws_path}/container_executer.py
```

> **Note**
> `{docker_ws_path}`はDockerパッケージのPATHを意味とする．

また，`alias`として設定しておくと，`Container Executer`を速やかに実行できる．

```bash
$ echo 'alias ce="python3 ~/{docker_ws_path}/container_executer.py"' >> ~/.bashrc
$ source ~/.bashrc
```

### 実行方法
設定したaliasの実行方法については以下のうようになります．

```bash
$ ce
```

> **Note**
> `ce`だけで実行できます．また，PATHに依存していないため，どこでも実行可能です．

## Reference

Docker上の環境構築や使い方についてより詳しく知りたい場合は，以下のサイトにドキュメントを読んでみてください．

- SOBITS Manual: [Docker Workspaceの使用方法](https://github.com/TeamSOBITS/sobits_manual/blob/main/docs/using_docker_ws.md)
- 公式サイト: [Docker Docs](https://docs.docker.com/)