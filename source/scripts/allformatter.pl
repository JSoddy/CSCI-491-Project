my $count = 0;
my $winnings = 0;

opendir (DIR, "input2") or die "Could not open dir input2: $!.\n";

while (my $file = readdir(DIR)) {
	handlefile("$file");
}

closedir(DIR);

sub handlefile() {
	$filename = @_[0];
	my %totals1;
	my %counts1;
	my %totals2;
	my %counts2;
	for (my $i=14; $i >= 2; $i--) {
		for (my $j=14; $j >= 2; $j--) {
			$counts1{$i}{$j} = 0;
			$totals1{$i}{$j} = 0;
			$counts2{$i}{$j} = 0;
			$totals2{$i}{$j} = 0;
		}
	}


	open(INFILE, "input2/$filename") or die "Cannot open input2/$filename: $!.\n";
	open($file, '>>', "output2/$filename") or print "Cannot open file output2/$filename: $!";
	$count = 0;
	$winnings = 0;

	while($line = <INFILE>) {
		if ($line =~ /(-?\d*(?:.\d*)?) \d* (\w|\d*)(\w) (\w|\d*)(\w) -?(\d*(?:.\d*)?) -?(\d*(?:.\d*)?) -?(\d*(?:.\d*)?) -?(\d*(?:.\d*)?)/){
			$count++;
			$winnings += $1;
			# print "Winnings: $winnings, hands: $count, change: $1\n";
			my $firstcard = $2;
			my $secondcard = $4;
			# handle facecards
			if ($firstcard eq "A") {
				$firstcard = 14;
			} elsif ($firstcard eq "K") {
				$firstcard = 13;
			} elsif ($firstcard eq "Q") {
				$firstcard = 12;
			} elsif ($firstcard eq "J") {
				$firstcard = 11;
			} elsif ($firstcard eq "U") {
				$firstcard = 0;
			}
			if ($secondcard eq "A") {
				$secondcard = 14;
			} elsif ($secondcard eq "K") {
				$secondcard = 13;
			} elsif ($secondcard eq "Q") {
				$secondcard = 12;
			} elsif ($secondcard eq "J") {
				$secondcard = 11;
			} elsif ($secondcard eq "U") {
				$secondcard = 0;
			}
			if ($3 eq $5) {
				if ($firstcard < $secondcard) {
					my $temp = $firstcard;
					$firstcard = $secondcard;
					$secondcard = $temp;
				}
			} else {
				if ($firstcard > $secondcard) {
					my $temp = $firstcard;
					$firstcard = $secondcard;
					$secondcard = $temp;
				}
			}
			#if (int(rand(2)) == 1) {
				if ($5 ne 0){
					$totals1{$firstcard}{$secondcard} += $5;
					$counts1{$firstcard}{$secondcard}++;
				}
				if ($6 ne 0) {
					$totals1{$firstcard}{$secondcard} += $6;
					#$counts1{$firstcard}{$secondcard}++;
				}
				if ($7 ne 0) {
					$totals1{$firstcard}{$secondcard} += $7;
					#$counts1{$firstcard}{$secondcard}++;
				}
				if ($8 ne 0) {
					$totals1{$firstcard}{$secondcard} += $8;
					#$counts1{$firstcard}{$secondcard}++;
				}
				my $total = $5 + $6 + $7 + $8;
				if ($firstcard ne 0){
					$file->print("$firstcard $secondcard $total\n");
				}
			#} else {
			#	if ($5 ne 0){
			#		$totals2{$firstcard}{$secondcard} += $5;
			#		$counts2{$firstcard}{$secondcard}++;
			#	}
			#	if ($6 ne 0) {
			#		$totals2{$firstcard}{$secondcard} += $6;
			#		#$counts2{$firstcard}{$secondcard}++;
			#	}
			#	if ($7 ne 0) {
			#		$totals2{$firstcard}{$secondcard} += $7;
			#		#$counts2{$firstcard}{$secondcard}++;
			#	}
			#	if ($8 ne 0) {
			#		$totals2{$firstcard}{$secondcard} += $8;
			#		#$counts2{$firstcard}{$secondcard}++;
			#	}
			#}
		}
	}
	close INFILE;

	$file->print("\n\nTotal winnings: $winnings, Total hands: $count\n\n");

	close $file;
	#print "\n\n";
}