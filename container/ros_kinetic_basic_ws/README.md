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

- VNC-Server  
    1. Dockerfileがある階層まで移動(例としてcpu版の実行手順を示します)
        ```
        cd ~/docker_ws/container/ros_kinetic_basic_ws/Dockerfiles/VNC-Server/cpu
        ```

    2. Dockerfileからイメージをビルド 
        ```
        bash build.sh
        ```
        
        - ※ DockerfileでOpenCVのビルドをしている場合は時間がかかるので要注意  
            DockerHubにpush済みのイメージを持ってくることも可能  
            ```
            #https://hub.docker.com/u/sobits pull可能なイメージはここで確認
            docker pull sobits/xxxxxxxxxx 
            ```

    3. イメージからコンテナを起動
        ```
        bash run.sh 
        ```
        コンソールが流れ始めたらOK
    
    4. http://127.0.0.1:6080/ にアクセス
    
- CUI
    1. Dockerfileがある階層まで移動(例としてcpu版の実行手順を示します)
        ```
        cd ~/docker_ws/container/ros_kinetic_basic_ws/Dockerfiles/CUI/cpu
        ```

    2. Dockerfileからイメージをビルド 
        ```
        bash build.sh
        ```
        
        - ※ DockerfileでOpenCVのビルドをしている場合は時間がかかるので要注意  
            DockerHubにpush済みのイメージを持ってくることも可能  
            ```
            #https://hub.docker.com/u/sobits pull可能なイメージはここで確認
            docker pull sobits/xxxxxxxxxx 
            ```

    3. イメージからコンテナを起動
        ```
        bash run.sh 
        >> root@e44dd2e39c7c:/home/sobits#　←この表示がでればOK 
        ```
        ``` exit ``` と入力すればコンテナから抜けれる。

    4. 起動中のコンテナに別端末からアクセスする方法
        ```
        bash exec.sh
        >> root@e44dd2e39c7c:/home/sobits#　←この表示がでればOK 
        ```
        しかし、 ``` docker exec ``` でアクセスした場合はDockerfileに記述したENTRYPOINTやCMDが実行されないので、~/.bashrcは読み込まれない。  
        手動で ``` source ~/catkin_ws/devel/setup.bash ``` すればros周りの機能は特に問題なく使える。  
        Dockerは本来、プロセスごとにコンテナを切り分けて使うのが主流なので、 ``` docker exec ``` の使用は非推奨。  


## Docker commands
```
#起動中のコンテナ一覧
docker ps

#コンテナ一覧（停止中も含む）
docker ps -a

#コンテナの停止
docker stop ros_kinetic_basic_ws  #docker stop <CONTAINER NAME or CONTAINER ID>

#コンテナの再起動
docker start ros_kinetic_basic_ws #docker start <CONTAINER NAME or CONTAINER ID>

#コンテナの削除(起動中のコンテナは削除できない)
docker rm ros_kinetic_basic_ws #docker rm <CONTAINER NAME or CONTAINER ID>

#イメージの削除(コンテナが残っている場合は削除できない)
docker rmi ros_kinetic_basic_ws #docker rmi <IMAGE NAME or IMAGE ID>

```

コンテナ内の catkin_ws/src は、ros_kinetic_basic_ws/src とリンクするように設定しています（run.shを参照）。  
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
    - CUDA9.0 cuDNN7のGPU環境を構築 
    - ホストPCがUbuntu16.04の環境でCPU/GPUともに動作確認済み
