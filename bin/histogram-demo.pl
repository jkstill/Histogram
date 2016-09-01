#!/usr/bin/env perl
use Data::Dumper;

use lib './lib';

use Histogram;

my $randMax=7537;

my @data = map { int(rand($randMax)) } (1..$randMax);

#print Dumper(\@data);

my $bucketCount=27; # will actually be +1 for the max value

# print a histogram
my $maxHistLineLen=50;
my $histChar='*';
my $filterValueLower=2000;
my $filterValueUpper=5000;
my $limitOperatorLower = '>';
my $limitOperatorUpper = '<=';

my $h=Histogram->new(
	{
		LINE_LENGTH =>  $maxHistLineLen,
		HIST_CHAR => '*',
		BUCKET_COUNT => $bucketCount,
		DATA => \@data,
		FILTER_OPER_LOWER => $limitOperatorLower,
		FILTER_LIMIT_LOWER => $filterValueLower,
		FILTER_OPER_UPPER => $limitOperatorUpper,
		FILTER_LIMIT_UPPER => $filterValueUpper,
	}
);

print join("\n",  @{$h->prepare} ),"\n";


