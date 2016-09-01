
package Histogram;

use strict;
use warnings;
use Data::Dumper;

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

	my ($min,$max) = (10**20,0);

	for (@{$self->{DATA}}) {
		my $n = $_;
		$min = $n if $n < $min;
		$max = $n if $n > $max;
	}

	#print '_createBuckets: ', Dumper($self);
	my $bucketSize = int(($max-$min)/$self->{BUCKET_COUNT});
	#print "_createBuckets bucketSize $bucketSize\n";
	$self->{MIN_VALUE} = $min;
	$self->{MAX_VALUE} = $max;

	my $maxHistogramCount=0;

	for (@{$self->{DATA}}) {
		my $n = $_;
		my $bucket = ($n - $n%$bucketSize ) + $bucketSize;
	
		#print "n: $n  bucket $bucket\n";
		
		push @{$hdata{$bucket}}, $n;

	}


	foreach my $bucket ( sort {$a <=> $b} keys %hdata ) {
		my $hCount=$#{$hdata{$bucket}}+1;
		#print "Bucket:Counts:  $bucket : $hCount \n";
		# get the max count
		$maxHistogramCount = $hCount unless $maxHistogramCount > $hCount
	}


	#print "maxHistogramCount $maxHistogramCount\n";

	$self->{HDATA} = \%hdata;
	$self->{_countPerChar} = $maxHistLineLen / $maxHistogramCount;
	
	#print '_createBuckets: ', Dumper($self);

}


sub prepare {
	my $self=shift;

	my @histogram;

	#print "PRINT ROUTINE\n";
	my %hdata = %{$self->{HDATA}};

	foreach my $bucket ( sort {$a <=> $b} keys %hdata ) {
	
		my $lineLen = int( $#{$hdata{$bucket}}+1  / $self->{_countPerChar});
		my $hline = sprintf("%10d: ",$bucket );
		$hline .= $histChar x int( $lineLen  * $self->{_countPerChar}) ;
		push @histogram, $hline;
		#print "$hline\n";
	}

	\@histogram;
}

1;


