require "fast-irc"

require "./message_source"

module IRCd
  class User
    include MessageSink
    include MessageSource

    getter nick, user, host, realname

    def initialize(@nick, @user, @host, @realname, @connection)

    end

    def can_receive_from?(src)
      true
    end

    def name
      @nick
    end

    def receive_message(msg)
      # TODO: Possibly abstract this?
      @connection.send msg.sender, "PRIVMSG", @nick, msg.content
    end

    def to_prefix
      FastIrc::Prefix.new(@nick, @user, @host)
    end
  end
end
