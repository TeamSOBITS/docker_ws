# Docker Workspaces

Docker環境セットアップの方法とDockerfileをまとめたリポジトリです．


## Install Docker

```bash
# docker_wsパッケージをダウンロードする．
$ git clone https://github.com/TeamSOBITS/docker_ws.git

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
> `GPU版`のDockerをインストールする前に，必ず[Nvidia Driver](https://github.com/TeamSOBITS/sobits_manual/tree/main/install_sh#cuda)のインストールを済ませてください．CUDAやcuDNNをインストールすることが必要ではありません．


## How to use

コンテナの環境情報や起動方法等については，それぞれのコンテナのフォルダの中にあるREADMEを参照してください．


## Container Executer

![Container Executer](img/container_executer.png)

ビルドされたコンテナの一覧を表示し，それらを起動・再起動・停止・ターミナルの操作ができます．

[install_docker.sh](setup_sh/install_docker.sh)で設定した`alias`を用いて，コンテナの一覧を表示するために，以下のコマンドを入力します．

```bash
$ ce
```

> **Note**
> このコマンドは自分がいるPATHに依存していないため，どこでも実行可能です．


## Docker Containers 

用意されているコンテナ一覧です．


<details><summary>Containers List</summary>
<p>

- base_1804_l4t_ws (archived)
    - cpu
    - gpu
        - CUDA10.2_cuDNN8.2.1
- base_1804_ws (archived)
    - cpu
    - gpu
        - CUDA11.6.2_cuDNN8.4
- base_2004_ws (archived)
    - cpu
    - gpu
        - CUDA11.6.2_cuDNN8.4
        - CUDA11.8.0_cuDNN8.7
        - CUDA12.1.1_cuDNN8.9
        - CUDA12.2.2_cuDNN8.9
        - CUDA12.5.1_cuDNN9.2
        - CUDA12.6.1_cuDNN9.3
- base_2204_ws
    - cpu
    - gpu
        - CUDA11.7.1_cuDNN8.5.0.96 (archived)
        - CUDA12.1.1_cuDNN8.9 (archived)
        - CUDA12.2.2_cuDNN8.9 (archived)
        - CUDA12.5.1_cuDNN9.2
        - CUDA12.6.3_cuDNN9.5
        - CUDA12.8.0_cuDNN9.7 (todo)
- ros_kinetic_basic_ws (archived)
    - cpu
    - gpu
        - CUDA9.0_cuDNN7.6
- ros_melodic_basic_l4t_ws (archived)
    - gpu
        - CUDA10.2_cuDNN8.2.1
- ros_melodic_basic_ws (archived)
    - cpu
    - gpu
        - CUDA10.1_cuDNN7.0
        - CUDA11.0_cuDNN8.0
        - CUDA11.2_cuDNN8.1
        - CUDA11.3_cuDNN8.2
        - CUDA11.6.2_cuDNN8.4
- ros_melodic_sobits_l4t_ws (archived)
    - gpu
        - CUDA10.2_cuDNN8.2.1
- ros_melodic_sobits_ws (archived)
    - cpu
    - gpu
        - CUDA11.6.2_cuDNN8.4
- ros_noetic_basic_ws (archived)
    - cpu
    - gpu
        - CUDA11.6.2_cuDNN8.4
        - CUDA12.1.1_cuDNN8.9
        - CUDA12.2.2_cuDNN8.9
        - CUDA12.5.1_cuDNN9.2
        - CUDA12.6.1_cuDNN9.3
- ros_noetic_sobits_ws (archived)
    - cpu
    - gpu
        - CUDA11.6.2_cuDNN8.4
        - CUDA12.1.1_cuDNN8.9
        - CUDA12.2.2_cuDNN8.9
        - CUDA12.5.1_cuDNN9.2
        - CUDA12.6.1_cuDNN9.3
- ros2_humble_basic_ws
    - cpu
    - gpu
        - CUDA11.7.1_cuDNN8.5.0.96 (archived)
        - CUDA12.1.1_cuDNN8.9 (archived)
        - CUDA12.2.2_cuDNN8.9 (archived)
        - CUDA12.5.1_cuDNN9.2
        - CUDA12.6.3_cuDNN9.5
        - CUDA12.8.0_cuDNN9.7 (todo)
- ros2_humble_sobits_ws
    - cpu
    - gpu
        - CUDA11.7.1_cuDNN8.5.0.96 (archived)
        - CUDA12.1.1_cuDNN8.9
        - CUDA12.2.2_cuDNN8.9
        - CUDA12.5.1_cuDNN9.2
        - CUDA12.6.3_cuDNN9.5
        - CUDA12.8.0_cuDNN9.7 (todo)

</p>
</details>


## Change-Log

- 2025/02/00
    - CUDA12.8.0_cuDNN9.7への対応
        - base_2204_ws
        - ros2_humble_basic_ws
        - ros2_humble_sobits_ws
    - 20.04がアーカイブに
        - base_2004_ws
        - ros_noetic_basic_ws
        - ros_noetic_sobits_ws

- 2024/12/00
    - CUDA12.6.3 cuDNN9.5への切り替え
        - CUDA12.6.1_cuDNN9.3を未対応
    - CUDA12.5.1_cuDNN9.2に対応
        - base_2004_ws
        - ros_noetic_basic_ws
        - ros_noetic_sobits_ws
        - base_2204_ws
        - ros2_humble_basic_ws
        - ros2_humble_sobits_ws
    - CUDA12.6.3 cuDNN9.5に対応
        - base_2204_ws
        - ros2_humble_basic_ws
        - ros2_humble_sobits_ws

- 2024/10/04
    - CUDA12.6.1 cuDNN9.3に対応
        - base_2004_ws
        - ros_noetic_basic_ws
        - ros_noetic_sobits_ws
    - PulseAudioが利用できない問題を解決
- 2024/08/20
    - CUDA12.6.0 cuDNN9.3に対応
        - base_2204_ws
        - ros2_humble_basic_ws
        - ros2_humble_sobits_ws
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