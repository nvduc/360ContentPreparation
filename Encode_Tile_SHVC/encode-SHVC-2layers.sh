#!/bin/bash


path="../Dataset/RollerCoaster/6f_2x2/tile_yuv/"
W="480"
H="480"
for (( i = 0; i < 6; i++ )); do
	for (( j = 0; j < 4; j++ )); do
		tile_name="f${i}_t${j}_480x480"
		../bin/TAppEncoderSHVC -c encoder_randomaccess_main.cfg -c layers.cfg -c RollerCoaster-SNR.cfg -i0 ${path}${tile_name}.yuv -i1 ${path}${tile_name}.yuv -b ${tile_name}_SHVC_2layers.bin  > log_encode_${tile_name}_SHVC_2layers.txt
	done
done
