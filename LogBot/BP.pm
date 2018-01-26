package LogBot::BP;

# common/boilerplater code

use 5.010_000;

use strict;
use warnings;

use feature ();

use Carp qw(verbose);
use Data::Dumper;

BEGIN {
    # because we log times as UTC, force all our timezone dates to UTC
    $ENV{TZ} = 'UTC';

    # always die with a stack trace
    $SIG{__DIE__} = sub {
        die @_ if $^S || ref($_[0]);
        if ($_[-1] =~ /\n$/s) {
            my $arg = pop @_;
            $arg =~ s/(.*)( at .*? line .*?\n$)/$1/s;
            push @_, $arg;
        }
        die &Carp::longmess;
    };

    # always sort keys when debugging
    $Data::Dumper::Sortkeys = 1;
}

sub import {
    # utf8
    binmode(STDOUT, ":utf8");
    binmode(STDERR, ":utf8");

    # enable strict, warnings, features
    strict->import();
    warnings->import();
    feature->import( $] > 5.011003 ? ':5.12' : ':5.10' );

    # auto-use app-wide packages
    my $dest_pkg = caller();
    eval "
        package $dest_pkg;
        use LogBot;
        use LogBot::Constants;
        use LogBot::Util;
    ";
    die $@ if $@;
}

1;
