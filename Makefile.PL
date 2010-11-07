
use strict;
use warnings;



use ExtUtils::MakeMaker 6.31;



my %WriteMakefileArgs = (
  'ABSTRACT' => 'Manipulate metadata in audio files',
  'AUTHOR' => 'Egor Shipovalov <kogdaugodno@gmail.com>',
  'BUILD_REQUIRES' => {
    'Cwd' => '0',
    'File::Basename' => '0',
    'File::Copy' => '0',
    'File::Spec' => '0',
    'Test::Deep' => '0',
    'Test::More' => '0'
  },
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.31'
  },
  'DISTNAME' => 'Audio-Metadata',
  'EXE_FILES' => [],
  'LICENSE' => 'perl',
  'NAME' => 'Audio::Metadata',
  'PREREQ_PM' => {
    'Any::Moose' => '0',
    'IO::File' => '0',
    'List::Util' => '0',
    'Module::Find' => '0',
    'Path::Class' => '0',
    'autodie' => '0'
  },
  'VERSION' => '0.12',
  'test' => {
    'TESTS' => 't/*.t'
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



