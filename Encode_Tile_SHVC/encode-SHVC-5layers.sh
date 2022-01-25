#!/bin/bash

vname="RollerCoaster"
path="../Dataset/${vname}/6f_2x2/tile_yuv/"
W="480"
H="480"
QP0="38"
QP1="32"
QP2="28"
QP3="24"
QP4="20"
for (( i = 0; i < 6; i++ )); do
	for (( j = 0; j < 4; j++ )); do
		tile_name="f${i}_t${j}_480x480"
		../bin/TAppEncoderSHVC -c encoder_randomaccess_main.cfg -c 5layers.cfg -c RollerCoaster-SNR-5layers.cfg -q0 ${QP0}  -i0 ${path}${tile_name}.yuv -q1 ${QP1} -i1 ${path}${tile_name}.yuv -q2 ${QP2} -i2 ${path}${tile_name}.yuv -q3 ${QP3} -i3 ${path}${tile_name}.yuv -q4 ${QP4} -i4 ${path}${tile_name}.yuv -b ${vname}_${tile_name}_SHVC_5layers.bin  > log_encode_${vname}_${tile_name}_SHVC_5layers.txt
	done
done
