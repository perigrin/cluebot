package Cluebot;
use Moses;
our $VERSION = '0.0.1';

server 'irc.freenode.net';
nickname 'cluebot';
channels '#catalyst';

# you can set message via the command line with --message [msg]
has message => (
    isa     => 'Str',
    is      => 'rw',
    default => q[This channel is an empty redirect]
      . q[ - you need to connect to irc.perl.org #catalyst]
      . q[ - if you're using mibbit you can do this by selecting 'other']
      . q[ and then typing irc.perl.org into the text box],
);

event irc_join => sub {
    my ( $self, $nickstr, $channel ) = @_[ OBJECT, ARG0, ARG1 ];
    my ($nick) = split /!/, $nickstr;
    $self->privmsg( $channel => "$nick: ${ \$self->message }" )
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
