#!/usr/bin/env perl
#
# Create a histogram from data and print

use Data::Dumper;
use Histogram;
use Getopt::Long;

my %optctl;

my $bucketCount=20; # will actually be +1 for the max value
my $maxHistLineLen=100;
my $histChar='*';
# all limit variables must be set to be used
# otherwise they are silently ignored
my $limitOperatorLower;
my $limitOperatorUpper;
my $limitValueLower;
my $limitValueUpper;

GetOptions(\%optctl,
	"bucket-count=i" => \ $bucketCount,
	"line-length=i" => \$maxHistLineLen,
	"hist-char=s" => \$histChar,
	"lower-limit-op=s" => \$limitOperatorLower,
	"lower-limit-val=i" => \$limitValueLower,
	"upper-limit-op=s" => \$limitOperatorUpper,
	"upper-limit-val=i" => \$limitValueUpper,
	"h|help"
);

usage(0) if ( $optctl{h} or $optctl{help});

#my @data=<>;
#chomp @data;

my @data;

while (<>) {chomp; push @data,sprintf("%.0f",$_)}

my $h=Histogram->new(
	{
		LINE_LENGTH =>  $maxHistLineLen,
		HIST_CHAR => $histChar,
		BUCKET_COUNT => $bucketCount,
		DATA => \@data,
		FILTER_OPER_LOWER => $limitOperatorLower,
		FILTER_LIMIT_LOWER => $limitValueLower,
		FILTER_OPER_UPPER => $limitOperatorUpper,
		FILTER_LIMIT_UPPER => $limitValueUpper,
	}
);

print join("\n",  @{$h->prepare} ),"\n";


sub usage {

	my $exitVal = shift;
	use File::Basename;
	my $basename = basename($0);
	print qq{
$basename

usage: $basename - create a histogram from a series of integers

 --bucket-count    number of buckets - defaults to $bucketCount
 --line-length     max length of histogram lines - defaults to  $maxHistLineLen
 --hist-char       character used for histogram lines - defaults to $histChar
 --lower-limit-op  operator for lower bounds - one of < > <= >=
 --lower-limit-val value for lower bound
 --upper-limit-op  operator for upper bounds - one of < > <= >=
 --upper-limit-val value for upper bound
 --h|help

example:

   cut -d, -f2 mydata.csv | $basename --lower-limit-op '>=' --lower-limit-val 1 --upper-limit-op '<=' --upper-limit-val 99  --bucket-count 10

   9: ####################################################################################################
  18: ########################################################################
  27: #######################
  36: ##############
  45: #####
  54: ###
  63: ###
  72: ##
  81: ##
  90: ##
  99: #
 108: #
  

};


	exit eval { defined($exitVal) ? $exitVal : 0 };
}

