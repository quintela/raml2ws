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
    }
  }, $_[0];
}


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
1;

__END__

=head1 AUTHOR

Tiago Quintela, <quintela[at]....pt>

=head1 COPYRIGHT AND LICENSE

Copyright 2015 by Tiago Quintela

This library is free software; you can redistribute it and/or modify it 
under the same terms as Perl itself.