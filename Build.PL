use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name        => 'Net::IPAddress::Minimal',
    license            => 'perl',
    dist_author        => q{Tamir Lousky <tlousky@cpan.org>},
    dist_version_from  => 'lib/Net/IPAddress/Minimal.pm',
    build_requires     => {
        'Test::More'      => 0,
        'Test::Exception' => 0,
    },
    requires           => { Exporter => 0 },
    add_to_cleanup     => [ 'Net-IPAddress-Minimal-*' ],
    create_makefile_pl => 'traditional',
    create_readme      => 1,
    create_license     => 1,
);

$builder->create_build_script();
