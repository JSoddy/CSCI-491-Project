
my $hands = 0;
my $state = "idle";
my $potsize = 0;
my $limit = 0;
my %players = ();
my %files   = ();

opendir (DIR, "input") or die "Could not open dir input: $!.\n";

while (my $dir = readdir(DIR)) {

	opendir (INDIR, "input/$dir") or die "Could not open dir input: $!.\n";
		while (my $file = readdir(INDIR)) {
			handlefile("$dir/$file");
		}
	closedir(INDIR);
}
print "\n";

print $hands;
print "\n";

foreach my $match (keys %files) {
	close $files{$match};
}

closedir(DIR);

sub handlefile() {
	open(INFILE, "input/@_[0]") or die "Cannot open input/@_[0]: $!.\n";
	print ".";

	while($line = <INFILE>) {
		if 		($state eq "idle") 		{idle($line);} 
		elsif 	($state eq "seating") 	{seating($line);} 
		elsif 	($state eq "preflop") 	{preflop($line);} 
		elsif 	($state eq "flop") 		{flop($line);} 
		elsif 	($state eq "turn") 		{turn($line);} 
		elsif 	($state eq "river") 	{river($line);} 
		elsif 	($state eq "showdown")	{showdown($line);} 
		elsif 	($state eq "summary") 	{summary($line);} 
		else 							{error($line);}
	}
	close INFILE;
}

sub idle() {
	if ($line =~ /Stage #\d*\:.*No Limit \$(\d*(?:.\d\d)?).*/) {
		$limit = $1;
		$hands++;
		$state = "seating";
		%players = ();
		$potsize = 0;
	}

}

sub seating() {
	if ($line eq "*** POCKET CARDS ***\r\n") {
		$state = "preflop";
	}
	elsif ($line eq "\r\n" ) {
		$state = "idle";
	} elsif ($line =~ /Seat \d{1,2} - (.{22}) \(.*/) {
		$line = $1;
		$line =~ s/\//\*/g;
		@player = (0, 0, "Uk", "Uk", 0, 0, 0, 0);
		$players{$line} = [@player];
	} elsif ($line =~ /(.{22}) \- Ante \$(\d*(?:.\d\d)?).*/){
		my $temp = $2;
		$potsize += $2;
		$line = $1;
		$line =~ s/\//\*/g;
		$players{$line}[0] -= $temp;
	} elsif ($line =~ /(.{22}) \- Posts.*\$(\d*(?:.\d\d)?).*/){
		my $temp = $2;
		$potsize += $2;
		$line = $1;
		$line =~ s/\//\*/g;
		$players{$line}[0] -= $temp;
	}
}

sub preflop() {
	if ($line eq "*** POCKET CARDS ***\r\n") {
		$state = "preflop";
	}
	elsif ($line eq "\r\n" ) {
		$state = "idle";
	}
	elsif ($line =~ /\*\*\* FLOP \*\*\*.*/) {
		$state = "flop";
	}
	elsif ($line eq "*** SHOW DOWN ***\r\n") {
		$state = "showdown";
	}
	elsif ($line =~ /(.{22}) \- Raises \$(\d*(?:.\d\d)?) to \$(\d*(?:.\d\d)?).*/) {
		my $raiseamount = $2;
		my $bet = $3;
		my $name = $1;
		$name =~ s/\//\*/g;
		$potsize += $bet - $raiseamount;
		if ($potsize ne 0) {
			$players{$name}[4 + $players{$name}[1]] = $raiseamount / $limit;
		}
		$players{$name}[1]++;
		$players{$name}[0] -= $bet;
		$potsize += $raiseamount;
	}
	elsif ($line =~ /(.{22}) \- Calls \$(\d*(?:.\d\d)?).*/) {
		my $call = $2;
		my $name = $1;
		$name =~ s/\//\*/g;
		if ($potsize ne 0) {
			$players{$name}[4 + $players{$name}[1]] -= $call / $limit;
		}
		$players{$name}[1]++;
		$players{$name}[0] -= $call;
		$potsize += $call;
	}
	elsif ($line =~ /(.{22}) \- returned \(\$(\d*(?:.\d\d)?)\).*/) {
		my $return = $2;
		my $name = $1;
		$name =~ s/\//\*/g;
		$players{$name}[0] += $return;
		$potsize -= $return;
	}
	elsif ($line =~ /(.{22}) \- All-In.* \$(\d*(?:.\d\d)?) to \$(\d*(?:.\d\d)?).*/) {
		my $raiseamount = $2;
		my $bet = $3;
		my $name = $1;
		$name =~ s/\//\*/g;
		$potsize += $bet - $raiseamount;
		if ($potsize ne 0) {
			$players{$name}[4 + $players{$name}[1]] = $raiseamount / $limit;
		}
		$players{$name}[1]++;
		$players{$name}[0] -= $bet;
		$potsize += $raiseamount;
	}
}

sub flop() {
	if ($line eq "*** TURN ***\r\n") {
		$state = "turn";
	} elsif ($line eq "\r\n" ) {
		$state = "idle";
	}
	elsif ($line eq "*** SHOW DOWN ***\r\n") {
		$state = "showdown";
	}
	elsif ($line =~ /(.{22}) \- Raises \$(\d*(?:.\d\d)?) to \$(\d*(?:.\d\d)?).*/) {
		my $raiseamount = $2;
		my $bet = $3;
		my $name = $1;
		$name =~ s/\//\*/g;
		$players{$name}[0] -= $bet;
	}
	elsif ($line =~ /(.{22}) \- Calls \$(\d*(?:.\d\d)?).*/) {
		my $call = $2;
		my $name = $1;
		$name =~ s/\//\*/g;
		$players{$name}[0] -= $call;
	}
	elsif ($line =~ /(.{22}) \- returned \(\$(\d*(?:.\d\d)?)\).*/) {
		my $return = $2;
		my $name = $1;
		$name =~ s/\//\*/g;
		$players{$name}[0] += $return;
	}
	elsif ($line =~ /(.{22}) \- All-In.* \$(\d*(?:.\d\d)?) to \$(\d*(?:.\d\d)?).*/) {
		my $raiseamount = $2;
		my $bet = $3;
		my $name = $1;
		$name =~ s/\//\*/g;
		$players{$name}[0] -= $bet;
	}
	elsif ($line =~ /(.{22}) \- Bets \$(\d*(?:.\d\d)?).*/) {
		my $bet = $2;
		my $name = $1;
		$name =~ s/\//\*/g;
		$players{$name}[0] -= $bet;
	}
}

sub turn() {
	if ($line eq "*** RIVER ***\r\n") {
		$state = "river";
	} elsif ($line eq "\r\n" ) {
		$state = "idle";
	}
	elsif ($line eq "*** SHOW DOWN ***\r\n") {
		$state = "showdown";
	}
	elsif ($line =~ /(.{22}) \- Raises \$(\d*(?:.\d\d)?) to \$(\d*(?:.\d\d)?).*/) {
		my $raiseamount = $2;
		my $bet = $3;
		my $name = $1;
		$name =~ s/\//\*/g;
		$players{$name}[0] -= $bet;
	}
	elsif ($line =~ /(.{22}) \- Calls \$(\d*(?:.\d\d)?).*/) {
		my $call = $2;
		my $name = $1;
		$name =~ s/\//\*/g;
		$players{$name}[0] -= $call;
	}
	elsif ($line =~ /(.{22}) \- returned \(\$(\d*(?:.\d\d)?)\).*/) {
		my $return = $2;
		my $name = $1;
		$name =~ s/\//\*/g;
		$players{$name}[0] += $return;
	}
	elsif ($line =~ /(.{22}) \- All-In.* \$(\d*(?:.\d\d)?) to \$(\d*(?:.\d\d)?).*/) {
		my $raiseamount = $2;
		my $bet = $3;
		my $name = $1;
		$name =~ s/\//\*/g;
		$players{$name}[0] -= $bet;
	}
	elsif ($line =~ /(.{22}) \- Bets \$(\d*(?:.\d\d)?).*/) {
		my $bet = $2;
		my $name = $1;
		$name =~ s/\//\*/g;
		$players{$name}[0] -= $bet;
	}
}

sub river() {
	if ($line eq "\r\n" ) {
		$state = "idle";
	}
	elsif ($line eq "*** SHOW DOWN ***\r\n") {
		$state = "showdown";
	}
	elsif ($line =~ /(.{22}) \- Raises \$(\d*(?:.\d\d)?) to \$(\d*(?:.\d\d)?).*/) {
		my $raiseamount = $2;
		my $bet = $3;
		my $name = $1;
		$name =~ s/\//\*/g;
		$players{$name}[0] -= $bet;
	}
	elsif ($line =~ /(.{22}) \- Calls \$(\d*(?:.\d\d)?).*/) {
		my $call = $2;
		my $name = $1;
		$name =~ s/\//\*/g;
		$players{$name}[0] -= $call;
	}
	elsif ($line =~ /(.{22}) \- returned \(\$(\d*(?:.\d\d)?)\).*/) {
		my $return = $2;
		my $name = $1;
		$name =~ s/\//\*/g;
		$players{$name}[0] += $return;
	}
	elsif ($line =~ /(.{22}) \- All-In.* \$(\d*(?:.\d\d)?) to \$(\d*(?:.\d\d)?).*/) {
		my $raiseamount = $2;
		my $bet = $3;
		my $name = $1;
		$name =~ s/\//\*/g;
		$players{$name}[0] -= $bet;
	}
	elsif ($line =~ /(.{22}) \- Bets \$(\d*(?:.\d\d)?).*/) {
		my $bet = $2;
		my $name = $1;
		$name =~ s/\//\*/g;
		$players{$name}[0] -= $bet;
	}
}

sub showdown() {
	if ($line eq "*** SUMMARY ***\r\n") {
		$state = "summary";
	}
	elsif ($line eq "\r\n" ) {
		$state = "idle";
	}
	elsif ($line =~ /(.{22}) Collects \$(\d*(?:.\d\d)?).*/) {
		my $win = $2;
		my $name = $1;
		$name =~ s/\//\*/g;
		$players{$name}[0] += $win;
	}
	elsif ($line =~ /(.{22}) - Shows \[(.{2}) (.{2})\].*/) {
		my $c1 = $2;
		my $c2 = $3;
		my $name = $1;
		$name =~ s/\//\*/g;
		$players{$name}[2] = $c1;
		$players{$name}[3] = $c2;
	}
}

sub summary() {
	if ($line eq "*** POCKET CARDS ***\r\n") {
		$state = "preflop";
	}
	elsif ($line eq "\r\n" ) {
		# Write the hand data to each player's file
		foreach my $match (keys %players) {
			#if ($players{$match}[3] ne "Uk") {
				my $file;
				open($file, '>>', "output/$match.hands") or print "Cannot open file output/$match.hands";
				say $file "@{ $players{$match}}";
				close $file;
			#}
		}
		$state = "idle";
	}
	elsif ($line =~ /Seat \d: (.{22}) .* \[((?:\w|\d{1,2})\w) ((?:\w|\d{1,2})\w) \-.*/){
		my $c1 = $2;
		my $c2 = $3;
		my $name = $1;
		$name =~ s/\//\*/g;
		$players{$name}[2] = $c1;
		$players{$name}[3] = $c2;
	}
}

sub error() {
	if ($line eq "\r\n") {
		$state = "idle";
		print "Error Idle\n";
	}
}