use strict;
use warnings;

use Net::IPAddress::Minimal;

my $input_string = shift @ARGV;

my $output = invert_ip( $input_string );