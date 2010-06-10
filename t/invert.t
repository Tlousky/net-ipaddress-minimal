#!perl

# checking that invertion works the way we think it should

use strict;
use warnings;
use Test::More tests => 9;
use Net::IPAddress::Minimal 'invert_ip';
use Test::Exception;

my $ip_a   = '7.91.205.21';
my $ip_num = 123456789;

{
    no warnings qw/redefine once/;

    *Net::IPAddress::Minimal::num_to_ip = sub {
        cmp_ok( scalar @_, '==', 1, 'correct number of params num_to_ip()' );
        cmp_ok( $_[0], '==', $ip_num, 'correct param num_to_ip()' );
    };

    *Net::IPAddress::Minimal::ip_to_num = sub {
        cmp_ok( scalar @_, '==', 1, 'correct number of params ip_to_num()' );
        is( $_[0], $ip_a, 'correct param ip_to_num()' );
    };
}

invert_ip($ip_a);
invert_ip($ip_num);

is(
    invert_ip('waka waka'),
    'Illegal string. Please use IPv4 strings or numbers.',
    'got illegal string from invert_ip()',
);

is(
    invert_ip(),
    'Empty string. Please use IPv4 strings or numbers.',
    'got empty string from invert_ip()',
);

{
    no warnings qw/redefine once/;

    *Net::IPAddress::Minimal::test_string_structure = sub {
        cmp_ok( scalar @_, '==', 1, 'no. of param test_string_structure()' );
        is( $_[0], 'test', 'correct param for test_string_structure()' );
        return 'waka waka';
    };
}

throws_ok { invert_ip('test') }
    qr{^Could not convert IP string / number due to unknown error},
    'invert_ip() can really die';

