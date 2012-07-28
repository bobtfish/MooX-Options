package MooX::Options::Role;

# ABSTRACT: role that is apply to your object
use strict;
use warnings;
use feature 'state';
# VERSION

=head1 TODO

Write a doc

=cut

use MRO::Compat;
use Moo::Role;

use Carp;
use Data::Dumper;

sub new_with_options {
  my $class = shift;
  $class->new($class->parse_options(@_));
}

sub parse_options {
  my %option_info = shift->option_information;
  carp Dumper \%option_info;
  return;
}

sub option_information {
  shift->maybe::next::method(@_);
}

sub option {
    my ($option_information, $name, %attributes) = @_;
    has $name => %attributes;
    $option_information->{$name} = { %attributes };
    return;
}
1;
