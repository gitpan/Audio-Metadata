use strict;
use warnings;

use Test::More tests => 5;
use Test::Deep;
use File::Copy ();

use Audio::Metadata;


# Derive path to test FLAC file from the path to this test script.
my $orig_test_file_name = $0;
$orig_test_file_name =~ s/[^\/]+$/test-original.flac/;

# Make a copy of sample file to avoid damaging it during testing.
my $test_file_name = 'test.' . ($orig_test_file_name =~ /\.([^.]+)$/)[0];
File::Copy::copy($orig_test_file_name, $test_file_name)
    or die "Could not copy \"$orig_test_file_name\" to \"$test_file_name\": $!";

# Instanciate Audio::Metadata using copy of sample file.
ok(my $audio_file = Audio::Metadata->new_from_path($test_file_name), 'Test file read');

# Test that medadata is read correctly.
my %test_metadata = (
    artist => 'test artist',
    album  => 'test album',
    year   => '1980',
);
is_deeply($audio_file->vars_as_hash, \%test_metadata, 'Metadata read');

# Test that medadata is written correctly w/o added padding.
my %updated_metadata = (
    artist => 'updated artist',
    album  => 'updated album',
    year   => '1996',
);
$audio_file->set_var($_ => $updated_metadata{$_}) foreach keys %updated_metadata;
$audio_file->save;
$audio_file = Audio::Metadata->new_from_path($test_file_name);
is_deeply($audio_file->vars_as_hash, \%updated_metadata, 'Metadata updated');

# Same w/added padding.
my $long_comment = 'a' x 50000;
$audio_file->set_var(long_comment => $long_comment);
$audio_file->save;
$audio_file = Audio::Metadata->new_from_path($test_file_name);
is_deeply($audio_file->vars_as_hash, { %updated_metadata, long_comment => $long_comment }, 'Metadata updated w/added padding');

# Test text representation.
my $correct_text = <<EOT;
@{[ $audio_file->file_path ]}
album $updated_metadata{album}
artist $updated_metadata{artist}
long_comment $long_comment
year 1996
EOT
is($audio_file->as_text, $correct_text, 'Get text representation');

# Remove sample file copy.
unlink $test_file_name;
