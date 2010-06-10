package Net::IPAddress::Minimal;

our $VERSION = '0.1';

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

    $ip_classes = shift;

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

    if ( $result eq 'ip' ) {

        return ip_to_num( $ip_classes );

    } elsif ( $result eq 'num' ) {

        return num_to_ip( $input_str );

    } elsif ( $result eq 'err' ) {

        return 'Illegal String. Please only use use IPv4 strings or IP numbers'; 

    } elsif ( $result eq 'empty' ) {

        return 'Empty String. Retry with an IPv4 string or an IP number';

    } else {

        die( 'Could not convert IP string / number due to unknown error' );

    }
}