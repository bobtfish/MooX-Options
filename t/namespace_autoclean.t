use strict;
use warnings;
use Test::More;

BEGIN {
    plan skip_all => "Do not have namespace::autoclean or Sub::Name installed"
        unless eval { require namespace::autoclean; require Sub::Name; 1; };
}

{
    package Foo;
    use Moo;
    use MooX::Options;
    use namespace::autoclean;

    ::ok !__PACKAGE__->can('option');
    ::ok __PACKAGE__->can('new_with_options');
}

done_testing;

