# 360 Content Preparation
## Overview
This code is used to prepare ``360-degree video`` for ``Viewport Adaptive Streaming`` in the following paper.

[1] D. V. Nguyen, H. Van Trung, H. L. Dieu Huong, T. T. Huong, N. P. Ngoc and T. C. Thang, "Scalable 360 Video Streaming using HTTP/2," 2019 IEEE 21st International Workshop on Multimedia Signal Processing (MMSP), 2019, pp. 1-6, doi: 10.1109/MMSP.2019.8901805.

Required OS: Ubuntu 18.04 (The code should also be working on newer Ubuntu versions.)
## How to use
1. Install prerequisites and setup default g++

```
sudo apt-get install ffmpeg perl g++-4.8 subversion
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 10
```
After this step, the default version of g++ should be 4.8. Check g++ version using the following command.
```
g++ --version
```

2. Download encoders source files
```
git clone https://github.com/nvduc/360ContentPreparation.git
cd 360ContentPreparation
```

360 Processing Library
```
mkdir Encoders
cd Encoders
mkdir 360Lib
cd 360Lib/
svn checkout https://hevc.hhi.fraunhofer.de/svn/svn_HEVCSoftware/tags/HM-16.16
svn checkout https://jvet.hhi.fraunhofer.de/svn/svn_360Lib/tags/360Lib-5.0
cp -R ./360Lib-5.0/source/Lib/TLib360 ./HM-16.16/source/Lib/
cp -R ./360Lib-5.0/source/Lib/TAppEncHelper360 ./HM-16.16/source/Lib/
cp -R ./360Lib-5.0/source/App/utils/TApp360Convert ./HM-16.16/source/App/utils/
cp -R ./360Lib-5.0/cfg-360Lib ./HM-16.16/
cp -R ./360Lib-5.0/HM-360Lib-5.0-build  ./HM-16.16/
cd ../
```
HEVC and SHVC encoders
```
svn checkout https://hevc.hhi.fraunhofer.de/svn/svn_HEVCSoftware/tags/HM-16.9/
svn checkout https://hevc.hhi.fraunhofer.de/svn/svn_SHVCSoftware/tags/SHM-9.0/
```

3. Build 360 Converter, HEVC Encoder, and SHVC Encoder

```
cd Encoders/360Lib/HM-16.16/HM-360Lib-5.0-build/linux/
make

cd ../../../../HM-16.9/build/linux
make

cd ../../../SHM-9.0/build/linux/
make

cd ../../../../
cp Encoders/360Lib/HM-16.16/bin/TApp360ConvertStatic bin/TApp360Convert
cp Encoders/HM-16.9/bin/TAppEncoderStatic bin/TAppEncoderHEVC
cp Encoders/SHM-9.0/bin/TAppEncoderStatic bin/TAppEncoderSHVC
sudo chmod +x bin/*
```
4. Generate video tiles (Cubemap@2840x1920@6x4)
```
cd Dataset
mkdir RollerCoaster
mkdir RollerCoaster/face
mkdir RollerCoaster/6f_2x2
mkdir RollerCoaster/6f_2x2/log
mkdir RollerCoaster/6f_2x2/tile_yuv
ffmpeg -i Rollercoaster_3840x1920_65_75.mkv Rollercoaster_3840x1920_65_75.yuv
perl 3_script_create_tile_cube.pl
```
The video tiles will be saved into ``Dataset/RollerCoaster/6f_2x2/tile_yuv/`` folder

5. Encode tiles into multiple versions using HEVC
```
cd Encode_Tile_HEVC/
bash encode_HEVC.sh
```
Each tile will be encoded into 5 versions with QP={38, 32, 28, 24, 20}. Each log file contains the encoding results of each version.

6. Encode tiles into multiple layers using Scalable Video Coding (SHVC)

Encode tiles into 2 layers: base layer: QP=38, enhancement layers: QP=32 (SNR-scalability).
```
cd Encode_Tile_SHVC
bash encode-SHVC-2layers.sh
```

Encode tiles into 5 layers: QP0=38, QP1=32, QP2=28, QP3=24, QP4=20 (SNR-scalability)
```
cd Encode_Tile_SHVC
bash encode-SHVC-5layers.sh
```
7. Generate video tiles (ERP@3840x1920@8x8)
```
cd Dataset
mkdir RollerCoaster (skip if already performed step 3)
ffmpeg -i Rollercoaster_3840x1920_65_75.mkv Rollercoaster_3840x1920_65_75.yuv (skip if already performed step 3)
perl 1_script_create_tile_erp.pl
```
Encode tiles into 6 versions using x264 encoders: QP={40, 36, 32, 28, 24, 20}
```
sudo apt-get install x264
cd Encode_Tile_x264
bash encode_x264.sh
```
