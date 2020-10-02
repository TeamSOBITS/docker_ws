# ros_kinetic_basic_ws
## Container Environment
イメージからコンテナを起動すると以下の環境が構築されます（イメージサイズが14GBほどあるのでストレージ容量に注意）。
- Ubuntu : 16.04
- ROS : Kinetic
- OpenCV : 3.4.2 (3.3.1も入っているのでcatkin_makeの際は注意)
- Python : 2.7
- UserName : sobits

## How to run
デフォルトではイメージとコンテナの名前は一緒にしています。  
同じイメージから複数のコンテナを立ち上げる場合はコンテナ同士の名前が被らないようにしてください。
```
#CPUの場合
cd ~/docker_ws/container/ros_kinetic_basic_ws/Dockerfiles/cpu

#GPUの場合(バージョンは各自で合わせる)
cd ~/docker_ws/container/ros_kinetic_basic_ws/Dockerfiles/gpu/CUDAxx_cuDNNxx/

#イメージのビルド
bash build.sh

#イメージからコンテナを生成
bash run.sh

#コンテナの終了
docker stop ros_kinetic_basic_ws  #docker stop <CONTAINER NAME or CONTAINER ID>

#コンテナを再起動する場合
docker start ros_kinetic_basic_ws #docker start <CONTAINER NAME or CONTAINER ID>

#コンテナの削除
docker rm ros_kinetic_basic_ws #docker rm <CONTAINER NAME or CONTAINER ID>

#イメージの削除
docker rmi ros_kinetic_basic_ws #docker rmi <IMAGE NAME or IMAGE ID>

```
コンテナが起動できたら、ウェブブラウザを開いて http://127.0.0.1:6080/ にアクセスしてください。  
デフォルトのrun.shで実行すると、ホストPCの /dev/video0 が使えます。

コンテナ内の catkin_ws/src は、ros_kinetic_basic_ws/src とリンクするように設定しています（run.shを参照）。  
ホストPC上でコーディングしながら、それをコンテナ内で実行することも可能です。  





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
    - CUDA9.0 cuDNN7のGPU環境を構築 
    - ホストPCがUbuntu16.04の環境でCPU/GPUともに動作確認済み
