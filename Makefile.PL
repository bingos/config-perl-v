#!/usr/bin/perl

# Copyright PROCURA B.V. (c) 2009-2010 H.Merijn Brand

use strict;

use ExtUtils::MakeMaker;

my %wm = (
    NAME	  =>   "Config-Perl-V",
    AUTHOR        =>   "H.Merijn Brand <h.m.brand\@xs4all.nl>",
    VERSION_FROM  =>   "V.pm",
    ABSTRACT_FROM =>   "V.pm",

    PREREQ_PM	  => { "Config"			=> 0,
		       "Test::More"		=> 0,
		       "Test::NoWarnings"	=> 0,
		       },
    );
$ExtUtils::MakeMaker::VERSION > 6.30 and $wm{LICENSE} = "perl";

my $rv = WriteMakefile (%wm);

1;

package MY;

sub postamble
{
    join "\n" =>
	'cover test_cover:',
	'	ccache -C',
	'	cover -test',
	'',
	'spellcheck:',
	'	pod-spell-check --aspell',
	'',
	'checkmeta:	spellcheck',
	'	perl sandbox/genMETA.pl -c',
	'',
	'fixmeta:	distmeta',
	'	perl sandbox/genMETA.pl',
	'	ls -l */META.yml',
	'',
	'tgzdist:	checkmeta fixmeta $(DISTVNAME).tar.gz distcheck',
	'	-@mv -f $(DISTVNAME).tar.gz $(DISTVNAME).tgz',
	'	-@cpants_lint.pl $(DISTVNAME).tgz',
	'	-@rm -f Debian_CPANTS.txt',
	'';
    } # postamble

1;
