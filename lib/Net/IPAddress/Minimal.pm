package Net::IPAddress::Minimal;

use strict;
use warnings;

use Data::Validate     'is_integer';
use Data::Validate::IP 'is_ipv4';
use base 'Exporter';

our @EXPORT_OK = qw( ip_to_num num_to_ip invert_ip );
our $VERSION   = '0.03';

sub test_string_structure {
    my $string = shift || q{};

    is_ipv4($string)    && return 'ip';
    is_integer($string) && return 'num';
    $string             || return 'empty';

    return 'err';
}

sub ip_to_num {
    # Converting between IP to number is according to this formula:
    # IP = A.B.C.D
    # IP Number = A x (256**3) + B x (256**2) + C x 256 + D
    my $ip = shift;

    my ( $Aclass, $Bclass, $Cclass, $Dclass ) = split /\./, $ip;
    
    my $num = (
        $Aclass * 256**3 +
        $Bclass * 256**2 +
        $Cclass * 256    +
        $Dclass
    );

    return $num;
}

sub num_to_ip {
    my $ipnum = shift;

    my $z = $ipnum % 256;
    $ipnum >>= 8;
    my $y = $ipnum % 256;
    $ipnum >>= 8;
    my $x = $ipnum % 256;
    $ipnum >>= 8;
    my $w = $ipnum % 256;

    my $ipstr = "$w.$x.$y.$z";

    return $ipstr;
}

sub invert_ip {
    my $input_str = shift;
    my $result    = test_string_structure($input_str);
    my %responses = (
        ip    => sub { ip_to_num($input_str) },
        num   => sub { num_to_ip($input_str) },
        err   => sub { 'Illegal string. Please use IPv4 strings or numbers.' },
        empty => sub { 'Empty string. Please use IPv4 strings or numbers.'   },
    );
    # This is a dispatch table, instead of a big ugly if block / switch

    if ( exists $responses{$result} ) {
        return $responses{$result}->();
    }

    # If none of the above was executed
    die 'Could not convert IP string / number due to unknown error';
}

1;

__END__

=head1 NAME

Net::IPAddress::Minimal - IP string to number and back

=head1 VERSION

Version 0.03

=head1 SYNOPSIS

This module converts IPv4 strings to integer IP numbers and vice versa.

It's built to be used as quickly and easily as possible, which is why you can
just simply use the C<invert_ip> function.

It recognizes whether you have an IPv4 string or a number and converts it to the
other form.

Here's a sample script:

    use Net::IPAddress::Minimal ('invert_ip');

    my $input_string = shift @ARGV;
    my $output       = invert_ip( $input_string );

    print "$output\n";

=head1 EXPORT

Three functions can be exported:

=over 4

=item * invert_ip 

=item * num_to_ip

=item * ip_to_num

=back

=head1 SUBROUTINES/METHODS

=head2 invert_ip

Gets an IPv4 string or an IP number and converts it to the other form.

    my $ip_num = invert_ip( '10.200.10.130' );
    #  $ip_str = 180882050
    
    my $ip_num = invert_ip( 180882050 );
    #  $ip_str = '10.200.10.130';
    
=head2 num_to_ip

Gets an IP number and returns an IPv4 string.

    my $ip_num = num_to_ip( 3232235778 );
    #  $ip_str = '192.168.1.2';

=head2 ip_to_num

Gets a IPv4 string and returns the matching IP number.

B<Note that at the moment this function does not ensure that each of the
class numbers are between 0-255, and it can return unexpected results
when misused>

    my $ip_num = ip_to_num( '212.212.212.212' );
    #  $ip_num = 3570717908

=head2 test_string_structure

Checks the structure of the input string and returns flags indicating whether
it's an IPv4 string, and IP number or something else (which is an error).

=head1 AUTHORS

Tamir Lousky, C<< <tlousky at cpan.org>  >>

SawyerX, C<< <xsawyerx at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-net-ipaddress-minimal at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Net-IPAddress-Minimal>.  I will
be notified, and then you'll automatically be notified of progress on your bug
as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Net::IPAddress::Minimal

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Net-IPAddress-Minimal>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Net-IPAddress-Minimal>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Net-IPAddress-Minimal>

=item * Search CPAN

L<http://search.cpan.org/dist/Net-IPAddress-Minimal/>

=back

=head1 ACKNOWLEDGEMENTS

=head1 LICENSE AND COPYRIGHT

Copyright 2010 Tamir Lousky.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

