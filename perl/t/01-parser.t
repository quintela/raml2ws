#!/usr/bin/env perl

use 5.20.1;
use FindBin qw($Bin);
use lib "$Bin/../lib";

use RAML qw(decode_raml);
use Test::More;
use Test::Deep;

use_ok('RAML');

my $raw_raml  = decode_raml "$Bin/data/base.raml";
my $raml      = RAML->new( file => "$Bin/data/base.raml" );

cmp_deeply( $raw_raml , $raml->{__raw__}, "decode_raml ok!");

is( $raml->title, 'My Generator API', 'Title ok!');
is( $raml->version, '3', 'Version ok!');
is( $raml->base_uri, 'http://gen.perl.ws/', 'Base URI ok!');
is( $raml->media_type, "application/json", 'Media Type ok!');

cmp_deeply( $raml->protocols, ['HTTP', 'HTTPS'], 'Protocols ok!');

done_testing();

use Data::Dumper;say STDERR Dumper $raml;
