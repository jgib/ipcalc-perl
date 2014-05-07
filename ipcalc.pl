#!/usr/bin/env perl
use strict;
use warnings;

my (@binary,@bits,$input,$i,$netbit,@netbit,$hostbit,@hostbit,$snm1,$snm2,$snm3,$snm4,@ip1,@ip2,@ip3,@ip4,$ip1,$ip2,$ip3,$ip4,@netid1,@netid2,@netid3,@netid4,$netid1,$netid2,$netid3,$netid4,@bc1,@bc2,@bc3,@bc4,$bc1,$bc2,$bc3,$bc4,@snm1,@snm2,@snm3,@snm4);

sub tobinary {
	my $arg = $_[0];
	if($arg > 255 || $arg < 0){
		return -1;
	}
	@binary = (0,0,0,0,0,0,0,0);
	if($arg >= 128){
		$binary[0] = 1;
		$arg = $arg - 128;
	}
	if($arg >= 64){
		$binary[1] = 1;
		$arg = $arg - 64;
	}
	if($arg >= 32){
		$binary[2] = 1;
		$arg = $arg - 32;
	}
	if($arg >= 16){
		$binary[3] = 1;
		$arg = $arg - 16;
	}
	if($arg >= 8){
		$binary[4] = 1;
		$arg = $arg - 8;
	}
	if($arg >= 4){
		$binary[5] = 1;
		$arg = $arg - 4;
	}
	if($arg >= 2){
		$binary[6] = 1;
		$arg = $arg - 2;
	}
	if($arg >= 1){
		$binary[7] = 1;
		$arg = $arg - 1;
	}
	return @binary;
}

sub and{
	if( $_[0] == 0 && $_[1] == 0){
		return 0;
	}elsif($_[0] == 0 && $_[1] == 1){
		return 0;
	}elsif($_[0] == 1 && $_[1] == 0){
		return 0;
	}elsif($_[0] == 1 && $_[1] == 1){
		return 1;
	}
}

sub subnetmask{
	if($_[0] <= 32 && $_[0] > 24){
		$snm4 = $_[0] - 24;
		$snm3 = 8;
		$snm2 = 8;
		$snm1 = 8;
	}elsif($_[0] <= 24 && $_[0] > 16){
		$snm4 = 0;
		$snm3 = $_[0] - 16;
		$snm2 = 8;
		$snm1 = 8;
	}elsif($_[0] <= 16 && $_[0] > 8){
		$snm4 = 0;
		$snm3 = 0;
		$snm2 = $_[0] - 8;
		$snm1 = 8;
	}elsif($_[0] <= 8 && $_[0] >= 0){
		$snm4 = 0;
		$snm3 = 0;
		$snm2 = 0;
		$snm1 = $_[0] - 0;
	}
	$snm1 = (2**8) - (2**$snm1);
	$snm2 = (2**8) - (2**$snm2);
	$snm3 = (2**8) - (2**$snm3);
	$snm4 = (2**8) - (2**$snm4);
}

sub binarybits{
	@bits = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
	for($i = $_[0] - 1; $i >= 0; $i--){
		$bits[$i] = 1;
	}
	return @bits;
}

sub flipbits{
	if($_[0] == 0){
		return 1;
	}
	if($_[0] == 1){
		return 0;
	}
}

sub broadcast{
	if($_[1] == 1 && $_[0] == 0){
		return 0;
	}elsif($_[1] == 1 && $_[0] == 1){
		return 1;
	}elsif($_[1] == 0){
		return 1;
	}
}


sub output{
	print "\nNetwork ID:\t$netid1.$netid2.$netid3.$netid4\t@netid1.@netid2.@netid3.@netid4";
	print "\nSubnet Mask:\t$snm1.$snm2.$snm3.$snm4\t@snm1.@snm2.@snm3.@snm4";
	print "\nBroadcast:\t$bc1.$bc2.$bc3.$bc4\t@bc1.@bc2.@bc3.@bc4";
	print "\nNetwork Bit:\t$netbit\t\t@netbit";
	print "\nHost Bit:\t$hostbit\t\t@hostbit";
	my $hosts = (2**$hostbit) - 2;
	print "\nNumber of Hosts:$hosts\n";
}

sub error{
	print "\nError, must be a valid IP address in CIDR notation.\n";
	exit;
}

sub main{
	while(1){
		print "\nEnter address in CIDR notation: ";
		chomp($input = <>);
		if($input =~ m/^q$/i || $input =~ m/^quit$/i || $input =~ m/^exit$/i){
			exit;
		}elsif($input =~ m/(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})\/(\d{1,2})/){
			if($1 > 255 || $1 < 0 || $2 > 255 || $2 < 0 || $3 > 255 || $3 < 0 || $4 > 255 || $4 < 0 || $5 > 32 || $5 < 0){
				&error;
			}
			@ip1 = &tobinary($1);
			@ip2 = &tobinary($2);
			@ip3 = &tobinary($3);
			@ip4 = &tobinary($4);
			$netbit = $5;
			$hostbit = 32 - $netbit;
			&subnetmask($netbit);
			@snm1 = reverse(&tobinary($snm1));
			@snm2 = reverse(&tobinary($snm2));
			@snm3 = reverse(&tobinary($snm3));
			@snm4 = reverse(&tobinary($snm4));
			@netbit = &binarybits($netbit);
			@hostbit = reverse(&binarybits($hostbit));
			$snm1 = 0;
			$snm2 = 0;
			$snm3 = 0;
			$snm4 = 0;
			$bc1 = 0;
			$bc2 = 0;
			$bc3 = 0;
			$bc4 = 0;
			$netid1 = 0;
			$netid2 = 0;
			$netid3 = 0;
			$netid4 = 0;
			for($i = 0;$i <= 7;$i++){
				$snm1[$i] = &flipbits($snm1[$i]);
				$snm2[$i] = &flipbits($snm2[$i]);
				$snm3[$i] = &flipbits($snm3[$i]);
				$snm4[$i] = &flipbits($snm4[$i]);
				$netid1[$i] = &and($ip1[$i],$snm1[$i]);
				$netid2[$i] = &and($ip2[$i],$snm2[$i]);
				$netid3[$i] = &and($ip3[$i],$snm3[$i]);
				$netid4[$i] = &and($ip4[$i],$snm4[$i]);
				$bc1[$i] = &broadcast($netid1[$i],$snm1[$i]);
				$bc2[$i] = &broadcast($netid2[$i],$snm2[$i]);
				$bc3[$i] = &broadcast($netid3[$i],$snm3[$i]);
				$bc4[$i] = &broadcast($netid4[$i],$snm4[$i]);
				if($netid1[$i] == 1){
					$netid1 = (2 ** (7 - $i)) + $netid1;
				}
				if($netid2[$i] == 1){
					$netid2 = (2 ** (7 - $i)) + $netid2;
				}
				if($netid3[$i] == 1){
					$netid3 = (2 ** (7 - $i)) + $netid3;
				}
				if($netid4[$i] == 1){
					$netid4 = (2 ** (7 - $i)) + $netid4;
				}
				if($snm1[$i] == 1){
					$snm1 = (2 ** (7 - $i)) + $snm1;
				}
				if($snm2[$i] == 1){
					$snm2 = (2 ** (7 - $i)) + $snm2;
				}
				if($snm3[$i] == 1){
					$snm3 = (2 ** (7 - $i)) + $snm3;
				}
				if($snm4[$i] == 1){
					$snm4 = (2 ** (7 - $i)) + $snm4;
				}
				if($bc1[$i] == 1){
					$bc1 = (2 ** (7 - $i)) + $bc1;
				}
				if($bc2[$i] == 1){
					$bc2 = (2 ** (7 - $i)) + $bc2;
				}
				if($bc3[$i] == 1){
					$bc3 = (2 ** (7 - $i)) + $bc3;
				}
				if($bc4[$i] == 1){
					$bc4 = (2 ** (7 - $i)) + $bc4;
				}
			}
			&output;
		}else{
			&error;
		}
	}
}
                        for(my $i = 0; $i <= $#snm1; $i++){
                                if($snm1[$i] == 0){
                                        $snm1[$i] = 1;
                                }elsif($snm1[$i] == 1){
                                        $snm1 = 0;
                                }
                        }
&main;
