
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
  --h|help

  example:

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

</pre>

