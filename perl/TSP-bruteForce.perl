#!/usr/bin/perl

# card 134, PerplexCity Season 2


open LOG, ">TSP-bruteforce.log"
	or die "ERROR: could not open log file TSP-bruteforce.log" ;
open OUT, ">TSP-bruteforce.csv"
	or die "ERROR: could not open log file TSP-bruteforce.csv" ;



@points = ( "A", "C", "L", "S", "Z" );

#initial weights, in alphabetical order
# double them to make the problem symmetric

%weights = ( 
			"2" => {
						AC =>  6.95,
						CA =>  6.95,
						AL =>  3.30,
						LA =>  3.30,
						AS => 10.15,
						SA => 10.15,
						AZ =>  1.25,
						ZA =>  1.25,
						CS =>  9.55,
						SC =>  9.55,
						SZ => 10.00,
						ZS => 10.00,
						LS => 12.40,
						SL => 12.40,
						CZ =>  8.00,
						ZC =>  8.00,
						CL =>  6.05,
						LC =>  6.05,
						LZ =>  4.45,
						ZL =>  4.45
					},
		);



sub getWeightOf {
	my ($sequence) = @_;
	
	my @sequenceList = split(//, $sequence);

	# print LOG "  DEBUG GET: " . ($#sequenceList+1) . " $sequence \n";

	return $weights{$#sequenceList+1}{$sequence};

} # end sub getWeightOf


sub storeWeight {
	my ($sequence, $weight) = @_;

	my @sequenceList = split(//, $sequence);

	$weights{$#sequenceList+1}{$sequence} = $weight;
	
} # end sub getWeightOf




# sub attemptAddition (sequence, newPoint)
# returns a new total weight
# if invalid, returns 0
sub attemptAddition {

	my ($sequence, $newPoint) = @_;
	# the new segment, a string,
	# is the last point plus the new one

	@sequenceList = split (//, $sequence);
	
	my $newSegment = $sequenceList[$#sequenceList] . $newPoint;

	print LOG "   DEBUG: attempting $sequence + $newPoint \n";
	print LOG "   DEBUG: new segment $newSegment \n";
	
	# look for new point in the old sequence
	if ( $sequence =~ /$newPoint/ ) {
					print LOG "   DEBUG: found $newPoint in $sequence -- INVALID \n";
					return 0;
	}
	
	# fetch the new segment weight
	# and check it's legal
	
	if ( getWeightOf($newSegment) == 0 ) {
					# the new segment was invalid!
					print LOG "ERROR: invalid segment $newSegment \n";
					return 0;
	}

	# fetch the original sequence weight

	if ( getWeightOf($sequence) == 0 ) {
					# uh oh! the old sequence was invalid!
					print LOG "ERROR: invalid sequence $sequence !  " .
									"Trying to append $newSegment \n";
					return 0;
	}

	# store the new path
	my $newSequence = $sequence . $newPoint;
	storeWeight($newSequence, 
				getWeightOf($sequence) + getWeightOf($newSegment)
				);

	# return success
	return getWeightOf($newSequence);

}  # end sub attemptAddition







# for the length of the points list
# start at i=1, which is a two-point (1 segment) path

for ( $i = 1; $i <= $#points; $i++ ) {

	$order = $i + 1;
	print LOG "O($order) ($order points, $i segments) \n";

	foreach $totalSequence ( sort keys %{ $weights{$order}} ) {
		# for all paths of length $i,

		print LOG "DEBUG: key=$totalSequence , weight = " . getWeightOf($totalSequence) . " \n";

		# attempt to append each point in the list in turn
		
		foreach $candidatePoint (@points) {

			print LOG "CANDIDATE: $candidatePoint adding to $totalSequence \n";

			# use the return value for debug only
			$returnValue = attemptAddition ( $totalSequence, $candidatePoint );

			if ( $returnValue == 0 ) {
				print LOG "INVALID: $candidatePoint is in $totalSequence \n";
			} else {
				print LOG "ADDED $totalSequence" . "$candidatePoint = $returnValue \n";
			}

		} # end for all points in town list

	} # end for all paths of length $i

} # end for length of the points list


# okay, we're done generating all the strings
# now let's export that to a file

for ( $i = 1; $i <= $#points; $i++ ) {

	$order = $i + 1;

	foreach $totalSequence ( sort keys %{ $weights{$order}} ) {

		# puzzle requirement: it visits every city
		if ($order < 5) {
			next;
		}

		# puzzle requirement: starts with A...

		# @totalSequenceList = split ( //, $totalSequence );
		# if ( $totalSequenceList[0] eq "A" ) {
		#    print "DEBUG FINAL:  $totalSequence is good \n";
		# } else {
		#	next;
	    #    print "  DEBUG FINAL:  $totalSequence is bad \n";
		# }

		# unaltered data for all segments
		print OUT "$totalSequence,$order," . getWeightOf($totalSequence) . "\r";

		# puzzle requirement: they go home again
		# $lastSequence = $totalSequenceList[$#totalSequenceList] . "A";
		
		# print OUT "$totalSequence" . "A,";
		# print OUT getWeightOf($totalSequence) . ",";
		# print OUT "$lastSequence,";
		# print OUT getWeightOf($lastSequence) . ",";
		# print OUT getWeightOf($lastSequence) + getWeightOf($totalSequence);
		# print OUT "\r";
		
	}
}  # end print all	

close LOG;
close OUT;

