#!/pro/bin/perl

use strict;
use warnings;

BEGIN {
  use Test::More;
  my $tests = 8;
  unless ( $ENV{PERL_CORE} ) {
    require Test::NoWarnings;
    Test::NoWarnings->import();
    $tests++;
  }
  plan tests => $tests;
}

use Config::Perl::V;

ok (my $conf = Config::Perl::V::plv2hash (<DATA>), "Read perl -v block");
for (qw( build environment config inc )) {
    ok (exists $conf->{build},			"Has build entry");
    }
is ($conf->{build}{osname}, $conf->{config}{osname}, "osname");
is ($conf->{build}{stamp}, 0, "No build time known");
is ($conf->{config}{version}, "5.10.0", "reconstructed \%Config{version}");

__END__
Summary of my perl5 (revision 5 version 10 subversion 0) configuration:
  Platform:
    osname=linux, osvers=2.6.22.13-0.3-default, archname=i686-linux-64int
    uname='linux nb09 2.6.22.13-0.3-default #1 smp 20071119 15:02:58 utc i686 i686 i386 gnulinux '
    config_args='-Duse64bitint -des'
    hint=recommended, useposix=true, d_sigaction=define
    useithreads=undef, usemultiplicity=undef
    useperlio=define, d_sfio=undef, uselargefiles=define, usesocks=undef
    use64bitint=define, use64bitall=undef, uselongdouble=undef
    usemymalloc=n, bincompat5005=undef
  Compiler:
    cc='cc', ccflags ='-fno-strict-aliasing -pipe -I/pro/local/include -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64',
    optimize='-O2 -g',
    cppflags='-fno-strict-aliasing -pipe -I/pro/local/include'
    ccversion='', gccversion='4.2.1 (SUSE Linux)', gccosandvers=''
    intsize=4, longsize=4, ptrsize=4, doublesize=8, byteorder=12345678
    d_longlong=define, longlongsize=8, d_longdbl=define, longdblsize=12
    ivtype='long long', ivsize=8, nvtype='double', nvsize=8, Off_t='off_t', lseeksize=8
    alignbytes=4, prototype=define
  Linker and Libraries:
    ld='cc', ldflags ='-L/pro/local/lib'
    libpth=/pro/local/lib /lib /usr/lib /usr/local/lib
    libs=-lnsl -lgdbm -ldb -ldl -lm -lcrypt -lutil -lc
    perllibs=-lnsl -ldl -lm -lcrypt -lutil -lc
    libc=/lib/libc-2.6.1.so, so=so, useshrplib=false, libperl=libperl.a
    gnulibc_version='2.6.1'
  Dynamic Linking:
    dlsrc=dl_dlopen.xs, dlext=so, d_dlsymun=undef, ccdlflags='-Wl,-E'
    cccdlflags='-fPIC', lddlflags='-shared -O2 -L/pro/local/lib'
