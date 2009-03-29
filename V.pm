#!/pro/bin/perl

package Config::Perl::V;

use strict;
use warnings;

our $VERSION = "0.01";

use Config;

#  Characteristics of this binary (from libperl):
#    Compile-time options: DEBUGGING PERL_DONT_CREATE_GVSV PERL_MALLOC_WRAP
#                          USE_64_BIT_INT USE_LARGE_FILES USE_PERLIO

# The list are as the perl binary has stored it in PL_bincompat_options
#  search for it in
#   perl.c line 1768 (first  block)
#   perl.h line 4454 (second block),
my %BTD = map { $_ => 0 } qw(

    DEBUGGING
    NO_MATHOMS
    PERL_DONT_CREATE_GVSV
    PERL_MALLOC_WRAP
    PERL_MEM_LOG
    PERL_MEM_LOG_ENV
    PERL_MEM_LOG_ENV_FD
    PERL_MEM_LOG_STDERR
    PERL_MEM_LOG_TIMESTAMP
    PERL_USE_DEVEL
    PERL_USE_SAFE_PUTENV
    USE_FAST_STDIO
    USE_SITECUSTOMIZE

    DEBUG_LEAKING_SCALARS
    DEBUG_LEAKING_SCALARS_FORK_DUMP
    DECCRTL_SOCKETS
    FAKE_THREADS
    MULTIPLICITY
    MYMALLOC
    PERL_DEBUG_READONLY_OPS
    PERL_GLOBAL_STRUCT
    PERL_IMPLICIT_CONTEXT
    PERL_IMPLICIT_SYS
    PERL_MAD
    PERL_NEED_APPCTX
    PERL_NEED_TIMESBASE
    PERL_OLD_COPY_ON_WRITE
    PERL_POISON
    PERL_TRACK_MEMPOOL
    PERL_USES_PL_PIDSTATUS
    PL_OP_SLAB_ALLOC
    THREADS_HAVE_PIDS
    USE_64_BIT_ALL
    USE_64_BIT_INT
    USE_IEEE
    USE_ITHREADS
    USE_LARGE_FILES
    USE_LONG_DOUBLE
    USE_PERLIO
    USE_REENTRANT_API
    USE_SFIO
    USE_SOCKS
    VMS_DO_SOCKETS
    VMS_SYMBOL_CASE_AS_IS
    );

# These are all the keys that are
# 1. Always present in %Config (first block)
# 2. Reported by 'perl -V' (the rest)
my @config_vars = qw(

    archlibexp
    dont_use_nlink
    d_readlink
    d_symlink
    exe_ext
    inc_version_list
    ldlibpthname
    path_sep
    privlibexp
    scriptdir
    sitearchexp
    sitelibexp
    usevendorprefix
    version

    package revision version_patchlevel_string

    osname osvers archname
    myuname
    config_args
    hint useposix d_sigaction
    useithreads usemultiplicity
    useperlio d_sfio uselargefiles usesocks
    use64bitint use64bitall uselongdouble
    usemymalloc bincompat5005

    cc ccflags
    optimize
    cppflags
    ccversion gccversion gccosandvers
    intsize longsize ptrsize doublesize byteorder
    d_longlong longlongsize d_longdbl longdblsize
    ivtype ivsize nvtype nvsize lseektype lseeksize
    alignbytes prototype

    ld ldflags
    libpth
    libs
    perllibs
    libc so useshrplib libperl
    gnulibc_version

    dlsrc dlext d_dlsymun ccdlflags
    cccdlflags lddlflags
    );

sub myconfig
{
    my $args = shift;
    my %args = ref $args eq "HASH"  ? %  $args  :
               ref $args eq "ARRAY" ? %{@$args} : ();

    #y $pv = qx[$^X -e"sub Config::myconfig{};" -V];
    my $pv = qx[$^X -V];
       $pv =~ s{.*?\n\n}{}s;
       $pv =~ s{\n(?:  \s+|\t\s*)}{ }g;

    #print $pv;

    my $build = {
	osname  => "",
	stamp   => "",
	options => \%BTD,
	patches => [],
	};
    $pv =~ m{^\s+Built under (.*)}m                and $build->{osname} = $1;
    $pv =~ m{^\s+Compiled at (.*)}m                and $build->{stamp}  = $1;
    $pv =~ m{^\s+Locally applied patches:\s+(.*)}m and $build->{patches} = [ split m/\s+/, $1 ];
    $pv =~ m{^\s+Compile-time options:\s+(.*)}m    and map { $build->{options}{$_} = 1 } split m/\s+/, $1;

    my @KEYS = keys %ENV;
    my %env  =
	map   { $_    => $ENV{$_} } grep m/^PERL/ => @ENV;
    $args{db} || $args{pg} || $args{postgres} and
	map { $env{$_} = $ENV{$_} } grep m{^PG}        => @KEYS;
    $args{db} || $args{oracle} and
	map { $env{$_} = $ENV{$_} } grep m{^ORACLE}    => @KEYS;
    $args{db} || $args{mysql}  and
	map { $env{$_} = $ENV{$_} } grep m{^M[yY]SQL}  => @KEYS;
    $args{env} and
	map { $env{$_} = $ENV{$_} } grep m{$args{env}} => @KEYS;

    my %config = map { $_ => $Config{$_} } @config_vars;

    return {
	build		=> $build,
	environment	=> \%env,
	config		=> \%config,
	inc		=> \@INC,
	};
    } # myconfig

1;

__END__

=head1 NAME

Config::Perl::V - Structured data retreival of perl -V output

=head1 SYNOPSIS

use Config::Perl::V;

my $local_config = Config::Perl::V::myconfig ();
print $local_config->{config}{osname};

=head1 DESCRIPTION

=head2 myconfig ()

Currently the only function. Documentation will follow.

=head1 REASONING

This module was written to be able to return the configuration for the
currently used perl as deeply as needed for the CPANTESTERS framework.
Up until now they used the output of myconfig as a single text blob,
and so it was missing the vital binary characteristics of the running
perl and the optional applied patches.

=head1 BUGS

Please feedback what is wrong

=head1 TODO

* Implement retreival functions/methods
* Document what is done and why
* Include the perl -V parse block from Andreas

=head1 AUTHOR

H.Merijn Brand <h.m.brand@xs4all.nl>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 1999-2009 H.Merijn Brand

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
