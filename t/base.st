

my @params = qw/bool counter empty/;
subtest "no args" => sub {
	note "no args";
	@ARGV=();
	my $t = t->new_with_options();
	ok($t->can($_), "$_ defined") for @params;
	is($t->$_, undef, "$_ values is undef") for @params;
};

subtest "args value" => sub {
    note "args value with repeatable";
    @ARGV=('--bool','--counter','--counter','--counter', '--empty');
    my $t = t->new_with_options();
    ok($t->$_, "$_ values is defined") for @params;
    is($t->bool,1,"bool is well defined");
    is($t->counter, 3,"counter is well defined");
    is($t->empty, 1, "empty is well defined");
};

subtest "negativable" => sub {
	note "negativable";
    @ARGV=('--empty', '--no-empty');
    my $t = t->new_with_options();
    is($t->empty, 0, "empty is well defined");
};

subtest "split" => sub {
	note "split";

	{
	    @ARGV=('--split=1');
	    my $t = t->new_with_options();
	    is_deeply($t->split, [1], "split one arg");
	}
    {
        @ARGV=('--split=1', '--split=2');
        my $t = t->new_with_options();
        is_deeply($t->split, [1,2], "split two arg");
    }
    {
        @ARGV=('--split=1,2');
        my $t = t->new_with_options();
        is_deeply($t->split, [1,2], "split one arg autosplit");
    }
    {
        @ARGV=('--split=1','--split=2','--split=3,4');
        my $t = t->new_with_options();
        is_deeply($t->split, [1,2,3,4], "split three arg with autosplit");
    }
};

subtest "test required" => sub {
	note "test required";
	
	{
		@ARGV=();
		my @r = trap {r->new_with_options};
		is($trap->exit, 1, "missing args, exit 1");
		ok($trap->stdout =~ /^str_req is missing/, "str_reg is missing");
	}
	{
		@ARGV=('--str_req=ok');
        my $t = r->new_with_options;
        is($t->str_req, 'ok','str req is ok');
	}
};

subtest "test help" => sub {
	note "test help";
    {
        @ARGV=('--help');
        my @r = trap {r->new_with_options};
        is($trap->exit, 0, "help, exit 0");
        ok($trap->stdout !~ /^str_req is missing/, "str_reg is missing");
    }
};

subtest "value override" => sub {
    note "value override";
	{
		@ARGV=();
		my $t = r->new_with_options(str_req => "ok");
        is($t->str_req, 'ok','str req is ok');
	}
	{
		@ARGV=('--str_req=ko');
        my $t = r->new_with_options(str_req => "ok");
        is($t->str_req, 'ok','str req is override with ok');
	}
};
