use strict;
use warnings;
use English qw( -no_match_vars ) ;
use 5.010;
use Test::More;
use Test::Deep;

# mock main::Log3
sub main::Log3 {
    my ($device, $severity, $message) = @_;
    push @main::log, {
        device   => $device,
        severity => $severity,
        message  => $message,
    };
}

subtest q{Test module loader} => sub {
    use_ok(qw{Morrisonc::Devel::Utils::Memwatch});
    use Morrisonc::Devel::Utils::Memwatch;
};

subtest q{Test Log::Log4perl} => sub {
    my $test_var_name = q{espel};   # hope in sindarin

    use Test::Log::Log4perl;
    my $test_logger = Test::Log::Log4perl->get_logger(q{memwatch});

    Test::Log::Log4perl->start();
    $test_logger->info(qr{memory object \d+ $test_var_name installed});
    Morrisonc::Devel::Utils::Memwatch->new($test_var_name);
    $test_logger->info(qr{memory object \d+ $test_var_name removed});
    Test::Log::Log4perl->end(qq{install/remove var $test_var_name});
};

subtest q{Test Log3} => sub {
    @main::log = ();        # reset log to empty
    my $test_var_name = q{mellon};   # friend in sindarin
    Morrisonc::Devel::Utils::Memwatch->new($test_var_name);
    cmp_deeply(\@main::log,
        [
            {
                message  => re(qr{memory object \d+ $test_var_name installed}),
                severity => 1,
                device   => q{memwatch}
            },
            {
                message  => re(qr{memory object \d+ $test_var_name removed}),
                severity => 1,
                device   => q{memwatch}
            }
        ]
    );
};

done_testing();
