use strict;
use warnings;

use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Audio::Metadata',
    license             => 'perl',
    dist_author         => q{Egor Shipovalov <kogdaugodno@gmail.com>},
    dist_version_from   => 'lib/Audio/Metadata.pm',
    build_requires => {
        'Test::More' => 0,
        'Test::Deep' => 0,
        'File::Copy' => 0,
    },
    requires => {
        'autodie'     => 1,
        'Any::Moose'  => 0,
        'Path::Class' => 0,
    },
    add_to_cleanup      => [ 'Audio-Metadata-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
