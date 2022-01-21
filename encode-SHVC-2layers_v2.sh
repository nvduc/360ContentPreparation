#!/bin/bash


path="../Dataset/RollerCoaster/6f_2x2/tile_yuv/"
W="480"
H="480"
QP0="32"
QP1="28"
for (( i = 0; i < 6; i++ )); do
	for (( j = 0; j < 4; j++ )); do
		tile_name="f${i}_t${j}_480x480"
		../bin/TAppEncoderSHVC -c encoder_randomaccess_main.cfg -c layers.cfg -c RollerCoaster-SNR.cfg -q0 ${QP0}  -i0 ${path}${tile_name}.yuv -q1 ${QP1} -i1 ${path}${tile_name}.yuv -b ${tile_name}_SHVC_2layers_${QP0}_${QP1}.bin  > log_encode_${tile_name}_SHVC_2layers_${QP0}_${QP1}.txt
	done
done
