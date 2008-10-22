package Cluebot;
use Moses;

our $VERSION = '0.0.1';

use MooseX::AttributeHelpers;

server 'irc.freenode.net';
nickname 'cluebot';
channels '#catalyst';

# you can set message via the command line with --message [msg]
has message => (
    isa => 'Str',
    is  => 'rw',
    default =>
      'This channel left intentionally empty. Go to #catalyst on irc.perl.org',
);

event irc_join => sub {
    my ( $self, $nickstr, $channel ) = @_[ OBJECT, ARG0, ARG1 ];
    $self->privmsg( $channel => $self->message )
      unless $nickstr =~ /^mst/;
};

event irc_bot_addressed => sub {
    my ( $self, $nickstr, $channel, $msg ) = @_[ OBJECT, ARG0, ARG1, ARG2 ];
    return unless $nickstr =~ /^mst|^perigrin/;
    return unless $msg     =~ /^say\s+(.*)$/;
    $self->message($1);
};

__PACKAGE__->run unless caller;

no Moses;
1;
__END__
