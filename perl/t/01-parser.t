#!/usr/bin/env perl

use 5.20.2;
use FindBin qw($Bin);
use lib "$Bin/../lib";

use RAML qw(decode_raml);
use Test::More;
use Test::Deep;

use_ok('RAML');

my $raml         = decode_raml "$Bin/data/base.raml";
my $blessed_raml = RAML->new(file => "$Bin/data/base.raml");

cmp_deeply( (bless { raml => $raml },'RAML'), $blessed_raml, "raml ok!");

done_testing();
