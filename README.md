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

## Tips
- ### コンテナ起動時に "docker: Error response from daemon: linux runtime spec devices: could not select device driver "" with capabilities: [[gpu]]. "と出た場合。
  端末に以下のコマンドを入力すると、治る場合が有ります。
  ```
  cd ~/docker_ws/
  sh nvidia-container-runtime-script.sh
  sudo apt install nvidia-container-runtime
  systemctl restart docker.service
  ```
