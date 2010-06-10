use strict;
use warnings;

use Net::IPAddress::Minimal;

my $input_string = shift @ARGV;

my $num_ip_convertor = Net::IPAddress::Simple->new( 
    input_string => $input_string,
);

my $output = $num_ip_converter->convert();