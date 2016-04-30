my $count = 0;

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

	while($line = <INFILE>) {
		if ($line =~ /-?\d*(?:.\d*)? \d* (\w|\d*)(\w) (\w|\d*)(\w) -?(\d*(?:.\d*)?) -?(\d*(?:.\d*)?) -?(\d*(?:.\d*)?) -?(\d*(?:.\d*)?)/){
			my $firstcard = $1;
			my $secondcard = $3;
			# handle facecards
			if ($firstcard eq "A") {
				$firstcard = 14;
			} elsif ($firstcard eq "K") {
				$firstcard = 13;
			} elsif ($firstcard eq "Q") {
				$firstcard = 12;
			} elsif ($firstcard eq "J") {
				$firstcard = 11;
			}
			if ($secondcard eq "A") {
				$secondcard = 14;
			} elsif ($secondcard eq "K") {
				$secondcard = 13;
			} elsif ($secondcard eq "Q") {
				$secondcard = 12;
			} elsif ($secondcard eq "J") {
				$secondcard = 11;
			}
			if ($2 eq $4) {
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
			if (int(rand(2)) == 1) {
				$totals1{$firstcard}{$secondcard} += $4;
				$counts1{$firstcard}{$secondcard}++;
				if ($5 ne 0) {
					$totals1{$firstcard}{$secondcard} += $5;
					$counts1{$firstcard}{$secondcard}++;
				}
				if ($6 ne 0) {
					$totals1{$firstcard}{$secondcard} += $6;
					$counts1{$firstcard}{$secondcard}++;
				}
				if ($7 ne 0) {
					$totals1{$firstcard}{$secondcard} += $7;
					$counts1{$firstcard}{$secondcard}++;
				}
			} else {
				$totals2{$firstcard}{$secondcard} += $4;
				$counts2{$firstcard}{$secondcard}++;
				if ($5 ne 0) {
					$totals2{$firstcard}{$secondcard} += $5;
					$counts2{$firstcard}{$secondcard}++;
				}
				if ($6 ne 0) {
					$totals2{$firstcard}{$secondcard} += $6;
					$counts2{$firstcard}{$secondcard}++;
				}
				if ($7 ne 0) {
					$totals2{$firstcard}{$secondcard} += $7;
					$counts2{$firstcard}{$secondcard}++;
				}
			}
		}
	}
	close INFILE;

	open($file, '>>', "output2/$filename") or print "Cannot open file output/$filename: $!";

	$file->print("Set A:\n\n");

	for (my $i=14; $i >= 2; $i--) {
		for (my $j=14; $j >= 2; $j--) {
			if ($counts1{$i}{$j} ne 0) {
				my $avg = $totals1{$i}{$j} / $counts1{$i}{$j};
				print "$avg ";
				$file->print("$avg ");
			} else {
				print "0 ";
				$file->print("0 ");
			}
		}
		print "\n";
		$file->print("\n");
	}
	print "\n";
	$file->print("\n");

	for (my $i=14; $i >= 2; $i--) {
		for (my $j=14; $j >= 2; $j--) {
			if ($counts1{$i}{$j} ne 0) {
				my $avg = $totals1{$i}{$j} / $counts1{$i}{$j};
				$file->print("$i $j $avg\n");
			} else {
				$file->print("$i $j 0\n");
			}
		}
	}
	$file->print("\n");

	$file->print("Set B:\n\n");

	for (my $i=14; $i >= 2; $i--) {
		for (my $j=14; $j >= 2; $j--) {
			if ($counts2{$i}{$j} ne 0) {
				my $avg = $totals2{$i}{$j} / $counts2{$i}{$j};
				print "$avg ";
				$file->print("$avg ");
			} else {
				print "0 ";
				$file->print("0 ");
			}
		}
		print "\n";
		$file->print("\n");
	}

	for (my $i=14; $i >= 2; $i--) {
		for (my $j=14; $j >= 2; $j--) {
			if ($counts2{$i}{$j} ne 0) {
				my $avg = $totals2{$i}{$j} / $counts2{$i}{$j};
				$file->print("$i $j $avg\n");
			} else {
				$file->print("$i $j 0\n");
			}
		}
	}
	$file->print("\n");

	close $file;
	print "\n\n";
}