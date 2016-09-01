use 5.008002;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
	NAME              => 'Histogram',
	VERSION_FROM      => 'lib/Histogram.pm', # finds $VERSION
	EXE_FILES			=> [
		qw{bin/histogram-demo.pl}
	],
	PREREQ_PM         => { 
		'Exporter' => 5.0,
		'Data::Dumper' => 2.0
	}, # e.g., Module::Name => 1.1
	($] >= 5.005 
		?     ## Add these new keywords supported since 5.005
			(
				ABSTRACT  => 'Simple Histogram creation', # retrieving abstract from module is broken - hardcoded
				AUTHOR         => 'Jared Still <jkstill@gmail.com>') 
		: ()
	),
);


