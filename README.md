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

# コンテナを可視化するため，以下のコマンドも実行してください．
$ sudo apt-get update
$ sudo apt-get install -y python3-tk tk-dev 

# GUIを表示されたら，インストール完了．
$ python3 -m tkinter
```

> **Warning**
> `GPU版`のDockerをインストールする前に，必ず[CUDAとCuDNNのセットアップ](https://github.com/TeamSOBITS/sobits_manual/tree/main/install_sh#cuda)を済ませてください．


## How to use

コンテナの環境情報や起動方法等については，それぞれのコンテナのフォルダの中にあるREADMEを参照してください．


## Container Executer

![Container Executer](img/container_executer.png)

ビルドされたコンテナの一覧を表示し，それらを起動・再起動・停止・ターミナルの操作ができます．

```bash
$ python3 ~/{docker_wsのPATH}/container_executer.py
# 例: python3 ~/docker_ws/container_executer.py
```

> **Note**
> `{docker_wsのPATH}`はDockerパッケージのPATHを意味とする．

また，そのコマンドを`alias`として設定しておくと，`Container Executer`を速やかに実行できます．

```bash
# 1回のみで実行する
$ echo 'alias ce="python3 ~/{docker_wsのPATH}/container_executer.py"' >> ~/.bashrc
$ source ~/.bashrc
```

設定した`alias`を実行するために，以下のコマンドを入力します．

```bash
$ ce
```

> **Note**
> このコマンドは自分がいるPATHに依存していないため，どこでも実行可能です．


## Docker Containers 

用意されているコンテナ一覧です．


<details><summary>Containers List</summary>
<p>

- base_1804_l4t_ws
    - cpu
    - gpu
        - CUDA10.2_cuDNN8.2.1
- base_1804_ws
    - cpu
    - gpu
        - CUDA11.6.2_cuDNN8.4
- base_2004_ws
    - cpu
    - gpu
        - CUDA11.6.2_cuDNN8.4
        - CUDA11.8.0_cuDNN8.7
        - CUDA12.1.1_cuDNN8.9
- base_2204_ws
    - cpu
    - gpu
        - CUDA11.7.1_cuDNN8.5.0.96
        - CUDA12.1.1_cuDNN8.9
- ros_kinetic_basic_ws (archived)
    - cpu
    - gpu
        - CUDA9.0_cuDNN7.6
- ros_melodic_basic_l4t_ws
    - gpu
        - CUDA10.2_cuDNN8.2.1
- ros_melodic_basic_ws
    - cpu
    - gpu
        - CUDA10.1_cuDNN7.0 (archived)
        - CUDA11.0_cuDNN8.0 (archived)
        - CUDA11.2_cuDNN8.1 (archived)
        - CUDA11.3_cuDNN8.2 (archived)
        - CUDA11.6.2_cuDNN8.4
- ros_melodic_sobits_l4t_ws
    - gpu
        - CUDA10.2_cuDNN8.2.1
- ros_melodic_sobits_ws
    - cpu
    - gpu
        - CUDA11.6.2_cuDNN8.4
- ros_noetic_basic_ws
    - cpu
    - gpu
        - CUDA11.6.2_cuDNN8.4
        - CUDA12.1.1_cuDNN8.9
- ros_noetic_sobits_ws
    - cpu
    - gpu
        - CUDA11.6.2_cuDNN8.4
        - CUDA12.1.1_cuDNN8.9
- ros2_humble_basic_ws
    - cpu
    - gpu
        - CUDA11.7.1_cuDNN8.5.0.96
        - CUDA12.1.1_cuDNN8.9
- ros2_humble_sobits_ws
    - cpu
    - gpu
        - CUDA11.7.1_cuDNN8.5.0.96
        - CUDA12.1.1_cuDNN8.9

</p>
</details>


## Change-Log

- 2023/08/02~05
    - CUDA12.1.1 cuDNN8.9に対応
        - base_2004_ws, base_2204_ws
        - ros_noetic_basic_ws, ros2_humble_basic_ws
        - ros_noetic_sobits_ws, ros2_humble_sobits_ws
    - トークンの削除し，要求する
    - レイヤのコピを省略し，容量の縮小
    - 必要なパッケージの縮小
- 2023/01/21 (RCJP22向け)
    - CUDA11.8.0 cuDNN8.7の環境構築
    - ホストPCがUbuntu22.04の環境でCPU/GPUともに動作確認（済）
    - ホストPCがUbuntu20.04の環境でCPU/GPUともに動作確認（未）
- 2022/05/28
    - CUDA11.6.2 cuDNN8.4の環境構築
    - ホストPCがUbuntu20.04の環境でCPU/GPUともに動作確認（済）


## Reference

Docker上の環境構築や使い方についてより詳しく知りたい場合は，以下のサイトのドキュメントを読んでみてください．

- SOBITS Manual: [Docker Workspaceの使用方法](https://github.com/TeamSOBITS/sobits_manual/blob/main/docs/using_docker_ws.md)
- 公式サイト: [Docker Docs](https://docs.docker.com/)