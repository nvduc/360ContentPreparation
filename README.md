# 360 Content Preparation
## Overview
This code is used to prepare ``360-degree video`` for ``Viewport Adaptive Streaming``. 

Required OS: Ubuntu 18.04 (The code should also be working on newer Ubuntu version.)
## How to use
1. Install prerequisites and setup default g++

```
sudo apt-get install ffmpeg perl g++-4.8 svn
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 10
```
After this step, the default version of g++ should be 4.8. Check g++ version using the following command.
```
g++ --version
```

2. Download encoders source files

360 Processing Library
```
git clone https://github.com/nvduc/360ContentPreparation.git
cd 360ContentPreparation
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

4. Build 360 Converter, HEVC Encoder, and SHVC Encoder

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

```
3. Generate video tiles
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

4. Encode tiles into multiple versions using HEVC
```
cd Encode_Tile_HEVC/
bash encode_HEVC.sh
```
Each tile will be encoded into 5 versions with QP={38, 32, 28, 24, 20}. Each log file contains the encoding results of each version.

5. Encode tiles into multiple layers using Scalable Video Coding (SHVC)
```
cd Encode_Tile_SHVC
bash encode-SHVC-2layers.sh
```
Each tile will be encoded using Scalabe Video Coding into 2 layers: base layer: QP=38, enhancement layers: QP=32 (SNR-scalability).
