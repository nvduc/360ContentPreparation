# 360 Content Preparation
## Overview
This code is used to prepare ``360-degree video`` for ``Viewport Adaptive Streaming``. 
## How to use
1. Install prerequisites and setup default g++

```
sudo apt-get install ffmpeg perl g++4.8
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 10
```
2. Build 360 Converter, HEVC Encoder, and SHVC Encoder

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
