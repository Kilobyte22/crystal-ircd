require "fast-irc"
require "socket"

module IRCd
  class Server

    include MessageSource

    getter user_mutex, name

    @user_mutex = Fiber::Mutex.new
    @users = {} of String => User

    def initialize(@name: String)

    end

    def target(name: String)
      raise ArgumentError.new "Target name cannot be empty" if name.empty?
      if name[0] == '#'
        # Channel
      else
        user(name)
      end
    end

    def introduce_user(user: User)
      raise ArgumentError.new if @users.has_key? user.nick.downcase
      @users[user.nick.downcase] = user
    end

    def user(nick: String)
      @users[nick.downcase]?
    end

    def to_prefix
      FastIrc::Prefix.new(nil, nil, name)
    end

    def debug_listen
      server = TCPServer.new 5555
      puts "Listening"
      while socket = server.accept
        puts "Incoming connection..."
        client = Client.new(socket, self)
      end
    end
  end
end
