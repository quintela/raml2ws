#!/usr/bin/env perl

use FindBin qw($Bin);
use lib "$Bin/../lib";

use RAML::Parser;

my $parser = RAML::Parser->new( file => "$Bin/data/base.raml" );

say STDERR "hello Sir...";
use Data::Dumper;
print STDERR Dumper $parser->{__raml};
say STDERR "\ngoodbye Sir...";

