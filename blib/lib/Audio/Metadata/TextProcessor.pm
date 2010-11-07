package Audio::Metadata::TextProcessor;

use strict;
use warnings;

use Audio::Metadata;


sub update_from_text_file {
    ## Updates metadata in files according to text file supplied. File
    ## can be specified as a file handle of file name.
    my $self = shift;
    my %params = @_;

    my $fh = $params{fh};
    unless ($fh) {
        open $fh, '<', $params{file_name}
            or die "Unable to open \"$params{file_name}\" for reading: $!";
    }

    my %curr_item;
    while (my $line = <$fh>) {
        chomp $line;

        my ($var, $value) = $line =~ /^(\S+) *(.*)$/;
        if ($var) {
            $curr_item{$var} = $value;
        }
        else {
            $self->_apply_item(\%curr_item);
            %curr_item = ();
            next;
        }
    }
    $self->_apply_item(\%curr_item) if %curr_item;
}


sub _apply_item {
    ## Saves metadata to file in the given hash.
    my $self = shift;
    my ($item) = @_;

    my $metadata = Audio::Metadata->new_from_path($item->{_file_name});
    my $is_changed;

    foreach my $var (grep /^[^_]/, keys %$item) {
        no warnings 'uninitialized';
        next if $item->{$var} eq $metadata->get_var($var);

        $metadata->set_var($var => $item->{$var});
        $is_changed++;
    }

    $metadata->save if $is_changed;
}


sub file_to_text {
    ## Outputs specified file metadata to standard output.
    my $self = shift;
    my ($file_name) = @_;

    my $metadata = Audio::Metadata->new_from_path($file_name);
    print $metadata->as_text;
}


1;
