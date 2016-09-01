#!/usr/bin/env perl
use Data::Dumper;
use Histogram;

my $randMax=7537;

my @data = map { int(rand($randMax)) } (1..$randMax);

#print Dumper(\@data);

my $bucketCount=27; # will actually be +1 for the max value

# print a histogram
my $maxHistLineLen=50;
my $histChar='*';

my $h=Histogram->new(
	{
		LINE_LENGTH =>  $maxHistLineLen,
		HIST_CHAR => '*',
		BUCKET_COUNT => $bucketCount,
		DATA => \@data
	}
);

print join("\n",  @{$h->prepare} ),"\n";


