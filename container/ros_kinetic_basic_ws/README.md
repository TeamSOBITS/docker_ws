# ros_kinetic_basic_ws
## Container Environment
イメージからコンテナを起動すると以下の環境が構築されます（イメージサイズが14GBほどあるのでストレージ容量に注意）。
- Ubuntu : 16.04
- ROS : Kinetic
- OpenCV : 3.4.2 (3.3.1も入っているのでcatkin_makeの際は注意)
- Python : 2.7
- UserName : sobits

## How to run
```
#CPUの場合
cd ~/docker_ws/container/ros_kinetic_basic_ws/Dockerfiles/cpu

#GPUの場合(バージョンは各自で合わせる)
cd ~/docker_ws/container/ros_kinetic_basic_ws/Dockerfiles/gpu/CUDAxx_cuDNNxx/

#イメージのビルド
bash build.sh

#イメージからコンテナを起動
bash run.sh
```
コンテナが起動できたら、ウェブブラウザを開いて http://127.0.0.1:6080/ にアクセスしてください。  
デフォルトのrun.shで実行すると、ホストPCの /dev/video0 が使えます。

コンテナ内の catkin_ws/src は、ros_kinetic_basic_ws/src のボリュームを常に見るように設定しています（run.shを参照）。  



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
- ホストPCがUbuntu16.04の環境で動作確認済み(2020/10/01)
- 
