# docker_ws

Docker環境セットアップの方法とDockerfileをまとめたリポジトリ

## Install Docker
```
cd ~/

git clone https://gitlab.com/TeamSOBITS/docker_ws.git

bash install_docker.sh 

#Dockerコンテナ内でGPUを使う人は以下のコマンドも実行してください。
bash install_nvidia_docker.sh 
```

## 使い方
containerディレクトリ内に様々な環境のDockerfileを用意しています。
build.shでイメージのビルド、run.shでイメージからコンテナを作成できます。
