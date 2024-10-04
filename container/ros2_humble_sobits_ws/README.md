# ros2_humble_sobits_ws

## Container Environment

`ros2_humble_sobits_ws`コンテナは以下の環境で構築されます．
- Ubuntu : 22.04 (Jammy Jellyfish)
- ROS : Humble Hawksbill 
- OpenCV : 4.9.0, 4.8.0, 4.6.0
- Python : 3.10.12 (デフォルト)
- UserName : sobits

> [!WARNING]
> イメージをビルドするには10GBほどのストレージが必要です．十分な容量を確保してください．

また，コンテナ内の `colcon_ws/src` は， `ros2_humble_sobits_ws/src` と接続されています．(run.shを参照) 
ホストPC上でコーディングしながら，それをコンテナ内で実行することも可能です．

> [!WARNING]
> コンテナ側で（`colcon_ws/src`以外のPATHに）作成したファイルに関してはホストPC側からアクセスできないので注意してください．


## Build Container

デフォルトではイメージとコンテナの名前は同じにしています． 
同じイメージから複数のコンテナを作成する場合は，コンテナ同士の名前が被らないようにしてください．


1. コンテナのフォルダをコピします．
```bash
$ cp -r {docker_wsのPATH}/container/ros2_humble_sobits_ws/ {コンテナPATH}
# 例: $ cp -r ~/docker_ws/container/ros2_humble_sobits_ws/ ~/
```
> **Warning**
> コピされたフォルダの名前を変えてください．
> 例: `ros2_humble_sobits_ws` → `my_new_ws`


2. Dockerfileからイメージをビルドします.
```bash
# GITを使うため，個人のTOKENを入力する
$ export GIT_PSW={PERSONAL_GIT_TOKEN_HERE}

# CPUの場合：
$ cd {コンテナPATH}/Dockerfiles/cpu
$ bash build.sh

# GPUの場合：
$ cd {コンテナPATH}/Dockerfiles/gpu/CUDAXX.X.X_cuDNNX.X
$ bash build.sh
```

3. イメージからコンテナを起動します．
```bash
$ bash run.sh 
# >> {コンテナ名} sobits@:~$　← この表示に切り替わる
```

4. 起動中のコンテナに別端末からアクセスします．
```bash
$ bash exec.sh
# >> {コンテナ名} sobits@:~$　← この表示に切り替わる
```
      
> **Note**
> コンテナから抜き出すために，`「Ctrl」+「d」`を同時に押すか，ターミナルに`exit`を入力するかです．


## Docker Commands

```bash
# 起動中のコンテナ一覧
$ docker container ls

# コンテナ一覧 (停止中のコンテナも含む)
$ docker container ls -a

# コンテナの停止
$ docker container stop {CONTAINER NAME or CONTAINER ID}

# コンテナの再起動
$ docker container start {CONTAINER NAME or CONTAINER ID}

# コンテナの削除(起動中のコンテナは削除できない)
$ docker container rm {CONTAINER NAME or CONTAINER ID}

# イメージのコンテナ一覧
$ docker image ls

# イメージの削除(コンテナが残っている場合は削除できない)
$ docker image rm {IMAGE NAME or IMAGE ID}
```

## 分散処理方法

### コンテナ-ホストPC間での分散処理

デフォルトだとコンテナとホストPCはbridge接続されています．  
- ホストPCのIP: 172.17.0.1  
- コンテナのIP: 172.17.0.X

`~/.bashrc`に`ROS_HOSTNAME`と`ROS_MASTER`の設定をすれば，分散処理が可能です．  
同一ホストPC上にあれば，複数コンテナ間でも分散処理できます．

現在の設定では，`コンテナのIP`と`ROS_HOSTNAME`を同じに設定しています．
`ROS_MASTER_URI`も`ROS_HOSTNAME`と同じにしているので他のコンテナと通信する際は，
`ROS_MASTER_URI`を`ROS_MASTER`を起動したコンテナのものに統一してください．

- MASTERコンテナ
```bash
$ echo "export ROS_MASTER_URI=http://172.17.0.2:11311" >> ~/.bashrc
$ echo "export ROS_HOSTNAME=172.17.0.2" >> ~/.bashrc
```
- 他のコンテナ
```bash
# ROS_MASTER_URIはMASTERコンテナに揃える
$ echo "export ROS_MASTER_URI=http://172.17.0.2:11311" >> ~/.bashrc
$ echo "export ROS_HOSTNAME=172.17.0.X" >> ~/.bashrc
```

### コンテナ-PC間での分散処理

ホストPC上のコンテナと，LANケーブルでつないでいるraspberry piやJetsonなどと分散処理する場合はこちらになります．  
まず，ホストPCと外部PC間で `ping` が通るようにネットワークの設定をしてください．

- 外部PCのIP:192.168.0.X
- ホストPCのIP:192.168.0.Y

<!-- この状態で `docker run` する際に，`-p 80:80 --network=host` の２つのオプションを付けてください．   -->
コンテナのIPがそのままホストPCのIPになります．

- 外部PCのIP：192.168.0.X
- ホストPCのIP：192.168.0.Y
- コンテナのIP：192.168.0.Y (デフォルトだと 172.17.0.x だったIPがホストPCと同じIPに変わる)

次には，`~/.bashrc`に`ROS_HOSTNAME`と`ROS_MASTER`の設定をすれば分散処理することができます．  
<!-- また，この場合でコンテナをGUIで開くときは，`http://127.0.0.1:80/` にアクセスしてください． -->


### 別々のホストPC上にあるコンテナ間での分散処理

調査中


## Alias commands

デフォルトで以下のエイリアスコマンドを設定しています．
- build
    <!-- - ``` cmd ```: `~/colcon_ws/src/` 内のすべての`python`や`sh`ファイルに対して`chmod`で実行権限を与える
    - ``` cmk ```: どのディレクトリにいてもcatkin_makeを実行する
    - ``` cm ```: 上記2つのコマンドをまとめて同時に実行する -->
    - ``` cbd ```: `~/colcon_ws/src/` 内のすべてのpythonやshファイルに対して`chmod`で実行権限を与える
    - ``` cbb ```: どのディレクトリにいても`colcon build`を実行する
    - ``` cb ```: 上記2つのコマンドをまとめて同時に実行する

- pip
    - ``` pip ``` : `python -m pip`
    - ``` pip2 ``` : `python2 -m pip` 
    - ``` pip3 ``` : `python3 -m pip`

- apt
    - ``` agi ``` : `sudo apt install`
    - ``` agr ``` : `sudo apt remove`
    - ``` agu ``` : `sudo apt update`

- ls
    - ``` ls ``` : `ls --color=auto`
    - ``` ll ``` : `ls -alF`

- cd
    <!-- - ``` cdc ``` : `cd ~/colcon_ws/src` -->
    - ``` .. ``` : `cd ..`
    - ``` ... ``` : `cd ../..`
    - ``` .... ``` : `cd ../../..`

- cp,mv,rm
    - ``` cp ``` : `cp -i`
    - ``` mv ``` : `mv -i`
    - ``` rm ``` : `rm -i`

- git
    - ``` g ``` : `git`
    - ``` ga ``` : `git add`
    - ``` gd ``` : `git diff`
    - ``` gs ``` : `git status`
    - ``` gp ``` : `git push`
    - ``` gb ``` : `git branch`
    - ``` gst ``` : `git status`
    - ``` gco ``` : `git checkout`
    - ``` gf ``` : `git fetch`
    - ``` gc ``` : `git commit`
    - ``` gcs() ``` : `git clone https://github.com/TeamSOBITS/$1.git`
