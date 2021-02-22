package Morrisonc::Devel::Utils::Memwatch;
# -------------------- execution
use warnings FATAL => 'all';
use strict;
use warnings;
use utf8;
use 5.010;

# -------------------- core modules
use Scalar::Util qw( refaddr );

# -------------------- logging
use Log::Log4perl;
# Configuration in a string ...
my $conf = q(
  log4perl.logger.memwatch                  = INFO, LogAppender
  log4perl.appender.LogAppender             = Log::Log4perl::Appender::File
  log4perl.appender.LogAppender.filename    = memwatch.log
  log4perl.appender.LogAppender.layout      = Log::Log4perl::Layout::PatternLayout
  log4perl.appender.LogAppender.layout.ConversionPattern
                                            = [%r] %F %L %m%n
);
# ... passed as a reference to init()
Log::Log4perl::init( \$conf );

sub print_log {
    my $log_message = shift;
    my $perl_logger = Log::Log4perl->get_logger(q{memwatch});
    my $fhem_logger = main->can(q{Log3});

    main::Log3(q{memwatch}, 1, $log_message) if $fhem_logger;
    $perl_logger->info($log_message) if $perl_logger;
}

# -------------------- main

sub new {
    my ($type, $id) = @_;

    my $class = ref $type || $type;
    my $self = {};
    bless $self, $class;
    $self->{id} = $id || 0;
    print_log(sprintf ("memory object %s %s installed", refaddr($self), $self->{id}));
    return $self;
};

sub DESTROY {
    my ($self) = @_;
    print_log(sprintf ("memory object %s %s removed", refaddr($self), $self->{id}));
};



1;


