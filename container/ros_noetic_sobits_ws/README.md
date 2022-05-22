# ros_noetic_sobit_pro
## Container Environment
イメージからコンテナを起動すると以下の環境が構築されます（イメージサイズが22GBほどあるのでストレージ容量に注意）。
- Ubuntu : 20.04
- ROS : Noetic Ninjemys
- OpenCV : 4.5.5 (2021-12-30)
- Python : 3.8.10（デフォルト）
- UserName : sobits

## How to run
デフォルトではイメージとコンテナの名前は一緒にしています。  
同じイメージから複数のコンテナを立ち上げる場合はコンテナ同士の名前が被らないようにしてください。
```
#ホスト側のセットアップ
cd ~/docker_ws/container/ros_noetic_sobit_pro
bash sobit_pro_setup.sh #必要なパッケージのインストールや、SOBIT_PROのデバイス登録などの設定を行います。

#CPUの場合
cd ~/docker_ws/container/ros_noetic_sobit_pro/Dockerfiles/cpu
bash build.sh #docker hubにビルド済みのイメージを登録しているので、ローカルでビルドする必要はない。Dockerfileを書き換えた場合はビルドしてください。 
bash run.sh #コンテナの起動

#GPUの場合(バージョンは各自で合わせる)
cd ~/docker_ws/container/ros_noetic_sobit_pro/Dockerfiles/gpu/CUDAxx_cuDNNxx/
bash build.sh #コンテナの生成
bash run.sh #コンテナの起動

-----
#コンテナの終了
docker stop ros_noetic_sobit_pro  #docker stop <CONTAINER NAME or CONTAINER ID>

#コンテナを再起動する場合
docker start ros_noetic_sobit_pro #docker start <CONTAINER NAME or CONTAINER ID>

#コンテナの削除
docker rm ros_noetic_sobit_pro #docker rm <CONTAINER NAME or CONTAINER ID>

#イメージの削除
docker rmi ros_noetic_sobit_pro #docker rmi <IMAGE NAME or IMAGE ID>

```
コンテナが起動できたら、ウェブブラウザを開いて http://localhost:6080/ にアクセスしてください。  
デフォルトのrun.shで実行すると、ホストPCのデバイスが使えます。

コンテナ内の catkin_ws/src は、ros_noetic_basic_ws/src とリンクするように設定しています（run.shを参照）。  
ホストPC上でコーディングしながら、それをコンテナ内で実行することも可能です。  


## ROS Packages
`sobit_pro_setup.sh`を実行すると、以下のTeamSOBITSオリジナルROSパッケージがsrcフォルダの中にcloneされます。 
- sobit_pro
- sobit_common

## SOBIT_PRO USB files
`sobit_pro_setup.sh`を実行すると、以下の場所にUSB設定ファイルが作成されます。
これにより、デバイスを接続すると自動的にそのデバイスを検出することができます。 
- /etc/udev/rules.d/wheel.rules
- /etc/udev/rules.d/arm_pantilt.rules

これらを使用する際は、デバイス名を以下のように指定します。
- "/dev/wheel"
- "/dev/arm_pantilt"

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
- 2020/10/22
    - CUDA10.1 cuDNN7.0のGPU環境を構築
    - ホストPCがUbuntu18.04の環境でCPU/GPUともに動作確認済み
