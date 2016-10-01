
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

  cut -d, -f2 mydata.csv | data-histogram.pl --lower-limit-op '>=' --lower-limit-val 1 --upper-limit-op '<=' --upper-limit-val 99  --bucket-count 10
  
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
</pre>

