# ros_melodic_basic_ws
## Container Environment
イメージからコンテナを起動すると以下の環境が構築されます（イメージサイズが22GBほどあるのでストレージ容量に注意）。
- Ubuntu : 18.04
- ROS : Melodic
- OpenCV : 3.4.2 (3.3.1も入っているのでcatkin_makeの際は注意)
- Python : 2.7-3.6 (デフォルト:2.7)
- UserName : sobits

## How to run
デフォルトではイメージとコンテナの名前は一緒にしています。  
同じイメージから複数のコンテナを立ち上げる場合はコンテナ同士の名前が被らないようにしてください。
```
#CPUの場合
cd ~/docker_ws/container/ros_melodic_basic_ws/Dockerfiles/cpu
#bash build.sh #docker hubにビルド済みのイメージを登録しているので、ローカルでビルドする必要はない。Dockerfileを書き換えた場合はビルドしてください。 
bash run.sh #コンテナの起動

#GPUの場合(バージョンは各自で合わせる)
cd ~/docker_ws/container/ros_melodic_basic_ws/Dockerfiles/gpu/CUDAxx_cuDNNxx/
bash build.sh #コンテナの生成
bash run.sh #コンテナの起動

-----
#コンテナの終了
docker stop ros_melodic_basic_ws  #docker stop <CONTAINER NAME or CONTAINER ID>

#コンテナを再起動する場合
docker start ros_melodic_basic_ws #docker start <CONTAINER NAME or CONTAINER ID>

#コンテナの削除
docker rm ros_melodic_basic_ws #docker rm <CONTAINER NAME or CONTAINER ID>

#イメージの削除
docker rmi ros_melodic_basic_ws #docker rmi <IMAGE NAME or IMAGE ID>

```
コンテナが起動できたら、ウェブブラウザを開いて http://127.0.0.1:6080/ にアクセスしてください。  
デフォルトのrun.shで実行すると、ホストPCのデバイスが使えます。

コンテナ内の catkin_ws/src は、ros_melodic_basic_ws/src とリンクするように設定しています（run.shを参照）。  
ホストPC上でコーディングしながら、それをコンテナ内で実行することも可能です。  


## ROS Packages
`git_clone_ros_packages.sh`を実行すると、以下のTeamSOBITSオリジナルROSパッケージがsrcフォルダの中にcloneされます。 
- sobit_common
- web_speech_recognition
- display_text
- text_to_speech
- ssd_node


## 分散処理の方法
- #### コンテナとホストPC間での分散処理

    デフォルトだとコンテナとホストPCはbridge接続されています。  
    - ホストPCのIP：172.17.0.1  
    - コンテナのIP：172.17.0.x

    .bashrcにROSIPとROS_MASTERの設定をすれば、分散処理が可能です。  
    同一ホストPC上にあれば、複数コンテナ間でも分散処理できます。

- #### コンテナと外部ネットワーク上にあるROSノード間での分散処理  
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


- #### 別々のホストPC上にあるコンテナ間での分散処理
    調査中

## Alias commands
デフォルトで以下のエイリアスコマンドを設定しています。
- cmd
    - ~/catkin_ws/src/ 内のすべてのpython fileに対してchmodを行う
- cmk
    - どのディレクトリにいてもcatkin_makeを実行することができる
- cm
    - 上記2つのコマンドを同時に実行する
- gpa
    - ~/catkin_ws/src 内のすべてのrosパッケージに対してgit pullを行う

## Tips

## memo
- 2020/10/01
    - CUDA11.0 cuDNN8.0のGPU環境を構築 
    - ホストPCがUbuntu18.04の環境でCPU/GPUともに動作確認済み
