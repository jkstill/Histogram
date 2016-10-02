
package Histogram;

use strict;
use warnings;
use Data::Dumper;

=head1 Histogram

 This is a simple histogram function used to visualize the distribution of a series of integer data

 The data may be filtered using < > <= >=

 The following example generates a random range of data, ignoring values > 80

 use Histogram;

 my $randMax=7537;

 my @data = map { int(rand($randMax)) } (1..$randMax);

 my $bucketCount=27; # will actually be +1 for the max value

 # print a histogram
 my $maxHistLineLen=50;
 my $histChar='*';
 my $minValue=2000;
 my $maxValue=5000;
 my $limitOperatorLower = '>=';
 my $limitOperatorUpper = '<=';

 my $h=Histogram->new(
   {
      LINE_LENGTH =>  $maxHistLineLen,
      HIST_CHAR => '*',
      BUCKET_COUNT => $bucketCount,
      DATA => \@data,
      FILTER_OPER_LOWER =>  $limitOperatorLower,
      FILTER_OPER_UPPER =>  $limitOperatorUpper,
      FILTER_LIMIT_LOWER =>  $minValue,
      FILTER_LIMIT_UPPER =>  $maxValue
   }
 );

 print join("\n",  @{$h->prepare} ),"\n";

 If the filter limits are to be used, all of the lower and upper values and operators must be set


=cut


sub new {
	
	my $pkg = shift;
	my $class = ref($pkg) || $pkg;
	my $parms= shift;

	#print Dumper($parms);
	#print join(' - ', keys %{$parms}), "\n";

	my $self = $parms;

	my $retval =  bless $self, $class;

	#print 'new: ', Dumper($self);
	$self->_createBuckets();

	return $retval;

}

sub _createBuckets {
	my $self=shift;

	#print join(' - ', keys %{$parms}), "\n";

	my %hdata=();

	FILTER_DATA: {
		if ( 
				defined($self->{FILTER_OPER_LOWER})
				and defined($self->{FILTER_OPER_UPPER})
				and defined($self->{FILTER_LIMIT_LOWER}) 
				and defined($self->{FILTER_LIMIT_UPPER}) 
		) {
			# check for allowed operator
			my @allowedOperators = qw(< > <= >=);

			my $opLower=$self->{FILTER_OPER_LOWER};
			if ( ! grep(/^$opLower$/,@allowedOperators) ) {
				last FILTER_DATA;
			}

			my $opUpper=$self->{FILTER_OPER_UPPER};
			if ( ! grep(/^$opUpper$/,@allowedOperators) ) {
				last FILTER_DATA;
			}

			my $filterValueLower = $self->{FILTER_LIMIT_LOWER};
			my $filterValueUpper = $self->{FILTER_LIMIT_UPPER};

			my @tmpData;
			#print "OP: $op\n";
			#print "Value $filterValue\n";
			my $evalStr= q[grep { $_ ]
				. qq[ $opLower  $filterValueLower ]
				. q[ and $_ ]
				. qq[ $opUpper $filterValueUpper  ]
				. q[ } @{$self->{DATA}};];

			#print "Eval String; $evalStr\n";
			@tmpData = eval $evalStr;

			#print Dumper(\@tmpData);

			$self->{DATA} = \@tmpData;

		}
	}

	my ($min,$max) = (10**20,0);

	for (@{$self->{DATA}}) {
		my $n = $_;
		#print "n:|$n|\n";
		$min = $n if $n < $min;
		$max = $n if $n > $max;
	}

	#print '_createBuckets: ', Dumper($self);
	#my $bucketSize = sprintf("%.0f",(($max-$min)/$self->{BUCKET_COUNT}));
	my $bucketSize = 0;
	my ($sanityLevel,$sanityLimit) = (0,100);

	# avoid bucketSize < 1 as it leads to divide by 0 errors with the modulus operator
	# try perl -e '$x=10%.5'
	# reduce bucket count until bucket size is at least 1
	my $bucketCount = $self->{BUCKET_COUNT};
	while ($bucketSize < 1) {
		$bucketSize = sprintf("%.0f",(($max-$min)+1)/$bucketCount);
		$sanityLevel++;
		$bucketCount--;

		die "Error getting bucketSize in Histogram module\n" if $sanityLevel >= $sanityLimit;
	}
	
	if ($sanityLevel > 1) {
		warn "Backup Count Decreased to $bucketCount to avoid modulus divide by zero\n\n";
		$self->{BUCKET_COUNT} = $bucketCount;
	}

	#print "_createBuckets bucketSize $bucketSize\n";
	$self->{MIN_VALUE} = $min;
	$self->{MAX_VALUE} = $max;

#print qq{
#
#min: $self->{MIN_VALUE}
#max: $self->{MAX_VALUE}
#bucketCount: $self->{BUCKET_COUNT}
#bucketSize $bucketSize
#
#};

	my $maxHistogramCount=0;

	for (@{$self->{DATA}}) {
		my $n = $_;

		my $bucket = ($n - ($n%$bucketSize) ) + $bucketSize;
	
		#print "n: $n  bucket $bucket\n";
		$hdata{$bucket}++;

	}

	#print 'hdata: ' . Dumper(\%hdata), "\n";


	my $totalMetricCount=0;
	foreach my $bucket ( sort {$a <=> $b} keys %hdata ) {
		my $hCount=$hdata{$bucket};
		$totalMetricCount += $hCount;
		#print "Bucket:Counts:  $bucket : $hCount \n";
		# get the max count
		$maxHistogramCount = $hCount unless $maxHistogramCount > $hCount
	}


	#print "maxHistogramCount $maxHistogramCount\n";
	#print "Line Length: $self->{LINE_LENGTH}\n";

	$self->{HDATA} = \%hdata;
	$self->{_countPerChar} = $self->{LINE_LENGTH} / $maxHistogramCount;
	$self->{_totalMetricCount} = $totalMetricCount;
	#print "_countPerChar: $self->{_countPerChar}\n";
	
	#print '_createBuckets: ', Dumper($self);

}


sub prepare {
	my $self=shift;

	my @histogram;

	#print "PRINT ROUTINE\n";
	my %hdata = %{$self->{HDATA}};

	foreach my $bucket ( sort {$a <=> $b} keys %hdata ) {

		my $pct = $hdata{$bucket} / $self->{_totalMetricCount} * 100;
		# strange of of sprintf seems the only way to correctly right justify the pct
		# sprintf('%3.1f',$pct) is not doing it
		my $hline = sprintf("%10d: %5s%%  ",$bucket, sprintf('%3.1f',$pct));
		my $lineLen=0;
		if ($self->{_countPerChar} < 1 ) {
			$lineLen = int( $hdata{$bucket}  * $self->{_countPerChar});
			$hline .= $self->{HIST_CHAR} x  $lineLen  ;
		} else {
			$lineLen = int( $hdata{$bucket}  / $self->{_countPerChar});
			$hline .= $self->{HIST_CHAR} x int( $lineLen  * $self->{_countPerChar}) ;
		}
		#print "lineLen: $lineLen\n";
		push @histogram, $hline;
		#print "$hline\n";
	}

	\@histogram;
}

1;


