#! /bin/perl -w
use strict;
use warnings;

# -------------------- Variable --------------------- # 
my $video_name = "RollerCoaster";
my $source = "Rollercoaster_3840x1920_65_75.yuv";
print "${video_name} $source\n";
# exit;
my $ERP_W = 3840;
my $ERP_H = 1920;
my @QP_ar = qw(48 44 40 36 32 28 24);
# my @W_tile_ar = qw(1 4 6 8 12);
# my @H_tile_ar = qw(1 3 4 4 6);
my @W_tile_ar = qw(8);
my @H_tile_ar = qw(8);
my $No_scheme = @W_tile_ar;
my $frame_rate	= 30;
my $GoP		= 24;
my $No_skip = 0;
my $No_FR = 300;
my $QP;
my $tile_W;
my $tile_H;
my $W_tile_num;
my $H_tile_num;
my $tile_num;
my $No_ver = 7;
my $tile_id;
my @tile_list = qw(2);
my $tile_folder;
my $log_folder;
my @longitude;
my @altitude;
my $cmd;
my $tile_name;

for(my $c = 0; $c < $No_scheme; $c++){
# for(my $c = 0; $c < $No_scheme; $c++){
    $W_tile_num = $W_tile_ar[$c];
    $tile_W = $ERP_W / $W_tile_num;
    $H_tile_num = $H_tile_ar[$c];
    $tile_H = $ERP_H / $H_tile_num;
    $tile_num = $W_tile_num * $H_tile_num;
    for (my $i = 0; $i < $tile_num; $i++) {
 		$longitude[$i] = int($i % $W_tile_num)  * $tile_W;
 		$altitude[$i] = int($i / $W_tile_num) * $tile_H;
 		print "$longitude[$i]\t$altitude[$i]\n";
    }
    # checking folders
    if(-e "${video_name}/ERP_${W_tile_num}x${H_tile_num}"){

    	}else{
    		$cmd = "mkdir ${video_name}/ERP_${W_tile_num}x${H_tile_num}";
    		system "$cmd";
    	}
    $tile_folder = "${video_name}/ERP_" . $W_tile_num . 'x' . $H_tile_num . '/tile_yuv/';
    if(-e $tile_folder){

    	}else{
    		$cmd = "mkdir $tile_folder";
    		system "$cmd";
    	}
    $log_folder = "${video_name}/ERP_" . $W_tile_num . 'x' . $H_tile_num . '/tile_log/';
    if(-e $log_folder){

   	}else{
    	$cmd = "mkdir $log_folder";
    	system $cmd;
    }
    print "$tile_folder\n$log_folder\n";
    #
    #next;
    for ($tile_id = 0; $tile_id < $tile_num; $tile_id++) {
	$tile_name = "f0_t${tile_id}_${tile_W}x${tile_H}.yuv";
	# extract tile
	my $generate_tile = 1;
	if($generate_tile == 1){
	    my $lt = ${longitude[$tile_id]};
	    my $at = ${altitude[$tile_id]};
	    my $cmd = "ffmpeg -y -s ${ERP_W}x${ERP_H} -r ${frame_rate} -i $source -filter:v \"crop=${tile_W}:${tile_H}:$lt:$at\" -frames ${No_FR} -c:v rawvideo -pix_fmt yuv420p ${tile_folder}${tile_name}";
	    print "$cmd\n";
	    if(-e "${tile_folder}${tile_name}"){
	    	print "${tile_folder}${tile_name} existed!\n";
	    }else{
	    	system $cmd;
	    }
	}
	
    }
    # exit;
}
