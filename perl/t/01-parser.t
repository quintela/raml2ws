#!/usr/bin/env perl

use 5.20.2;
use FindBin qw($Bin);
use lib "$Bin/../lib";

use RAML::Parser;

my $parser = RAML::Parser->new( "$Bin/data/base.raml" );

say STDERR "hello Sir...";
use Data::Dumper;
#print STDERR Dumper $parser->resources;
print STDERR Dumper $parser;
say STDERR "\ngoodbye Sir...";

