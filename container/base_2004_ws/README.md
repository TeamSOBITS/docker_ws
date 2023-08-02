# base_2004_ws
## Container Environment

イメージからコンテナを起動すると以下の環境が構築されます。

> **Warning**
> このイメージサイズをビルドするには、22GBほどのでストレージ容量を確保する必要があります。

特長：
- Ubuntu　　: 20.04
- ROS　　　 : Noetic Ninjemys
- OpenCV　　: 4.6.0 (2022-1-21)
- Python　  : 3.8.10（デフォルト）
- User Name : sobits

## How to run

デフォルトではイメージとコンテナの名前は一緒にしています。 
同じイメージから複数のコンテナを立ち上げる場合はコンテナ同士の名前が被らないようにしてください。


1. コンテナのフォルダをコピします。
```bash
$ cp -r ~/docker_ws/container/base_2004_ws/ ~/
```
> **Warning**
> コピされたフォルダの名前を変えてください。
> 例：コンテナ名 =「ub2004_ws」

> **Warning**
> これから、{コンテナ名}を書く時、変えたフォルダ名のことを表しています。そのまま、{コンテナ名}を入力しないでください。

2. Dockerfileからイメージをビルドします。
```bash
#CPUのみの場合：
$ cd ~/{コンテナ名}/Dockerfiles/cpu
$ bash build.sh

#GPU付きの場合：
$ cd ~/{コンテナ名}/Dockerfiles/gpu/CUDAXX.X.X_cuDNNX.X
$ bash build.sh
```

3. イメージからコンテナを起動
```bash
$ bash run.sh 
# >> container sobits@:~$　←この表示がでればOK 
```

4. 起動中のコンテナに別端末からアクセスする方法
```bash
$ bash exec.sh
# >> container sobits@:~$　←この表示がでればOK 
```
      
> **Note**
> `「Ctrl」+「d」`を押すと、同様にコンテナから抜けられます。  


## Docker commands

```bash
#起動中のコンテナ一覧
$ docker ps

#コンテナ一覧（停止中も含む）
$ docker ps -a

#コンテナの停止
$ docker stop {コンテナ名}  #docker stop <CONTAINER NAME or CONTAINER ID>

#コンテナの再起動
$ docker start {コンテナ名} #docker start <CONTAINER NAME or CONTAINER ID>

#コンテナの削除(起動中のコンテナは削除できない)
$ docker rm {コンテナ名} #docker rm <CONTAINER NAME or CONTAINER ID>

#イメージの削除(コンテナが残っている場合は削除できない)
$ docker rmi sobits/{コンテナ名} #docker rmi <IMAGE NAME or IMAGE ID>
```

コンテナ内の catkin_ws/src は、{コンテナ名}/src とリンクするように設定しています（run.shを参照）。  
ホストPC上でコーディングしながら、それをコンテナ内で実行することも可能です。  (CUIの場合、コンテナ側で作成したファイルに関してはホストPC側からアクセスできないので要注意)


## 分散処理の方法
#### コンテナとホストPC間での分散処理

デフォルトだとコンテナとホストPCはbridge接続されています。  
- ホストPCのIP：172.17.0.1  
- コンテナのIP：172.17.0.x

.bashrcにROSIPとROS_MASTERの設定をすれば、分散処理が可能です。  
同一ホストPC上にあれば、複数コンテナ間でも分散処理できます。

※現在の設定では、コンテナのIPとROS_IPを同じに設定しています。
　ROS_MASTER_URIもROS_IPと同じにしているので他のコンテナと通信する際は、
　ROS_MASTER_URIをROS_MASTERを起動したコンテナのものに統一してください。

- MASTERコンテナのROS_IP：172.17.0.2
- ROS_MASTER_URI：http://172.17.0.2:11311

- 他のコンテナのROS_IP：172.17.0.x
- ROS_MASTER_URI：http://172.17.0.2:11311　<-MASTERコンテナに揃える！


#### コンテナと外部ネットワーク上にあるROSノード間での分散処理  

ホストPC上のコンテナと、LANケーブルでつないでいるraspberry piやJetsonなどと分散処理する場合はこちらになります。  
まずはじめに、ホストPCと外部PC間でpingが通るようにネットワークの設定をしてください。

- 外部PCのIP：192.168.0.2
- ホストPCのIP：192.168.0.3

この状態で docker run する際に、" -p 80:80 --network=host"の２つのオプションを付けてください。  
こうすることで、コンテナのIPがそのままホストPCのIPになります。

- 外部PCのIP：192.168.0.2
- ホストPCのIP：192.168.0.3
- コンテナのIP：192.168.0.3 (デフォルトだと 172.17.0.x だったIPがホストPCと同じIPに変わる)

あとは、.bashrcにROSIPとROS_MASTERの設定をすれば分散処理することができます。  
また、この場合でコンテナをGUIで開くときは、http://127.0.0.1:80/ にアクセスしてください。  


#### 別々のホストPC上にあるコンテナ間での分散処理

調査中

## Tips

調査中

## Changelog

- 2023/08/02
    - CUDA12.1.1 cuDNN8.9に対応
    - トークンの削除
    - Layerのコピの省略
    - 必要なパッケージの縮小
- 2023/01/21 (RCJP22向け)
    - CUDA11.8.0 cuDNN8.7の環境構築
    - ホストPCがUbuntu22.04の環境でCPU/GPUともに動作確認（済）
    - ホストPCがUbuntu20.04の環境でCPU/GPUともに動作確認（未）
- 2022/05/28
    - CUDA11.6.2 cuDNN8.4の環境構築
    - ホストPCがUbuntu20.04の環境でCPU/GPUともに動作確認（済）
