#!/bin/bash
# 参考①：https://docs.opencv.org/4.5.5/db/d05/tutorial_config_reference.html
# 参考②：https://alt-native.hatenadiary.org/entry/20121224/1356319986
# 参考③：https://docs.opencv.org/4.x/d7/d9f/tutorial_linux_install.html
# 参考④：https://docs.opencv.org/4.x/db/d05/tutorial_config_reference.html


# Define some variables
CV_VERSION=$1
CV_VERSION=${CV_VERSION//-}

UNIT=$2
UNIT=${UNIT//-}

CUDA_VERSION=$(nvcc --version | sed -n 's/^.*release \([0-9]\+\.[0-9]\+\).*$/\1/p')


UB_VER=$(cut -f2 <<< "`lsb_release -r`")
UB_VER=${UB_VER//.}


if [[ $UB_VER == "2404" ]]
then
    GCC_VER=13
elif [[ $UB_VER == "2204" ]]
then
    GCC_VER=11
elif [[ $UB_VER == "2004" ]]
then
    GCC_VER=9
elif [[ $(uname -m) = "aarch64" ]]
then
    GCC_VER=8
    
    sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 9
    sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 9
else
    GCC_VER=9
fi

re='^[0-9]+$'

PY3_VER=`python3 -c 'import sys; version=sys.version_info[:3]; print("{0}.{1}".format(*version))'`
PY3_VER_NO=`python3 -c 'import sys; version=sys.version_info[:3]; print("{0}{1}".format(*version))'`

ARCH=`uname -m`


# Check correct input flag
if ! [[ ${CV_VERSION//.} =~ $re ]]
then
    echo "Please write a correct version of OpenCV (only releases)"
    echo "Example: bash install_opencv.sh --4.6.0 --cpu"
    exit
fi

if [[ $UNIT == "GPU" || $UNIT == "gpu" || $UNIT == "CPU" || $UNIT == "cpu" ]]
then
    echo "╔══╣ Install: OpenCV-$CV_VERSION-$UNIT (STARTING) ╠══╗"
else
    echo "Please write '--CPU' or '--GPU' after the command"
    echo "Example: bash install_opencv.sh --4.6.0 --cpu"
    exit
fi


# Go to HOME directory
cd ~/

# Remove previous OpenCV
sudo rm -r /usr/local/{bin,lib}/*opencv*
sudo rm -r /opt/*opencv*
sudo rm /usr/local/lib/python${PY3_VER}/dist-packages/cv2.so

# Install minimal prerequisites
sudo apt-get install software-properties-common

if [[ $UB_VER == "2204" ]]; then
    sudo add-apt-repository -y ppa:ubuntuhandbook1/ppa
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 40976EAF437D05B5
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
else
    sudo add-apt-repository -y ppa:rock-core/qt4
fi
sudo add-apt-repository -y "deb http://security.ubuntu.com/ubuntu xenial-security main"

sudo apt update
sudo apt-get install -y \
    build-essential cmake g++ wget unzip pkg-config gfortran checkinstall ninja-build

# Video
sudo apt-get install -y \
    libgtk-3-dev libtheora-dev ffmpeg \
    libavcodec-dev libavdevice-dev libavfilter-dev libavformat-dev libavutil-dev libpostproc-dev libswresample-dev \
    libv4l-dev v4l-utils libxvidcore-dev libx264-dev libxine2-dev \
    libva-dev
    
# Image
sudo apt-get install -y \
    libswscale-dev libjpeg-dev libpng-dev libtiff-dev libexif-dev libwebp-dev \
    libopenexr-dev libqt4-dev \
    libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev \
    libopenjp2-7 libopenjp2-7-dev libopenjp2-tools \
    libopenjpip7 libopenjpip-server \
    
# Audio
sudo apt-get install -y \
    libvorbis-dev libfaac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev

# Math
sudo apt-get install -y \
    libatlas-base-dev

# Performance
sudo apt-get install -y \
    libtbb2 libtbb-dev libdc1394-22-dev libjasper-dev

# Other
sudo apt-get install -y \
    libopencv-dev yasm \
    libgtkglext1 libgtkglext1-dev libqt5opengl5-dev \
    python3-dev \
    python3-pip \
    python3-testresources


PY3_CMD="python3 -m pip install"
# --break-system-packages
if [[ $UB_VER == "2404" ]]
then
    PY3_CMD+=" --break-system-packages"
fi
$PY3_CMD -U \
    wheel \
    numpy \
    scipy \
    matplotlib \
    scikit-image \
    scikit-learn \
    ipython \
    dlib

# Download and unpack sources
wget -O opencv.zip https://github.com/opencv/opencv/archive/${CV_VERSION}.zip
unzip opencv.zip
rm opencv.zip

wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/${CV_VERSION}.zip
unzip opencv_contrib.zip
rm opencv_contrib.zip


# Configure and build
cd opencv-${CV_VERSION}
mkdir build
cd build

# Create Cmake configuration
if [[ $UNIT == "GPU" || $UNIT == "gpu" ]]; then
    cmake -GNinja \
        -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=/opt/opencv/opencv_${CV_VERSION} \
        -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib-${CV_VERSION}/modules \
        -D OPENCV_PYTHON3_INSTALL_PATH=/opt/opencv/opencv_${CV_VERSION}/lib/python${PY3_VER}/dist-packages \
        -D PYTHON_DEFAULT_EXECUTABLE=$(which python3) \
        -D PYTHON3_EXECUTABLE=$(which python3) \
        -D CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-${CUDA_VERSION} -D CUDA_HOST_COMPILER=/usr/bin/gcc-${GCC_VER} \
        -D CUDNN_LIBRARY="/usr/lib/${ARCH}-linux-gnu/libcudnn.so" \
        -D CUDNN_INCLUDE_DIR="/usr/include/" \
        -D OPENCV_GENERATE_PKGCONFIG=ON \
        -D WITH_CUBLAS=ON -D WITH_CUDA=ON -D WITH_CUFFT=ON -D WITH_CUDNN=ON \
        -D WITH_GPHOTO2=ON -D WITH_GIGEAPI=ON -D WITH_INTELPERC=OFF -D WITH_IPP_A=OFF -D WITH_LIBV4L=ON \
        -D WITH_LIBREALSENSE=ON -D WITH_OPENCLAMDBLAS=OFF -D WITH_OPENCLAMDFFT=OFF -D WITH_OPENGL=ON -D WITH_PTHREADS_PF=OFF \
        -D WITH_PVAPI=ON -D WITH_QT=ON -D WITH_TBB=ON -D WITH_UNICAP=OFF -D WITH_VTK=OFF -D WITH_WEBP=ON \
        -D WITH_OPENJPEG=ON -D WITH_JPEG=ON \
        -D CUDA_NVCC_FLAGS=--expt-relaxed-constexpr \
        -D CUDA_FAST_MATH=ON \
        -D ENABLE_FAST_MATH=ON \
	-D OPENCV_DNN_CUDA=ON \
        -D INSTALL_C_EXAMPLES=ON -D INSTALL_PYTHON_EXAMPLES=ON \
        -D BUILD_EXAMPLES=ON \
        -D BUILD_opencv_cudaarithm=ON -D BUILD_opencv_cudabgsegm=ON -D BUILD_opencv_cudacodec=ON \
        -D BUILD_opencv_cudafeatures2d=ON -D BUILD_opencv_cudafilters=ON -D BUILD_opencv_cudaimgproc=ON -D BUILD_opencv_cudalegacy=ON \
        -D BUILD_opencv_cudaobjdetect=ON -D BUILD_opencv_cudaoptflow=ON -D BUILD_opencv_cudastereo=ON -D BUILD_opencv_cudawarping=ON \
        -D BUILD_opencv_cudev=ON -D BUILD_opencv_superres=ON -D BUILD_opencv_videostab=ON \
        ..

elif [[ $UNIT == "CPU" || $UNIT == "cpu" ]]; then
    cmake -GNinja \
        -D CMAKE_BUILD_TYPE=Release \
        -D CMAKE_INSTALL_PREFIX=/opt/opencv/opencv_${CV_VERSION} \
        -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib-${CV_VERSION}/modules \
        -D OPENCV_PYTHON3_INSTALL_PATH=/opt/opencv/opencv_${CV_VERSION}/lib/python${PY3_VER}/dist-packages \
        -D PYTHON_DEFAULT_EXECUTABLE=$(which python3) \
        -D PYTHON3_EXECUTABLE=$(which python3) \
        -D OPENCV_GENERATE_PKGCONFIG=ON \
        -D WITH_TBB=ON \
        -D WITH_QT=ON \
        -D WITH_OPENGL=ON \
        -D WITH_LIBREALSENSE=ON \
        -D INSTALL_C_EXAMPLES=ON -D INSTALL_PYTHON_EXAMPLES=ON \
        -D BUILD_EXAMPLES=ON \
        ..
else
    exit
fi

# Build
ninja

# Install
sudo ninja install
sudo ldconfig


# Create reference for Python
if [[ ${PY3_VER_NO} == "38" || ${PY3_VER_NO} == "39" || ${PY3_VER_NO} == "310" || ${PY3_VER_NO} == "311" || ${PY3_VER_NO} == "312" ]]; then
    sudo mv /opt/opencv/opencv_${CV_VERSION}/lib/python${PY3_VER}/dist-packages/cv2/python-${PY3_VER}/cv2.cpython-${PY3_VER_NO}-${ARCH}-linux-gnu.so /opt/opencv/opencv_${CV_VERSION}/lib/python${PY3_VER}/dist-packages/cv2.so
else
    sudo mv /opt/opencv/opencv_${CV_VERSION}/lib/python${PY3_VER}/dist-packages/cv2/python-${PY3_VER}/cv2.cpython-${PY3_VER_NO}m-${ARCH}-linux-gnu.so /opt/opencv/opencv_${CV_VERSION}/lib/python${PY3_VER}/dist-packages/cv2.so
fi
sudo ln -s /opt/opencv/opencv_${CV_VERSION}/lib/python${PY3_VER}/dist-packages/cv2.so /usr/local/lib/python${PY3_VER}/dist-packages/cv2.so


# Delete OpenCV building folders
sudo rm -r ~/opencv-${CV_VERSION}
sudo rm -r ~/opencv_contrib-${CV_VERSION}

echo "╚══╣ Install: OpenCV-$CV_VERSION-$UNIT (FINISHED) ╠══╝"



# ////////////////////////////
# ////  Option (Default)  ////
# ////////////////////////////

# // Path to a program.
# ANT_EXECUTABLE:FILEPATH=ANT_EXECUTABLE-NOTFOUND

# // Path to a library.
# Atlas_BLAS_LIBRARY:FILEPATH=Atlas_BLAS_LIBRARY-NOTFOUND

# // Path to a file.
# Atlas_CBLAS_INCLUDE_DIR:PATH=Atlas_CBLAS_INCLUDE_DIR-NOTFOUND

# // Path to a library.
# Atlas_CBLAS_LIBRARY:FILEPATH=Atlas_CBLAS_LIBRARY-NOTFOUND

# // Path to a file.
# Atlas_CLAPACK_INCLUDE_DIR:PATH=Atlas_CLAPACK_INCLUDE_DIR-NOTFOUND

# // Path to a library.
# Atlas_LAPACK_LIBRARY:FILEPATH=Atlas_LAPACK_LIBRARY-NOTFOUND

# // Build CUDA modules stubs when no CUDA SDK
# BUILD_CUDA_STUBS:BOOL=OFF

# // Create build rules for OpenCV Documentation
# BUILD_DOCS:BOOL=OFF

# // Build all examples
# BUILD_EXAMPLES:BOOL=OFF

# // Build IPP IW from source
# BUILD_IPP_IW:BOOL=ON

# // Build Intel ITT from source
# BUILD_ITT:BOOL=ON

# // Build libjasper from source
# BUILD_JASPER:BOOL=OFF

# // Enable Java support
# BUILD_JAVA:BOOL=ON

# // Build libjpeg from source
# BUILD_JPEG:BOOL=OFF

# // Build only listed modules (comma-separated, e.g. 'videoio,dnn,ts')
# BUILD_LIST:STRING=

# // Build openexr from source
# BUILD_OPENEXR:BOOL=OFF

# // Build OpenJPEG from source
# BUILD_OPENJPEG:BOOL=OFF

# // Enables 'make package_source' command
# BUILD_PACKAGE:BOOL=ON

# // Build performance tests
# BUILD_PERF_TESTS:BOOL=ON

# // Build libpng from source
# BUILD_PNG:BOOL=OFF

# // Force to build libprotobuf runtime from sources
# BUILD_PROTOBUF:BOOL=ON

# // Build shared libraries (.dll/.so) instead of static ones (.lib/.a)
# BUILD_SHARED_LIBS:BOOL=ON

# // Download and build TBB from source
# BUILD_TBB:BOOL=OFF

# // Build accuracy & regression tests
# BUILD_TESTS:BOOL=ON

# // Build libtiff from source
# BUILD_TIFF:BOOL=OFF

# // Use symlinks instead of files copying during build (and !!INSTALL!!)
# BUILD_USE_SYMLINKS:BOOL=OFF

# // Build WebP from source
# BUILD_WEBP:BOOL=OFF

# // Include debug info into release binaries ('OFF' means default settings)
# BUILD_WITH_DEBUG_INFO:BOOL=OFF

# // Enables dynamic linking of IPP (only for standalone IPP)
# BUILD_WITH_DYNAMIC_IPP:BOOL=OFF

# // Build zlib from source
# BUILD_ZLIB:BOOL=OFF

# // Build utility applications (used for example to train classifiers)
# BUILD_opencv_apps:BOOL=ON

# // Include opencv_calib3d module into the OpenCV build
# BUILD_opencv_calib3d:BOOL=ON

# // Include opencv_core module into the OpenCV build
# BUILD_opencv_core:BOOL=ON

# // Include opencv_dnn module into the OpenCV build
# BUILD_opencv_dnn:BOOL=ON

# // Include opencv_features2d module into the OpenCV build
# BUILD_opencv_features2d:BOOL=ON

# // Include opencv_flann module into the OpenCV build
# BUILD_opencv_flann:BOOL=ON

# // Include opencv_gapi module into the OpenCV build
# BUILD_opencv_gapi:BOOL=ON

# // Include opencv_highgui module into the OpenCV build
# BUILD_opencv_highgui:BOOL=ON

# // Include opencv_imgcodecs module into the OpenCV build
# BUILD_opencv_imgcodecs:BOOL=ON

# // Include opencv_imgproc module into the OpenCV build
# BUILD_opencv_imgproc:BOOL=ON

# // Include opencv_java_bindings_generator module into the OpenCV build
# BUILD_opencv_java_bindings_generator:BOOL=ON

# // Build JavaScript bindings by Emscripten
# BUILD_opencv_js:BOOL=OFF

# // Include opencv_js_bindings_generator module into the OpenCV build
# BUILD_opencv_js_bindings_generator:BOOL=ON

# // Include opencv_ml module into the OpenCV build
# BUILD_opencv_ml:BOOL=ON

# // Include opencv_objc_bindings_generator module into the OpenCV build
# BUILD_opencv_objc_bindings_generator:BOOL=ON

# // Include opencv_objdetect module into the OpenCV build
# BUILD_opencv_objdetect:BOOL=ON

# // Include opencv_photo module into the OpenCV build
# BUILD_opencv_photo:BOOL=ON

# // Include opencv_python3 module into the OpenCV build
# BUILD_opencv_python3:BOOL=ON

# // Include opencv_python_bindings_generator module into the OpenCV build
# BUILD_opencv_python_bindings_generator:BOOL=ON

# // Include opencv_python_tests module into the OpenCV build
# BUILD_opencv_python_tests:BOOL=ON

# // Include opencv_stitching module into the OpenCV build
# BUILD_opencv_stitching:BOOL=ON

# // Include opencv_ts module into the OpenCV build
# BUILD_opencv_ts:BOOL=ON

# // Include opencv_video module into the OpenCV build
# BUILD_opencv_video:BOOL=ON

# // Include opencv_videoio module into the OpenCV build
# BUILD_opencv_videoio:BOOL=ON

# // Include opencv_world module into the OpenCV build
# BUILD_opencv_world:BOOL=OFF

# // Path to a program.
# CCACHE_PROGRAM:FILEPATH=CCACHE_PROGRAM-NOTFOUND

# // clAmdFft include directory
# CLAMDBLAS_INCLUDE_DIR:PATH=CLAMDBLAS_INCLUDE_DIR-NOTFOUND

# // AMD FFT root directory
# CLAMDBLAS_ROOT_DIR:PATH=CLAMDBLAS_ROOT_DIR-NOTFOUND

# // clAmdFft include directory
# CLAMDFFT_INCLUDE_DIR:PATH=CLAMDFFT_INCLUDE_DIR-NOTFOUND

# // AMD FFT root directory
# CLAMDFFT_ROOT_DIR:PATH=CLAMDFFT_ROOT_DIR-NOTFOUND

# // Choose the type of build
# CMAKE_BUILD_TYPE:STRING=Release

# // Configs
# CMAKE_CONFIGURATION_TYPES:STRING=Debug;Release

# // Installation Directory
# CMAKE_INSTALL_PREFIX:PATH=/usr/local

# // Specify list of enabled baseline CPU optimizations
# CPU_BASELINE:STRING=SSE3

# // Specify list of dispatched CPU optimizations
# CPU_DISPATCH:STRING=SSE4_1;SSE4_2;AVX;FP16;AVX2;AVX512_SKX

# // Disable explicit optimized code (dispatched code/intrinsics/loop unrolling/etc)
# CV_DISABLE_OPTIMIZATION:BOOL=OFF

# // Use intrinsic-based optimized code
# CV_ENABLE_INTRINSICS:BOOL=ON

# // Enable OpenCV code trace
# CV_TRACE:BOOL=ON

# // Path to a file.
# DC1394_INCLUDE:PATH=DC1394_INCLUDE-NOTFOUND

# // Path to a library.
# DC1394_LIBRARY:FILEPATH=DC1394_LIBRARY-NOTFOUND

# // The path to Eigen3/Eigen2 headers
# EIGEN_INCLUDE_PATH:PATH=EIGEN_INCLUDE_PATH-NOTFOUND

# // Enable hardening of the resulting binaries (against security attacks, detects memory corruption, etc)
# ENABLE_BUILD_HARDENING:BOOL=OFF

# // Use ccache
# ENABLE_CCACHE:BOOL=ON

# // Fail build if actual configuration doesn't match requested (WITH_XXX != HAVE_XXX)
# ENABLE_CONFIG_VERIFICATION:BOOL=OFF

# // Enable coverage collection with  GCov
# ENABLE_COVERAGE:BOOL=OFF

# // Enable compiler options for fast math optimizations on FP computations (not recommended)
# ENABLE_FAST_MATH:BOOL=OFF

# // Add target with Python flake8 checker
# ENABLE_FLAKE8:BOOL=OFF

# // Enable GNU STL Debug mode (defines _GLIBCXX_DEBUG)
# ENABLE_GNU_STL_DEBUG:BOOL=OFF

# // Collect implementation data on function call
# ENABLE_IMPL_COLLECTION:BOOL=OFF

# // Instrument functions to collect calls trace and performance
# ENABLE_INSTRUMENTATION:BOOL=OFF

# // Enable Link Time Optimization
# ENABLE_LTO:BOOL=OFF

# // Show all warnings even if they are too noisy
# ENABLE_NOISY_WARNINGS:BOOL=OFF

# // Enable -fomit-frame-pointer for GCC
# ENABLE_OMIT_FRAME_POINTER:BOOL=ON

# // Generate position independent code (necessary for shared libraries)
# ENABLE_PIC:BOOL=ON

# // Use precompiled headers
# ENABLE_PRECOMPILED_HEADERS:BOOL=OFF

# // Enable profiling in the GCC compiler (Add flags: -g -pg)
# ENABLE_PROFILING:BOOL=OFF

# // Add target with Pylint checks
# ENABLE_PYLINT:BOOL=OFF

# // Solution folder in Visual Studio or in other IDEs
# ENABLE_SOLUTION_FOLDERS:BOOL=OFF

# // Output directory for applications
# EXECUTABLE_OUTPUT_PATH:PATH=/opencv-4.5.5/build/bin

# // The directory containing a CMake configuration file for Eigen3.
# Eigen3_DIR:PATH=Eigen3_DIR-NOTFOUND

# // Generate XML file for abi_compliance_checker tool
# GENERATE_ABI_DESCRIPTOR:BOOL=OFF

# // Change install rules to build the distribution package
# INSTALL_CREATE_DISTRIB:BOOL=OFF

# // Install C examples
# INSTALL_C_EXAMPLES:BOOL=OFF

# // Install Python examples
# INSTALL_PYTHON_EXAMPLES:BOOL=OFF

# // Install accuracy and performance test binaries and test data
# INSTALL_TESTS:BOOL=OFF

# // Enables mangled install paths, that help with side by side installs.
# INSTALL_TO_MANGLED_PATHS:BOOL=OFF

# // Alternative name of cblas.h
# LAPACK_CBLAS_H:STRING=

# // Lapack implementation id
# LAPACK_IMPL:STRING=Unknown

# // Path to BLAS include dir
# LAPACK_INCLUDE_DIR:PATH=

# // Alternative name of lapacke.h
# LAPACK_LAPACKE_H:STRING=

# // Names of BLAS & LAPACK binaries (.so, .dll, .a, .lib)
# LAPACK_LIBRARIES:STRING=

# // Path to a file.
# MKL_ROOT_DIR:PATH=MKL_ROOT_DIR-NOTFOUND

# // Use MKL Single Dynamic Library thorugh mkl_rt.lib / libmkl_rt.so
# MKL_USE_SINGLE_DYNAMIC_LIBRARY:BOOL=OFF

# // Use MKL with OpenMP multithreading
# MKL_WITH_OPENMP:BOOL=OFF

# // Use MKL with TBB multithreading
# MKL_WITH_TBB:BOOL=OFF

# // Path to a library.
# M_LIBRARY:FILEPATH=/usr/lib/x86_64-linux-gnu/libm.so

# // OpenCL library is found
# OPENCL_FOUND:BOOL=ON

# // Where to create the platform-dependant cvconfig.h
# OPENCV_CONFIG_FILE_INCLUDE_DIR:PATH=/opencv-4.5.5/build

# // Disable filesystem support
# OPENCV_DISABLE_FILESYSTEM_SUPPORT:BOOL=OFF

# // Build with CUDA support
# OPENCV_DNN_CUDA:BOOL=OFF

# // Build with OpenCL support
# OPENCV_DNN_OPENCL:BOOL=ON

# // Add performance tests of Caffe framework
# OPENCV_DNN_PERF_CAFFE:BOOL=OFF

# // Add performance tests of clCaffe framework
# OPENCV_DNN_PERF_CLCAFFE:BOOL=OFF

# // Cache directory for downloaded files
# OPENCV_DOWNLOAD_PATH:PATH=/opencv-4.5.5/.cache

# // Dump called OpenCV hooks
# OPENCV_DUMP_HOOKS_FLOW:BOOL=OFF

# // Enable Allocator metrics
# OPENCV_ENABLE_ALLOCATOR_STATS:BOOL=ON

# // Enable C++ compiler support for atomic<long long>
# OPENCV_ENABLE_ATOMIC_LONG_LONG:BOOL=ON

# // Enable posix_memalign or memalign usage
# OPENCV_ENABLE_MEMALIGN:BOOL=ON

# // Better support for memory/address sanitizers
# OPENCV_ENABLE_MEMORY_SANITIZER:BOOL=OFF

# // Enable non-free algorithms
# OPENCV_ENABLE_NONFREE:BOOL=OFF

# // Where to look for additional OpenCV modules (can be ;-separated list of paths)
# OPENCV_EXTRA_MODULES_PATH:PATH=

# // Force using 3rdparty code from source
# OPENCV_FORCE_3RDPARTY_BUILD:BOOL=OFF

# // 
# OPENCV_FORCE_PYTHON_LIBS:BOOL=OFF

# // Build G-API with GStreamer support
# OPENCV_GAPI_GSTREAMER:BOOL=OFF

# // Generate .pc file for pkg-config build tool (deprecated)
# OPENCV_GENERATE_PKGCONFIG:BOOL=OFF

# // Generate setup_vars* scripts
# OPENCV_GENERATE_SETUPVARS:BOOL=ON

# // Enable IPP optimizations for GaussianBlur (+8Mb in binary size)
# OPENCV_IPP_GAUSSIAN_BLUR:BOOL=OFF

# // Java source version (javac Ant target)
# OPENCV_JAVA_SOURCE_VERSION:STRING=

# // Java target version (javac Ant target)
# OPENCV_JAVA_TARGET_VERSION:STRING=

# // URI to a MathJax installation
# OPENCV_MATHJAX_RELPATH:STRING=https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0

# // Python3 version
# OPENCV_PYTHON3_VERSION:BOOL=OFF

# // Timestamp of OpenCV build configuration
# OPENCV_TIMESTAMP:STRING=2022-05-17T03:06:00Z

# // Treat warnings as errors
# OPENCV_WARNINGS_ARE_ERRORS:BOOL=OFF

# // Path to a file.
# OPENEXR_INCLUDE_PATH:PATH=OPENEXR_INCLUDE_PATH-NOTFOUND

# // Disable TPsot==TNsot fix. See https://github.com/uclouvain/openjpeg/issues/254.
# OPJ_DISABLE_TPSOT_FIX:BOOL=OFF

# // Build with thread/mutex support 
# OPJ_USE_THREAD:BOOL=ON

# // The directory containing a CMake configuration file for OpenCV_HAL.
# OpenCV_HAL_DIR:PATH=OpenCV_HAL_DIR-NOTFOUND

# // The directory containing a CMake configuration file for OpenEXR.
# OpenEXR_DIR:PATH=OpenEXR_DIR-NOTFOUND

# // The directory containing a CMake configuration file for OpenJPEG.
# OpenJPEG_DIR:PATH=OpenJPEG_DIR-NOTFOUND

# // Allow building parallel plugin support
# PARALLEL_ENABLE_PLUGINS:BOOL=ON

# // Force rebuilding .proto files (protoc should be available)
# PROTOBUF_UPDATE_FILES:BOOL=OFF

# // Path to Python interpreter
# PYTHON2_EXECUTABLE:FILEPATH=

# // Python include dir
# PYTHON2_INCLUDE_DIR:PATH=

# // Python include dir 2
# PYTHON2_INCLUDE_DIR2:PATH=

# // Path to Python library
# PYTHON2_LIBRARY:FILEPATH=

# // Path to Python debug
# PYTHON2_LIBRARY_DEBUG:FILEPATH=

# // Path to numpy headers
# PYTHON2_NUMPY_INCLUDE_DIRS:PATH=

# // Where to install the python packages.
# PYTHON2_PACKAGES_PATH:PATH=

# // Path to Python interpreter
# PYTHON3_EXECUTABLE:FILEPATH=/usr/bin/python3

# // Python include dir
# PYTHON3_INCLUDE_DIR:PATH=/usr/include/python3.8

# // Python include dir 2
# PYTHON3_INCLUDE_DIR2:PATH=

# // Path to Python library
# PYTHON3_LIBRARY:FILEPATH=/usr/lib/x86_64-linux-gnu/libpython3.8.so

# // Path to Python debug
# PYTHON3_LIBRARY_DEBUG:FILEPATH=

# // Path to numpy headers
# PYTHON3_NUMPY_INCLUDE_DIRS:PATH=/usr/local/lib/python3.8/dist-packages/numpy/core/include

# // Where to install the python packages.
# PYTHON3_PACKAGES_PATH:PATH=lib/python3.8/site-packages

# // Use win32 IO system (Microsoft Windows only)
# USE_WIN32_FILEIO:BOOL=FALSE

# // Path to libva headers
# VA_INCLUDE_DIR:PATH=VA_INCLUDE_DIR-NOTFOUND

# // The directory containing a CMake configuration file for VTK.
# VTK_DIR:PATH=VTK_DIR-NOTFOUND

# // Include IEEE1394 support
# WITH_1394:BOOL=ON

# // Enable ADE framework (required for Graph API module)
# WITH_ADE:BOOL=ON

# // Include Aravis GigE support
# WITH_ARAVIS:BOOL=OFF

# // Include arithmetic decoding support when emulating the libjpeg v6b API/ABI
# WITH_ARITH_DEC:BOOL=ON

# // Include arithmetic encoding support when emulating the libjpeg v6b API/ABI
# WITH_ARITH_ENC:BOOL=ON

# // Include Clp support (EPL)
# WITH_CLP:BOOL=OFF

# // Include NVidia Cuda Runtime support
# WITH_CUDA:BOOL=OFF

# // Include Eigen2/Eigen3 support
# WITH_EIGEN:BOOL=ON

# // Include FFMPEG support
# WITH_FFMPEG:BOOL=ON

# // Enable FreeType framework
# WITH_FREETYPE:BOOL=OFF

# // Include GDAL Support
# WITH_GDAL:BOOL=OFF

# // Include DICOM support
# WITH_GDCM:BOOL=OFF

# // Include gPhoto2 library support
# WITH_GPHOTO2:BOOL=OFF

# // Include Gstreamer support
# WITH_GSTREAMER:BOOL=ON

# // Include GTK support
# WITH_GTK:BOOL=ON

# // Use GTK version 2
# WITH_GTK_2_X:BOOL=OFF

# // Include Halide support
# WITH_HALIDE:BOOL=OFF

# // Include Ste||ar Group HPX support
# WITH_HPX:BOOL=OFF

# // Include HDR support
# WITH_IMGCODEC_HDR:BOOL=ON

# // Include PFM formats support
# WITH_IMGCODEC_PFM:BOOL=ON

# // Include PNM (PBM,PGM,PPM) and PAM formats support
# WITH_IMGCODEC_PXM:BOOL=ON

# // Include SUNRASTER support
# WITH_IMGCODEC_SUNRASTER:BOOL=ON

# // Include Intel Inference Engine support
# WITH_INF_ENGINE:BOOL=OFF

# // Include Intel IPP support
# WITH_IPP:BOOL=ON

# // Include Intel ITT support
# WITH_ITT:BOOL=ON

# // Include JPEG2K support (Jasper)
# WITH_JASPER:BOOL=ON

# // Include JPEG support
# WITH_JPEG:BOOL=ON

# // Include Lapack library support
# WITH_LAPACK:BOOL=ON

# // Include Intel librealsense support
# WITH_LIBREALSENSE:BOOL=OFF

# // Include Intel Media SDK support
# WITH_MFX:BOOL=OFF

# // Include nGraph support
# WITH_NGRAPH:BOOL=OFF

# // Include Microsoft ONNX Runtime support
# WITH_ONNX:BOOL=OFF

# // Include OpenCL Runtime support
# WITH_OPENCL:BOOL=ON

# // Include AMD OpenCL BLAS library support
# WITH_OPENCLAMDBLAS:BOOL=ON

# // Include AMD OpenCL FFT library support
# WITH_OPENCLAMDFFT:BOOL=ON

# // Include OpenCL Shared Virtual Memory support
# WITH_OPENCL_SVM:BOOL=OFF

# // Include ILM support via OpenEXR
# WITH_OPENEXR:BOOL=ON

# // Include OpenGL support
# WITH_OPENGL:BOOL=OFF

# // Include JPEG2K support (OpenJPEG)
# WITH_OPENJPEG:BOOL=ON

# // Include OpenMP support
# WITH_OPENMP:BOOL=OFF

# // Include OpenNI support
# WITH_OPENNI:BOOL=OFF

# // Include OpenNI2 support
# WITH_OPENNI2:BOOL=OFF

# // Include OpenVX support
# WITH_OPENVX:BOOL=OFF

# // Include PlaidML2 support
# WITH_PLAIDML:BOOL=OFF

# // Include PNG support
# WITH_PNG:BOOL=ON

# // Enable libprotobuf
# WITH_PROTOBUF:BOOL=ON

# // Use pthreads-based parallel_for
# WITH_PTHREADS_PF:BOOL=ON

# // Include Prosilica GigE support
# WITH_PVAPI:BOOL=OFF

# // Build with Qt Backend support
# WITH_QT:BOOL=OFF

# // Include library QR-code decoding
# WITH_QUIRC:BOOL=ON

# // Include Intel TBB support
# WITH_TBB:BOOL=OFF

# // Include TIFF support
# WITH_TIFF:BOOL=ON

# // Include UEYE camera support
# WITH_UEYE:BOOL=OFF

# // Include Video 4 Linux support
# WITH_V4L:BOOL=ON

# // Include VA support
# WITH_VA:BOOL=ON

# // Include Intel VA-API/OpenCL support
# WITH_VA_INTEL:BOOL=ON

# // Include VTK library support (and build opencv_viz module eiher)
# WITH_VTK:BOOL=ON

# // Include Vulkan support
# WITH_VULKAN:BOOL=OFF

# // Include WebNN support
# WITH_WEBNN:BOOL=OFF

# // Include WebP support
# WITH_WEBP:BOOL=ON

# // Include XIMEA cameras support
# WITH_XIMEA:BOOL=OFF

# // Include Xine support (GPL)
# WITH_XINE:BOOL=OFF

# // support for CCITT Group 3 & 4 algorithms
# ccitt:BOOL=ON

# // support for LogLuv high dynamic range algorithm
# logluv:BOOL=ON

# // support for LZW algorithm
# lzw:BOOL=ON

# // support for Microsoft Document Imaging
# mdi:BOOL=ON

# // support for NeXT 2-bit RLE algorithm
# next:BOOL=ON

# // support for Old JPEG compression (read-only)
# old-jpeg:BOOL=OFF

# // support for Macintosh PackBits algorithm
# packbits:BOOL=ON

# // support for ThunderScan 4-bit RLE algorithm
# thunder:BOOL=ON
