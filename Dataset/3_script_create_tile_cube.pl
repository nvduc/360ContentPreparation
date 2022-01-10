#! /bin/perl -w
use strict;
# -------------------- Variable --------------------- #
my $vname = "RollerCoaster";
my @QP_ar = qw(48 44 40 36 32 28);
my @W_tile_arr  = qw(2);
my @H_tile_arr  = qw(2);
# my @W_tile_arr  = qw(4);
# my @H_tile_arr  = qw(3);
my $No_scheme = @W_tile_arr;
my $W_viewport = 960;
my $H_viewport = 960;
my $W_face = 960;
my $H_face = 960;
my $No_face =  6; ############## Change 6
my $No_face_tile_W; 
my $No_face_tile_H; 
my $No_face_tile; 

my $H_face_tile;
my $W_face_tile;

my $No_FR_D	= 0; # No frames to delete ############## Change 600 
my $No_FR_P	= 300; # No frames to process ############## Change 300 
my $No_FR	= $No_FR_D + $No_FR_P; # No frames to encode 
my $frame_rate			= 30;
my @longitude = qw(0 180 270 270 270 90);
my @altitude  = qw(0 0    90  270 0   0);
my @longitude_tile;
my @altitude_tile;

#=========== Duc's variable ===================
my $converter = "../bin/TApp360Convert";
my $encoder = "x265";
my $yuv_name = "Rollercoaster";
my $yuv = "Rollercoaster_3840x1920_65_75.yuv";
my $W_yuv = 3840;
my $H_yuv = 1920;
my $fps = 24;
my $outFolder_yuv;
my $outFolder_log;
my $face_folder;
my $cmd;
my $yuv_CMP;
my $src;
my $QP;
my $log;
my $CMP_W = 2880;
my $CMP_H = 1920;

################ convert from ERP to CMP################

$yuv_CMP = "${yuv_name}_CMP.yuv";
$cmd = "${converter} -i ${yuv} -wdt 3840 -hgt 1920 --InputBitDepth=8 --OutputBitDepth=8 -fr 24 -fs 0 -icf 420 --SourceFPStructure=\"1 1 0 0\" --InputGeometryType=0 --CodingGeometryType=1 --CodingFPStructure=\"2 3 4 0 0 0 5 0 3 180 1 270 2 0\" --CodingFaceWidth=960 --CodingFaceHeight=960  -f $No_FR -o $yuv_CMP";
system "$cmd";
$yuv_CMP = "${yuv_name}_CMP_${CMP_W}x${CMP_H}_24Hz_8b_420.yuv";

# exit;
# encode
# foreach $QP (@QP_ar){
# 	$out = "${vname}/no_tile/QP${QP}.h265";
# 	$log = "${vname}/no_tile/log_QP${QP}.txt";
# 	if(-e "$out"){
# 		print "$out existed\n";
# 	}else{
# 		$cmd = "x265 --input ${src} --input-depth 8 --frames ${No_FR}  --input-res ${CMP_W}x${CMP_H} --input-csp 1 --fps 24 --qp ${QP}  --ipratio 1 --pbratio 1 --keyint 24 --min-keyint 24 --scenecut 0  --bframes 2 --no-open-gop --preset slow --ssim --psnr --log-level 3 --csv-log-level 2 --csv ${log} -o ${out}";
# 		print "$cmd\n";
# 		system "$cmd"; 
# 		# exit;	
# 	}
# }
# exit;

# for(my $c = 0; $c < 0; $c++){
for(my $c = 0; $c < $No_scheme; $c++){
    $No_face_tile_W =  $W_tile_arr[$c]; 
    $No_face_tile_H =  $H_tile_arr[$c]; 
    $No_face_tile =  $No_face_tile_W*$No_face_tile_H ; 
    $H_face_tile = $H_face/$No_face_tile_H;
    $W_face_tile = $W_face/$No_face_tile_W;
    $face_folder = "${vname}/face/";
	$outFolder_yuv = "${vname}/6f_${No_face_tile_W}x${No_face_tile_H}/tile_yuv/";
	$outFolder_log = "${vname}/6f_${No_face_tile_W}x${No_face_tile_H}/tile_log/";
	if(-e "$face_folder"){
		# 
	}else{
		$cmd = "mkdir $face_folder";
		system "$cmd";
	}
	if(-e "${vname}/6f_${No_face_tile_W}x${No_face_tile_H}"){
		# 
	}else{
		$cmd = "mkdir ${vname}/6f_${No_face_tile_W}x${No_face_tile_H}";
		system "$cmd";
	}
	if(-e "$outFolder_log"){
		# 
	}else{
		$cmd = "mkdir $outFolder_log";
		system "$cmd";
	}
	if(-e "$outFolder_yuv"){
		# 
	}else{
		$cmd = "mkdir $outFolder_yuv";
		system "$cmd";
	}
	# exit;
# calculate location of each tile
    for (my $i = 0; $i < $No_face_tile; $i++) {
		$longitude_tile[$i] = int($i % $No_face_tile_W)  * $W_face_tile;
		$altitude_tile[$i] = int($i / $No_face_tile_W) * $H_face_tile;
	# print "$longitude[$i]\t$altitude[$i]\n";
    }
# generate tiles from erp
    my $create_tile = 1;
    if ($create_tile == 1) {
	for(my $cnt_face=0;$cnt_face < $No_face;$cnt_face++){ 
	    my $lt = ${longitude[$cnt_face]};
	    my $at = ${altitude[$cnt_face]};
	    my $face_name = "${face_folder}face_${cnt_face}.yuv";
	    # extract faces
	    my $cmd = "${converter} -w 1 -i ${yuv_CMP} -wdt ${CMP_W} -hgt ${CMP_H} --InputBitDepth=8 --OutputBitDepth=8 -fr $fps -fs 0 -icf 420 --SourceFPStructure=\"2 3 4 0 0 0 5 0 3 180 1 270 2 0\" --InputGeometryType=1 --CodingGeometryType=4 --CodingFPStructure=\"1 1 0  0\" --CodingFaceWidth=${W_face} --CodingFaceHeight=${H_face} --ViewPortSettings=\"90 90 ${lt} ${at}\" -f ${No_FR} -o ${face_name}";
	    if(-e "${face_folder}face_${cnt_face}_${W_face}x${H_face}_24Hz_8b_420.yuv"){
	    	print "$face_name existed \n";
	    }else{
	    	# exit;
	    	print $cmd;
	    	system $cmd;	
	    }
	    #
	    $face_name = "${face_folder}face_${cnt_face}_${W_face}x${H_face}_24Hz_8b_420.yuv";
	 #    # extract tiles from faces
	    for(my $cnt_t=0; $cnt_t < $No_face_tile;$cnt_t++){
			my $lt_t = ${longitude_tile[$cnt_t]};
			my $at_t = ${altitude_tile[$cnt_t]};
			my $cnt_t_name = $cnt_t;
			if(-e "${outFolder_yuv}f${cnt_face}_t${cnt_t_name}_${W_face_tile}x${H_face_tile}.yuv" || -e "${outFolder_yuv}f${cnt_face}_t${cnt_t_name}_${W_face_tile}x${H_face_tile}_QP24.h265"){
		    	print "Tile existed \n";
		    }else{
		    	# exit;
		    	$cmd = "ffmpeg -y -f rawvideo -s ${W_face}x${H_face} -r ${frame_rate} -i ${face_name} -filter:v \"crop=${W_face_tile}:${H_face_tile}:$lt_t:$at_t\" -frames ${No_FR} -c:v rawvideo -pix_fmt yuv420p ${outFolder_yuv}f${cnt_face}_t${cnt_t_name}_${W_face_tile}x${H_face_tile}.yuv";
		    	print "$cmd \n";
				system $cmd;
		    }
	    }
	}
   }

# Encode tile
 #    my $create_ver = 1;
 #    if ($create_ver == 1) {
	# for(my $cnt_face=0;$cnt_face < $No_face;$cnt_face++){
	#     #my $cnt_face = 2;
	#     print "face #${cnt_face}\n";
	#     for(my $cnt_t=0; $cnt_t < $No_face_tile;$cnt_t++){
	# 		my $tile_name = "${outFolder_yuv}f${cnt_face}_t${cnt_t}_${W_face_tile}x${H_face_tile}.yuv";
	# 		foreach my $QP (@QP_ar){
	# 		    my $log = "${outFolder_log}logPSNR_f${cnt_face}_t${cnt_t}_${W_face_tile}x${H_face_tile}_QP${QP}.txt";
	# 		    my $out = "${outFolder_yuv}f${cnt_face}_t${cnt_t}_${W_face_tile}x${H_face_tile}_QP${QP}.h265";
	# 		    my $cmd = "x265 --input ${tile_name} --input-depth 8 --frames ${No_FR}  --input-res ${W_face_tile}x${H_face_tile} --input-csp 1 --fps 24 --qp ${QP}  --ipratio 1 --pbratio 1 --keyint 24 --min-keyint 24 --scenecut 0  --bframes 2 --no-open-gop --preset slow --ssim --psnr --log-level 3 --csv-log-level 2 --csv ${log} -o ${out}";
	# 		    if(-e "$out"){
	# 		    	print "$out existed!\n";
	# 		    }else{
	# 		    	print "$cmd\n";
	# 		    	system $cmd;
	# 		    	#exit;
	# 		    }
	# 		}
	# 		# cleaning
	# 		$cmd = "rm $tile_name";
	# 		system "$cmd";
	#     }
	#     # exit;
	# }
	# # exit;
 #    }
}

