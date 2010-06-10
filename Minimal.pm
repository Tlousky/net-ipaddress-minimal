package Net::IPAddress::Minimal;
use Moose;

our $VERSION = '0.1';

has 'input_string'  => ( is => 'ro', isa => 'Str' );

sub test_string_structure {
    my $self   = shift;
    my $string = $self->input_string;

    if ( $string =~ /(\d+)(\.\d+){3}/ ) {
        # If this is an IP, return the ip flag and seperated IP classes
        return 'ip', $1, $2, $3, $4;
    } elsif ( $string =~ /^(\d+)$/ ) {
        return 'num';
    } else {
        # If this is not an IP or a number, flag that it's an illegal string
        return 'err';
    }
}

sub ip_to_num {
# Converting between IP to number is according to this formula:
# IP = A.B.C.D
# IP Number = A x (256**3) + B x (256**2) + C x 256 + D

    my ( $self, $ip_classes ) = @_;

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
    my $self  = shift;
    my $ipnum = $self->input_string;
   
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
    my $self = shift;
    my $input_str = $self->input_string;
    
    my ( $results, $ip_classes ) = test_string_structure( $input_str );
    
    if ( $result eq 'ip' ) {

        return $self->ip_to_num( $ip_classes );

    } elsif ( $result eq 'num' ) {

        return $self->num_to_ip();

    } elsif ( $result eq 'err' ) {

        return 'Illegal String. Please only use use IPv4 strings or IP numbers'; 

    } else {

        die( 'Could not convert string / number due to unknown error' );

    }
}