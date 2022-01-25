#!/bin/bash
vname="RollerCoaster"
path="../Dataset/${vname}/6f_2x2/tile_yuv/"

for (( i = 0; i < 6; i++ )); do
	for (( j = 0; j < 4; j++ )); do
		tile_name="f${i}_t${j}_480x480"
		for QP in 38 32 28 24 20
		do
			../bin/TAppEncoderHEVC -c encoder_randomaccess_main.cfg -c RollerCoaster.cfg -i ${path}${tile_name}.yuv -q ${QP}  -b ${vname}_${tile_name}_HEVC_QP_${QP}.bin  > log_encode_${vname}_${tile_name}_HEVC_QP_${QP}.txt
		done
	done
done