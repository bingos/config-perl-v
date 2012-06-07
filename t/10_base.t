#!/pro/bin/perl

use strict;
use warnings;

BEGIN {
  use Test::More;
  my $tests = 7;
  unless ( $ENV{PERL_CORE} ) {
    require Test::NoWarnings;
    Test::NoWarnings->import();
    $tests++;
  }

  plan tests => $tests;

  use_ok ("Config::Perl::V");
}

ok (my $conf = Config::Perl::V::myconfig,	"Read config");
for (qw( build environment config inc )) {
    ok (exists $conf->{build},			"Has build entry");
    }
is (lc $conf->{build}{osname}, lc $conf->{config}{osname}, "osname");
