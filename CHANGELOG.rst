^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Changelog for package docker_ws
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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