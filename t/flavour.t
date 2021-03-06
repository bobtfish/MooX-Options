#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Trap;
use Carp;
use FindBin qw/$RealBin/;
use Try::Tiny;

BEGIN {
    use Module::Load::Conditional qw/check_install/;
    plan skip_all => 'Need Moo for this test'
        unless check_install( module => 'Moo' );
}

{

    package plain;
    use Moo;
    use MooX::Options protect_argv => 0;

    option 'bool' => ( is => 'ro' );

    1;
}
{

    package plain2;
    use Moo;
    use MooX::Options protect_argv => 0, flavour => undef;

    option 'bool' => ( is => 'ro' );

    1;
}

{

    package FlavourTest;
    use Moo;
    use MooX::Options flavour => [qw(pass_through)], protect_argv => 0;

    option 'bool' => ( is => 'ro' );

    1;
}

for my $noflavour(qw/plain plain2/) {
    subtest "unknown option $noflavour" => sub {
        note "Without flavour $noflavour";
        {
            local @ARGV = ('anarg');
            my $plain = $noflavour->new_with_options();
            is_deeply( [@ARGV], ['anarg'], "anarg is left" );
        }
        {
            local @ARGV = ( '--bool', 'anarg' );
            my $plain = $noflavour->new_with_options();
            is( $plain->bool, 1, "bool was set" );
            is_deeply( [@ARGV], ['anarg'], "anarg is left" );
        }
        {
            local @ARGV = ( '--bool', 'anarg', '--unknown_option' );
            my @r = trap { $noflavour->new_with_options() };
            like( $trap->die, qr/USAGE:/, "died with usage message" );
            like(
                $trap->warn(0),
                qr/Unknown option: unknown_option/,
                "and a warning from GLD"
            );
        }
    };
}

subtest "flavour" => sub {
    note "With flavour";
    {
        local @ARGV = ('anarg');
        my $flavour_test = FlavourTest->new_with_options();
        is_deeply( [@ARGV], ['anarg'], "anarg is left" );
    }
    {
        local @ARGV = ( '--bool', 'anarg' );
        my $flavour_test = FlavourTest->new_with_options();
        is( $flavour_test->bool, 1, "bool was set" );
        is_deeply( [@ARGV], ['anarg'], "anarg is left" );
    }
    {
        local @ARGV = ( '--bool', 'anarg', '--unknown_option' );
        my $flavour_test = FlavourTest->new_with_options();
        is( $flavour_test->bool, 1, "bool was set" );
        is_deeply(
            [@ARGV],
            [ 'anarg', '--unknown_option' ],
            "anarg and unknown_option are left"
        );
    }
};

done_testing;
