#!/bin/bash
vname="RollerCoaster"
# path="../Dataset/${vname}/6f_2x2/tile_yuv/"
path="../../SVC-Encoder-20220109T061506Z-001/SVC-Encoder/Dataset/RollerCoaster/6f_2x2/tile_yuv"
No_FR=300
W_face_tile=480
H_face_tile=480

for (( i = 0; i < 6; i++ )); do
	for (( j = 0; j < 4; j++ )); do
		tile_name="f${i}_t${j}_480x480"
		for QP in 40 36 32 28 24 20
		do
			#echo x264 --input-depth 8 --frames ${No_FR}  --input-res ${W_face_tile}x${H_face_tile} --input-csp 1 --fps 30 --qp ${QP}  --ipratio 1 --pbratio 1 --keyint 32 --min-keyint 32 --scenecut 0  --bframes 2 --no-open-gop --ssim --psnr --log-level 3 --csv-log-level 2 --csv log_encode_${vname}_${tile_name}_x264_QP_${QP}.txt -o ${vname}_${tile_name}_x264_QP_${QP}.h264 ${path}/${tile_name}.yuv 
			echo ffmpeg -y -f rawvideo -pix_fmt yuv420p -s:v 480x480 -r 30 -i ${path}/${tile_name}.yuv -c:v libx264 -crf ${QP} -tune psnr -f rawvideo ${vname}_${tile_name}_x264_QP_${QP}.h264 -psnr 2> log_encode_${vname}_${tile_name}_x264_QP_${QP}.txt
			ffmpeg -y -f rawvideo -pix_fmt yuv420p -s:v 480x480 -r 30 -i ${path}/${tile_name}.yuv -c:v libx264 -crf ${QP} -tune psnr -f rawvideo ${vname}_${tile_name}_x264_QP_${QP}.h264 -psnr 2> log_encode_${vname}_${tile_name}_x264_QP_${QP}.txt

		done
	done
done