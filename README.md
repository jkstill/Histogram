
Simple histogram creation

see bin/histogram-demo.pl

bin/data-histogram.pl:

<pre>

  usage: data-histogram.pl - create a histogram from a series of integers

  --bucket-count    number of buckets - defaults to 20
  --line-length     max length of histogram lines - defaults to  100
  --hist-char       character used for histogram lines - defaults to *
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

Histogram of reads

head -1 /home/jkstill/perl/modules/roc/data/asm-dg-metrics-1.csv  | cut -f7 -d,
READS

(looks like a limit bug in the demo)

filter on READS of between 1 and 10

grep shrprd01 /home/jkstill/perl/modules/roc/data/asm-dg-metrics-1.csv  | cut -f7 -d, | data-histogram.pl --lower-limit-op '>=' --lower-limit-val 1 --upper-limit-op '<=' --upper-limit-val 10
Backup Count Decreased to 18 to avoid modulus divide by zero

         2:  50.1%  ****************************************************************************************************
         3:  33.4%  ******************************************************************
         4:   8.4%  ****************
         5:   2.7%  *****
         6:   0.7%  *
         7:   1.0%  **
         8:   1.8%  ***
         9:   0.2%
        10:   1.1%  **
        11:   0.6%  *

Histogram for size of reads <  ~80 Megabytes

head -1 /home/jkstill/perl/modules/roc/data/asm-dg-metrics-1.csv  | cut -f11 -d,
BYTES_READ


 grep shrprd01 /home/jkstill/perl/modules/roc/data/asm-dg-metrics-1.csv  | cut -f11 -d, | bin/data-histogram.pl --lower-limit-op '>=' --lower-limit-val 1 --upper-limit-op '<=' --upper-limit-val 819940556
  40991565:  83.1%  ****************************************************************************************************
  81983130:   3.5%  ****
 122974695:   1.0%  *
 163966260:   0.5%
 204957825:   0.4%
 245949390:   0.3%
 286940955:   0.4%
 327932520:   0.4%
 368924085:   0.8%
 409915650:   1.8%  **
 450907215:   1.7%  **
 491898780:   1.4%  *
 532890345:   0.6%
 573881910:   0.4%
 614873475:   0.5%
 655865040:   0.8%
 696856605:   1.0%  *
 737848170:   0.8%
 778839735:   0.4%
 819831300:   0.2%
 860822865:   0.0%


</pre>


