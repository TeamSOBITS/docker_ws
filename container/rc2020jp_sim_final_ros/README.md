# rc2020jp_sim_final_ros
ロボカップ２０２０ジャパンオープン
## Container Environment
- Ubuntu : 16.04
- ROS : Kinetic
- OpenCV : 3.4.2
- Python : 2.7
- Tensorflow-GPU : 1.5.0
- UserName : sobits
- CUDA : 9.0
- cuDNN : 7.0.5

## How to run
デフォルトではイメージとコンテナの名前は一緒にしています。  
同じイメージから複数のコンテナを立ち上げる場合はコンテナ同士の名前が被らないようにしてください。
```
#GPUの場合(バージョンは各自で合わせる)
cd ~/docker_ws/container/rc2020jp_sim_final_ros
bash build.sh #コンテナの生成
bash run.sh #コンテナの起動
```
コンテナが起動できたら、ウェブブラウザを開いて http://127.0.0.1:6080/ にアクセスしてください。  
デフォルトのrun.shで実行すると、ホストPCの /dev/video0 が使えます。

ホストPC上でコーディングしながら、それをコンテナ内で実行することも可能です。  


## ROS Packages
`git_clone_ros_packages.sh`を実行すると、以下のTeamSOBITSオリジナルROSパッケージがsrcフォルダの中にcloneされます。
- display_text
- ssd_node

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
- 2020/10/05
    - 新規作成
