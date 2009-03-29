#!/pro/bin/perl

use strict;
use warnings;

use Test::More tests => 8;
use Test::NoWarnings;

BEGIN {
    use_ok ("Config::Perl::V");
    }

ok (my $conf = Config::Perl::V::myconfig,	"Read config");
for (qw( build environment config inc )) {
    ok (exists $conf->{build},			"Has build entry");
    }
is ($conf->{build}{osname}, $conf->{config}{osname}, "osname");
