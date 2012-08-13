use strict;
use warnings;
use Test::More;

use FindBin qw/ $Bin /;
use lib "$Bin/lib";

use_ok 'FooNoOptions';

::ok FooNoOptions->new;

{
    my $i = FooNoOptions->new_with_options( foo => 12 );
    is $i->foo, 12;
}

done_testing;

