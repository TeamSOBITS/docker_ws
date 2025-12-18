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
        <li><a href="#コンテナの実行操作方法">コンテナの実行・操作方法</a></li>
      </ul>       
    </li>
    <li><a href="#cuda-table">CUDA / Ubuntu / PyTorch 対応表</a></li>
    <li><a href="#トラブルシューティング">トラブルシューティング</a></li>
    <li><a href="#コンテナの削除方法">コンテナの削除方法   </a></li>
    <li><a href="#イメージの削除方法">イメージの削除方法   </a></li>
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
> `GPU版`のDockerを使用する場合は，必ず[Nvidia Driver](https://docs.nvidia.com/datacenter/tesla/driver-installation-guide/ubuntu.html)のインストールを済ませてください．
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
1. `sobits_ws`のディレクトリをディレクトリごとコピーし，Homeディレクトリなどに貼り付けてください．
    - この際，複製されたフォルダの名前を変更してください．
    - 例: `sobits_ws` → `my_new_ws`
    - コンテナの名前が被らないようにしてください．

2. コピーして名前を変更した`sobits_ws`ディレクトリの[env.sh](container/sobits_ws/docker/env.sh)ファイルを開いてください．

    [env.sh](container/sobits_ws/docker/env.sh)ファイルの設定例：
    ```sh
    export DOCKERHUB_USERNAME="sobits"

    # -- Base System Configuration --
    export UBUNTU_VERSION="22.04"

    # -- GPU / CPU Configuration --
    # Set to "true" to build the GPU-enabled container, "false" for CPU-only.
    export COMPUTE_TYPE="gpu"    # Options: "cpu" or "gpu"
    export CUDA_VERSION="12.8.1" # Required only if COMPUTE_TYPE is "gpu"

    # -- Component Installation Flags --
    export INSTALL_ROS="true"       # Set to "true" or "false"
    export INSTALL_GAZEBO="true"    # Set to "true" or "false"
    export INSTALL_PYTORCH="false"  # Set to "true" or "false"
    export INSTALL_CV2="false"      # Set to "true" or "false"

    # -- Component Versions --
    export ROS_DISTRO="humble"     # ROS 1: "noetic", ROS 2: "humble", "jazzy"
    export ROS_DOMAIN_ID="0"       # Applicable only for ROS 2
    export PYTORCH_VERSION="2.9.0" # PyTorch version 
    export CV2_VERSION="4.12.0"    # OpenCV version

    # -- ROS Workspace --
    export ROS_WORKSPACE="colcon_ws" # ROS workspace name
    ```

> [!TIP]
> Ubuntuのバージョンと対応するCUDAのバージョンを[下の表](#cuda-table)に記載しています。

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

- CUDAについて，ローカル環境に入っているNvidia Driverが対応している最大のCUDAのバージョンより高いバージョンのCUDAをDockerで入れることはできません．
- 以下のコマンドで右上に出力されるものが，対応している最大のCUDAバージョンです．
```sh
nvidia-smi
```

| CUDA Version   | Ubuntu 22.04 | Ubuntu 24.04 | PyTorch Versions |
|:--------------:|:------------:|:------------:|:------------:|
| 12.4.1         | ✓            | -            | 2.4.0, 2.4.1, 2.5.0, 2.5.1, 2.6.0 |
| 12.5.1         | ✓            | -            | - |
| 12.6.0         | ✓            | ✓            | 2.6.0, 2.7.0, 2.7.1,  2.8.0, 2.9.0 |
| 12.6.1         | ✓            | ✓            | 2.6.0, 2.7.0, 2.7.1,  2.8.0 |
| 12.6.2         | ✓            | ✓            | 2.6.0, 2.7.0, 2.7.1,  2.8.0 |
| 12.6.3         | ✓            | ✓            | 2.6.0, 2.7.0, 2.7.1,  2.8.0 |
| 12.8.0         | ✓            | ✓            | 2.7.0, 2.7.1, 2.8.0,  2.9.0 |
| 12.8.1         | ✓            | ✓            | 2.7.0, 2.7.1, 2.8.0 |
| 12.9.0         | ✓            | ✓            | 2.8.0 |
| 12.9.1         | ✓            | ✓            | 2.8.0 |
| 13.0.0         | ✓            | ✓            | 2.9.0 |

詳細は[Installing previous versions of PyTorch](https://pytorch.org/get-started/previous-versions/)を確認してください．

<p align="right">(<a href="#readme-top">上に戻る</a>)</p>


## トラブルシューティング

- `bash buid.sh`実行時に，Dockerが指定されたイメージをDocker Hubで見つけることができなかったというエラーが出た場合

    - 例
    ```sh
    failed to solve: sobits/pytorch:3.8.0-cuda12.8-ubuntu22.04: failed to resolve source metadata for docker.io/sobits/pytorch:3.8.0-cuda12.8-ubuntu22.04: docker.io/sobits/pytorch:3.8.0-cuda12.8-ubuntu22.04: not found
    ```

    - 対処法
        - [Docker Hub](https://hub.docker.com/u/sobits)にイメージがないので，dockerにログインしてから，ビルドしてアップロードしてください．

        - 例： opencvがない場合       
            ```sh
            bash buid.sh opencv
            ```
            足りないものをすべてビルドした後に
            ```sh
            "Build complete. Do you want to push this image to Docker Hub? (y/N) "
            ```
            と言われるのでdocker hubにpushするか選択してください

<p align="right">(<a href="#readme-top">上に戻る</a>)</p>

### コンテナの削除方法
作成したコンテナを停止して削除します。
```bash
$ cd {コンテナPATH}/docker
$ bash down.sh
```

<p align="right">(<a href="#readme-top">上に戻る</a>)</p>

### イメージの削除方法

特定のイメージを削除するコマンド
```
docker rmi <イメージ名またはID>
```
- 削除後は```docker images```で削除されたか確認すること


<p align="right">(<a href="#readme-top">上に戻る</a>)</p>

## マイルストーン

現時点のバッグや新規機能の依頼を確認するためにIssueページ をご覧ください．

<p align="right">(<a href="#readme-top">上に戻る</a>)</p>

## 参考文献

Docker上の環境構築や使い方についてより詳しく知りたい場合は，以下のサイトのドキュメントを読んでみてください．

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