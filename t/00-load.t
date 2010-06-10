#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Net::IPAddress::Minimal' ) || print "Bail out!
";
}

diag( "Testing Net::IPAddress::Minimal $Net::IPAddress::Minimal::VERSION, Perl $], $^X" );
