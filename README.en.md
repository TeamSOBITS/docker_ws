<a name="readme-top"></a>

[JA](README.md) | [EN](README_en.md)

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![License][license-shield]][license-url]

# Docker Workspaces

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#introduction">Introduction</a>
    </li>
    <li>
      <a href="getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li>
      <a href="#launch-and-usage">Launch and Usage</a>
      <ul>
        <li><a href="#building-containers">Building Containers</a></li>
        <li><a href="#starting-and-managing-containers">Starting and Managing Containers</a></li>
      </ul>
    </li>
    <li><a href="#cuda-compatibility">CUDA / Ubuntu / PyTorch Compatibility</a></li>
    <li><a href="#troubleshooting">Troubleshooting</a></li>
    <li><a href="#removing-containers">Removing Containers</a></li>
    <li><a href="#deleting-images">Deleting Images</a></li>
    <li><a href="#milestones">Milestones</a></li>
    <li><a href="#references">References</a></li>
  </ol>
</details>

<!-- INTRODUCTION -->
## Introduction

This repository summarizes methods to set up Docker environments and build Dockerfiles.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- Getting Started -->
## Getting Started

This section explains how to set up this repository.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Prerequisites

Please ensure the following environment is prepared before proceeding with the next installation steps:

| System  | Version |
| --- | --- |
| Ubuntu | 22.04 (Jammy Jellyfish) or 24.04 (Noble Numbat) |

> [!WARNING]
> When using the `GPU version` of Docker, ensure that the [Nvidia Driver](https://github.com/TeamSOBITS/sobits_manual/tree/main/install_sh#cuda) is installed.
> CUDA or cuDNN installations are not required.

> [!WARNING]
> Docker container creation requires approximately 10GB of storage. Ensure sufficient space is available.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Installation

If you already have pre-built containers and want to build additional ones, skip this section and proceed to the **Building Containers** section.

1. Clone the repository.
    ```sh
    $ git clone https://github.com/TeamSOBITS/docker_ws.git
    ```
2. Move to the `setup_sh` folder within the repository.
    ```sh
    $ cd docker_ws/setup_sh
    ```
3. Install the required resources.
    ```sh
    $ bash install_docker.sh
    ```
    If you intend to use GPU inside Docker containers.
    ```sh
    $ bash install_nvidia_docker.sh
    ```

> [!WARNING]
> Before installing the `GPU version` of Docker, ensure that the [Nvidia Driver](https://github.com/TeamSOBITS/sobits_manual/tree/main/install_sh#cuda) is installed.
> CUDA or cuDNN installations are not required.

4. To enable GUI functionality for containers, install the following packages.
    ```sh
    $ sudo apt-get update
    $ sudo apt-get install -y python3-tk tk-dev 
    ```

5. Verify the installation. If a GUI appears, the setup is complete.
    ```sh
    $ python3 -m tkinter
    ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- Launch and Usage -->
## Launch and Usage

### Building Containers

1. Copy the `sobits_ws` directory and paste it into a new location (e.g., the Home directory). 
    - Example: Rename `sobits_ws` → `my_new_ws`
    - Change its name to identify it uniquely.

2. Open the [env.sh](container/sobits_ws/docker/env.sh) file in your newly duplicated `sobits_ws` directory.

   Example configuration for `env.sh`:
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
> [!NOTE]
> If using ROS1, change `ROS_WORKSPACE` to `catkin_ws`.

> [!TIP]
> Refer to the [CUDA / Ubuntu / PyTorch Compatibility](#cuda-compatibility) for supported versions.

3. Build the Docker image from the Dockerfile.
    ```bash
    $ cd {path-to-container}/docker
    $ bash build.sh
    ```

4. Use the built image to start a new container.
    ```bash
    $ bash up.sh 
    ```

5. Access the running container from another terminal session.
    ```sh
    $ bash exec.sh
    # Output: {container-name} username@:~$ (you are now inside)
    ```

> [!NOTE]
> Because `colcon_ws/src` in the container is connected to the local `{container PATH}/src`, only the data in that folder can be shared.

> [!TIP]
> Exit the container using either `Ctrl + D` or typing `exit` in the terminal.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Starting and Managing Containers

Manage built containers effortlessly from the Container Executer GUI.

![Container Executer](img/container_executer.png)

All containers can be listed, started, restarted, stopped, or a terminal can be opened.

Enter the following command to display a list of containers using the `alias` set in [install_docker.sh](setup_sh/install_docker.sh).

```bash
$ ce
```

> [!NOTE]
> This command is location-independent and can be executed from any path.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<a id="cuda-compatibility"></a>

<!-- CUDA / Ubuntu / PyTorch Compatibility -->
## CUDA / Ubuntu / PyTorch Compatibility

- For CUDA, you cannot use Docker to install a version of CUDA higher than the maximum version of CUDA supported by the Nvidia Driver in your local environment.
- The following command will output the maximum supported CUDA version in the upper right corner of the screen.
```sh
$ nvidia-smi
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



> [!NOTE]
> See [Installing previous versions of PyTorch](https://pytorch.org/get-started/previous-versions/) for further details.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- Troubleshooting -->
## Troubleshooting

### Build Error

- If you get an error when running `bash buid.sh` that Docker could not find the specified image in the Docker Hub:
- Example:
```sh
failed to solve: sobits/pytorch:3.8.0-cuda12.8-ubuntu22.04: failed to resolve source metadata for docker.io/sobits/pytorch:3.8.0-cuda12.8-ubuntu22.04: docker.io/sobits/pytorch:3.8.0-cuda12.8-ubuntu22.04: not found

```
- Solution.
        - Since there is no image in [Docker Hub](https://hub.docker.com/u/sobits), please login to docker, build and upload the image.
        - Example: If there is no opencv 
           ```sh 
           bash buid.sh opencv 
           ``` 
           After building everything that is missing 
           ```sh 
           "Build complete. Do you want to push this image to Docker Hub? (y/N) " 
           ``` 
           You will be told Choose to push to docker hub

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- Removing Containers -->
### Removing Containers

To stop and delete all created containers:
```bash
$ bash down.sh
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- IMAGE REMOVAL -->
### Deleting Images

To delete specific images:
```sh
$ docker rmi <image-name-or-id>
```

Verify removal with:
```sh
$ docker images
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MILESTONES -->
## Milestones

Check for current bugs or new feature requests at the [Issues page](https://github.com/TeamSOBITS/docker_ws/issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- REFERENCES -->
## References

For more details on Docker environment setup and usage, refer to:

- Official Site: [Docker Docs](https://docs.docker.com/)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LINKS -->
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
