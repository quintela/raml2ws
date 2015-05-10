#!/usr/bin/env perl

use 5.20.2;
use FindBin qw($Bin);
use lib "$Bin/../lib";

use RAML::Parser qw(decode_raml);
use Test::More;

#use_ok('RAML::Parser');
#my $ws = RAML::Parser->new( "$Bin/data/base.raml" );

#is(ref($ws), 'RAML::Parser', 'blessed struct correctly');
say STDERR "doing for '$Bin/data/base.raml'";
my $raml = decode_raml "$Bin/data/base.raml";
use Data::Dumper; print STDERR Dumper $raml;

done_testing();
