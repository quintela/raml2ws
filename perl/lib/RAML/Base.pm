package RAML::Base;

=head1 NAME

RAML::Base

=head1 SYNOPSIS

=head1 VERSION
  
  0.10

=head1 DESCRIPTION

=head1 INTERFACE
=cut

sub new {
  bless {
    __raw__ => {
     __title__      => $_[1]->{title},
     __version__    => $_[1]->{version},
     __base_uri__   => $_[1]->{baseUri},
     __media_type__ => $_[1]->{mediaType},
     __protocols__  => $_[1]->{protocols},
     __routes__     => __find_route_nodes( $_[1] )
    }
  }, $_[0];
}

=head1 PVT ACESSORS

=head2 __find_route_nodes

=cut
sub __find_route_nodes {
  my $base    = $_[0];
  my $accum   = $_[1] // '';
  my $routes;

  foreach ( keys %$base ){
    
    if ( __isa_route( $_ ) ) {
      
      my @methods_of = grep { __isa_method( $_ ) } keys %{ $base->{$_} };

      $routes->{ $accum . $_ }{methods} = \@methods_of;

      $routes->{ $accum . $_ }{routes} = __find_route_nodes( 
        $base->{$_}, $accum . $_ 
      ) unless scalar @methods_of;

      # Merge resulting flattened recursion
      $routes = { 
        %$routes, 
        %{__find_route_nodes( $base->{$_},$accum . $_  ) || {} } 
      };
    }



  }

  return $routes;
}

=head2 __isa_route

=cut 
sub __isa_route { $_[0] =~ m{^/} ? 1 : 0; }


=head2 __isa_method

=cut
sub __isa_method { lc($_[0]) =~ /^head|get|put|patch|delete|post$/ }

=head1 PUBLIC METHODS

=head2 title
=cut
sub title { $_[0]->{__raw__}{__title__} }
=head2 version
=cut
sub version { $_[0]->{__raw__}{__version__} }
=head2 base_uri
=cut
sub base_uri { $_[0]->{__raw__}{__base_uri__} }
=head2 media_type
=cut
sub media_type { $_[0]->{__raw__}{__media_type__} }
=head2 resources
=cut
#sub resources { $_[0]->{__raw__}{__resources__} }
=head2 protocols
=cut
sub protocols { $_[0]->{__raw__}{__protocols__} }

=head2 routes
=cut
sub routes { $_[0]->{__raw__}{__routes__} }

1;

__END__

=head1 AUTHOR

Tiago Quintela, <quintela[at]....pt>

=head1 COPYRIGHT AND LICENSE

Copyright 2015 by Tiago Quintela

This library is free software; you can redistribute it and/or modify it 
under the same terms as Perl itself.