#!/usr/bin/env perl
#
# Create a histogram from data and print

#use lib './lib';

use Data::Dumper;
use Histogram;
use Getopt::Long;
use IO::File;

my %optctl;

my $bucketCount=20; # will actually be +1 for the max value
my $maxHistLineLen=100;
my $histChar='*';
my $file='';
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
	"file=s" => \$file,
	"lower-limit-op=s" => \$limitOperatorLower,
	"lower-limit-val=i" => \$limitValueLower,
	"upper-limit-op=s" => \$limitOperatorUpper,
	"upper-limit-val=i" => \$limitValueUpper,
	"h|help",
);

usage(0) if ( $optctl{h} or $optctl{help});

# reading from file
if ($file) {
	$fh = IO::File->new($file,'r') || die "cannot read file $file - $!\n";
} else {
# acting as filter
	while (<>) {chomp; push @data,sprintf("%.0f",$_)}
}

#print "File: $file\n";


my $h=Histogram->new(
	{
		LINE_LENGTH =>  $maxHistLineLen,
		HIST_CHAR => $histChar,
		BUCKET_COUNT => $bucketCount,
		DATA => \@data,
		FILE => $fh,
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
 --file            read data from a file 
                   this is useful only for files to large for memory
                   this option is quite slow as it uses the Tie::File package
                   the only advantage is very large files may be processed
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
  

 For a very large file:

   cut -d, -f2 mylargefile.csv > data.txt
	$basename --file data.txt --lower-limit-op '>=' --lower-limit-val 1 --upper-limit-op '<=' --upper-limit-val 99  --bucket-count 10

};


	exit eval { defined($exitVal) ? $exitVal : 0 };
}

