package Net::IPAddress::Minimal;

use strict;
use warnings;

our $VERSION = '0.01';

sub test_string_structure {
    my $string = shift;

    if ( $string =~ /(\d+)(\.\d+){3}/ ) {
        # If this is an IP, return the ip flag and seperated IP classes
        return 'ip', [ $1, $2, $3, $4 ];
    } elsif ( $string =~ /^(\d+)$/ ) {
        return 'num';
    } elsif ( ! $string ) {
        return 'empty';
    } else {
        # If this is not an IP or a number, flag that it's an illegal string
        return 'err';
    }
}

sub ip_to_num {
# Converting between IP to number is according to this formula:
# IP = A.B.C.D
# IP Number = A x (256**3) + B x (256**2) + C x 256 + D

    my $ip_classes = shift;

    my ( $Aclass, $Bclass, $Cclass, $Dclass ) = @$ip_classes;
    
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
   
    my ( $result, $ip_classes ) = test_string_structure( $input_str );
    # $ip_classes will get a value only if an IPv4 string was submitted
    # It is an arrayref containing 4 elements, each with the A-D class number

    my %responses = (
        ip  => sub { ip_to_num($ip_classes) },
        num => sub { num_to_ip($input_str)  },
        err => sub { 'Illegal string. Please use IPv4 strings or numbers' },
    );

    if ( exists $responses{$result} ) {
        return $responses{$result}->();
    }

    die( 'Could not convert IP string / number due to unknown error' );
}

1;

__END__

=head1 NAME

Net::IPAddress::Minimal - The great new Net::IPAddress::Minimal!

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Net::IPAddress::Minimal;

    my $foo = Net::IPAddress::Minimal->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=head2 function1

=head2 function2

=head1 AUTHOR

Tamir Lousky, C<< <tlousky at cpan.org> >>

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

