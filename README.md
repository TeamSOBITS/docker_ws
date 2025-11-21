<a name="readme-top"></a>

[JA](README.md) | [EN](README.en.md)

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![License][license-shield]][license-url]

# Docker Workspaces

<!-- 目次 -->
<details>
  <summary>目次</summary>
  <ol>
    <li>
      <a href="#概要">概要</a>
    </li>
    <li>
      <a href="#セットアップ">セットアップ</a>
      <ul>
        <li><a href="#環境条件">環境条件</a></li>
        <li><a href="#インストール方法">インストール方法</a></li>
      </ul>
    </li>
    <li>
        <a href="#実行操作方法">実行・操作方法</a>
              <ul>
        <li><a href="#コンテナのビルド方法">コンテナのビルド方法</a></li>
        <li><a href="#コンテナの削除方法">コンテナの削除方法   </a></li>
        <li><a href="#コンテナの実行操作方法">コンテナの実行・操作方法</a></li>
      </ul>       
    </li>
    <li><a href="#cuda-table">CUDA / Ubuntu / PyTorch 対応表</a></li>
    <li><a href="#マイルストーン">マイルストーン</a></li>
    <li><a href="#参考文献">参考文献</a></li>
  </ol>
</details>

<!-- レポジトリの概要 -->
## 概要

Docker環境セットアップの方法とDockerfileをまとめたリポジトリです．

<p align="right">(<a href="#readme-top">上に戻る</a>)</p>

## セットアップ
ここで，本レポジトリのセットアップ方法について説明します．
<p align="right">(<a href="#readme-top">上に戻る</a>)</p>

### 環境条件
まず，以下の環境を整えてから，次のインストール方法に進んでください．
| System  | Version |
| --- | --- |
| Ubuntu | 22.04 (Jammy Jellyfish) or 24.04 (Noble Numbat)|

> [!WARNING]
> `GPU版`のDockerを使用する場合は，必ず[Nvidia Driver](https://github.com/TeamSOBITS/sobits_manual/tree/main/install_sh#cuda)のインストールを済ませてください．
> CUDAやcuDNNをインストールすることは必要ではありません．

> [!WARNING]
> コンテナの作成には10GBほどのストレージが必要です．十分な容量を確保してください．

<p align="right">(<a href="#readme-top">上に戻る</a>)</p>

### インストール方法
既にコンテナをビルド済みで，別のコンテナをビルドしたい場合はこのセクションをスキップし，コンテナのビルド方法に進んでください．

1. 本レポジトリをcloneします．
    ```sh
    $ git clone https://github.com/TeamSOBITS/docker_ws.git
    ```
2. レポジトリの中のインストールのフォルダへ移動します．
    ```sh
    $ cd docker_ws/setup_sh
    ```
3. 必要なリソースをインストールします．
    ```sh
    $ bash install_docker.sh
    ```
    Dockerコンテナ内でGPUを使う場合．以下のコマンドも実行します．
    ```sh
    $ bash install_nvidia_docker.sh
    ```
    > [!WARNING]
    > `GPU版`のDockerをインストールする前に，必ず[Nvidia Driver](https://github.com/TeamSOBITS/sobits_manual/tree/main/install_sh#cuda)のインストールを済ませてください．
    > CUDAやcuDNNをインストールすることが必要ではありません．

4. コンテナを可視化するため，以下のコマンドを実行します．
    ```sh
    $ sudo apt-get update
    $ sudo apt-get install -y python3-tk tk-dev 
    ```
5. 以下を実行後，GUIが表示されたらインストール完了です．
    ```sh
    $ python3 -m tkinter
    ```

<p align="right">(<a href="#readme-top">上に戻る</a>)</p>

## 実行・操作方法

### コンテナのビルド方法
1. コンテナのフォルダを複製します．
    ```bash
    $ cp -r {docker_wsのPATH}/container/{使用するコンテナ}/ {コンテナの新PATH}
    # 例: $ cp -r ~/docker_ws/container/sobits_ws/ ~/
    ```

> [!WARNING]
> 複製されたフォルダの名前を変更してください．
> 例: `sobits_ws` → `my_new_ws`
> デフォルトではイメージとコンテナの名前は同じにしています．
> 同じイメージから複数のコンテナを作成する場合は，コンテナの名前が被らないようにしてください．

2. このプロジェクトではDocker Composeを使用しているため，コンテナをビルドする前に、[env.sh](container/sobits_ws/docker/env.sh)ファイルの設定を行う必要があります．
    ```bash
    $ cd {コンテナPATH}/docker
    $ gedit env.sh  # または任意のエディタで編集
    ```

    [env.sh](container/sobits_ws/docker/env.sh)ファイルの設定例：
    ```sh
    UBUNTU_VERSION="22.04"  # 使用するUbuntuのバージョン
    COMPUTE_TYPE="gpu"      # gpuもしくはcpuを選択
    CUDA_VERSION="12.6.0"   # COMPUTE_TYPEがgpuの場合に使用するCUDAバージョン

    INSTALL_ROS="true"      # ROSのインストール
    INSTALL_GAZEBO="true"   # Gazeboのインストール
    INSTALL_PYTORCH="true"  # PyTorchのインストール
    INSTALL_CV2="true"      # OpenCVのインストール

    ROS_DISTRO="humble"     # 使用するROSのディストリビューション
    ROS_DOMAIN_ID="30"      # 使用するROSのドメインID
    PYTORCH_VERSION="2.8.0" # 使用するPyTorchのバージョン
    CV2_VERSION="4.12.0"    # 使用するOpenCVのバージョン

    USERNAME=$(whoami)      # 使用するユーザー名
    ```

> [!NOTE]
> ROSのバージョンはROS2のみ選択可能です。

> [!TIP]
> ubuntuのバージョンと対応するcudaのバージョンを[下の表](#cuda-table)に記載しています。

3. Dockerfileからイメージをビルドします.
    ```bash
    $ cd {コンテナPATH}/docker
    $ bash build.sh
    ```

4. イメージからコンテナを起動します．
    ```bash
    $ bash up.sh 
    ```

5. 起動中のコンテナに別端末からアクセスします．
    ```bash
    $ bash exec.sh
    # >> {コンテナ名} username@:~$　← この表示に切り替わる
    ```

> [!NOTE]
>コンテナ内の `colcon_ws/src`がローカルの`{コンテナPATH}/src`と接続されていますので，そのフォルダ内のデータのみ共有可能となります．

> [!TIP]
> コンテナから抜き出すために，`「Ctrl」+「d」`を同時に押すか，ターミナルに`exit`を入力するかです．

<p align="right">(<a href="#readme-top">上に戻る</a>)</p>

### コンテナの削除方法
作成したコンテナを停止して削除します。
```bash
$ bash down.sh
```

<p align="right">(<a href="#readme-top">上に戻る</a>)</p>

### コンテナの実行・操作方法

![Container Executer](img/container_executer.png)

ビルドされたコンテナの一覧を表示し，それらを起動・再起動・停止・ターミナルの操作ができます．

[install_docker.sh](setup_sh/install_docker.sh)で設定した`alias`を用いて，コンテナの一覧を表示するために，以下のコマンドを入力します．

```bash
$ ce
```

> [!NOTE]
> このコマンドは自分がいるPATHに依存していないため，どこでも実行可能です．

<p align="right">(<a href="#readme-top">上に戻る</a>)</p>


<a id="cuda-table"></a>

## CUDA / Ubuntu / PyTorch 対応表


| CUDA Version   | Ubuntu 22.04 | Ubuntu 24.04 | PyTorch Versions |
|:--------------:|:------------:|:------------:|:------------:|
| 12.4.1         | ✓            | -            | 2.4.0, 2.4.1, 2.5.0, 2.5.1, 2.6.0 |
| 12.5.1         | ✓            | -            | - |
| 12.6.0         | ✓            | ✓            | 2.6.0, 2.7.0, 2.7.1,  2.8.0 |
| 12.6.1         | ✓            | ✓            | 2.6.0, 2.7.0, 2.7.1,  2.8.0 |
| 12.6.2         | ✓            | ✓            | 2.6.0, 2.7.0, 2.7.1,  2.8.0 |
| 12.6.3         | ✓            | ✓            | 2.6.0, 2.7.0, 2.7.1,  2.8.0 |
| 12.8.0         | ✓            | ✓            | 2.7.0, 2.7.1, 2.8.0 |
| 12.8.1         | ✓            | ✓            | 2.7.0, 2.7.1, 2.8.0 |
| 12.9.0         | ✓            | ✓            | 2.8.0 |
| 12.9.1         | ✓            | ✓            | 2.8.0 |
| 13.0.0         | ✓            | ✓            | 未対応 |

<p align="right">(<a href="#readme-top">上に戻る</a>)</p>


## Docker コンテナ一覧

用意されているコンテナ一覧です．


<details><summary>用意されているコンテナ一覧</summary>
<p>

- sobits_ws

</p>
</details>

<p align="right">(<a href="#readme-top">上に戻る</a>)</p>

## マイルストーン

現時点のバッグや新規機能の依頼を確認するためにIssueページ をご覧ください．


- 2025/10/27
    - OpenCV用のDockerfile作成
    - OpenCVのためのマルチステージ
    - OpenCV 4.12.0にアップデート(DockerHubに対応)
- 2025/08/20
    - PyTorchインストール(via pip)
    - CUDA/Ubuntu/PyTorch対応表の追加
- 2025/08/20
    - 環境ファイルをenv.shに変更
    - PROJECT_NAMEを追加し、同じサービス名で複数の環境を作成できるように
- 2025/08/17
    - マルチステージビルド化しDockerfileを一つに管理

- 2025/08/01
    - docker composeへの対応
        - UBUNTU,  CUDA, ROSのバージョン変更を簡易に 

- 2025/05/15
    - CUDA12.8.1_cuDNN9.8への対応
        - base_2204_ws
        - ros2_humble_basic_ws
        - ros2_humble_sobits_ws
    - OpenCV 4.11.0にアップデート

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


<p align="right">(<a href="#readme-top">上に戻る</a>)</p>

## 参考文献

Docker上の環境構築や使い方についてより詳しく知りたい場合は，以下のサイトのドキュメントを読んでみてください．

- SOBITS Manual: [Docker Workspaceの使用方法](https://github.com/TeamSOBITS/sobits_manual/blob/main/docs/using_docker_ws.md)
- 公式サイト: [Docker Docs](https://docs.docker.com/)

<p align="right">(<a href="#readme-top">上に戻る</a>)</p>


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/TeamSOBITS/docker_ws.svg?style=for-the-badge
[contributors-url]: https://github.com/TeamSOBITS/docker_ws/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/TeamSOBITS/docker_ws.svg?style=for-the-badge
[forks-url]: https://github.com/TeamSOBITS/docker_ws/network/members
[stars-shield]: https://img.shields.io/github/stars/TeamSOBITS/docker_ws.svg?style=for-the-badge
[stars-url]: https://github.com/TeamSOBITS/docker_ws/stargazers
[issues-shield]: https://img.shields.io/github/issues/TeamSOBITS/docker_ws.svg?style=for-the-badge
[issues-url]: https://github.com/TeamSOBITS/docker_ws/issues
[license-shield]: https://img.shields.io/github/license/TeamSOBITS/docker_ws.svg?style=for-the-badge
[license-url]: LICENSE