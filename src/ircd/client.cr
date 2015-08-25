require "fast-irc"

module IRCd
  class Client
    @errored = false
    @user = nil
    @nick = nil
    @auth = nil
    @name = "*"
    @authenticated = false
    def initialize(@socket, @server)
      spawn do
        puts "Reading socket..."
        while msg = @socket.gets
          begin
            puts "MSG: #{msg}"
            parsed_msg = FastIrc::Message.parse(msg.chomp)
            puts parsed_msg.inspect
            handle_command(parsed_msg)
          rescue e
            puts e
            puts e.backtrace.join("\n")
          end
        end
      end
    end

    def send(message: FastIrc::Message)
      message.to_s(@socket)
      @socket.write("\n")
      @socket.flush
    end

    def send(sender: MessageSource?, command: String|Int, params: Array(String))
      FastIrc::Message.new(sender.try &.to_prefix, command.to_s, params)
    end

    def send(sender: MessageSource?, command: String|Int, *params: String)
      send(sender, command, params.to_a)
    end

    def send(sender: MessageSource?, command: String|Int)
      send(sender, command, [] of String)
    end

    def error
      unless @errored
        send nil, "ERROR", "Internal Server Error"
      end
      begin
        @socket.close
      rescue
      end
    end

    private def ensure_auth(value, &block)
      if @authenticated == value
        block.call
      elsif value
        send @server, 451, "*", "You have not registered"
      else
        send @server, 462, "*", "You may not reregister"
      end
    end

    private def handle_command(msg: FastIrc::Message)
      params = msg.params.not_nil!
      case msg.command.upcase
      when "PING"
        ensure_params 1 do
          send @server, "PONG", @server.name, params.first
        end
      when "PRIVMSG"
        ensure_auth true do
          ensure_params 2 do
            target = @server.target(params[0])
            if target
              target.can_receive_from? @user.not_nil!
              target.receive_from @user.not_nil!, IRCd::Message.new(target, params[1])
            else
              send @server, 401, "No such nick/channel"
            end
          end
        end
      when "NICK"
        if @authenticated
          # TODO: Nick change
        else
          ensure_params 1 do
            @nick = params[0]
            check_auth
          end
        end
      when "USER"
        ensure_auth false do
          ensure_params 4 do
            @auth = {params[0], params[3]}
            check_auth
          end
        end
      else
        puts "Unknown command: #{msg.inspect}"
      end
    end

    private def check_auth
      @server.user_mutex.lock do
        if (nick = @nick) && @server.user(nick)
          send @server, 433, "*", nick, "Nickname already in use"
          @nick = nil
          return
        end
        if @auth && @nick
          auth, nick = @auth.not_nil!, @nick.not_nil!
          user = User.new(nick, auth[0], @socket.peeraddr.ip_address, auth[1], self)
          @name = nick
          @authenticated = true
          @server.introduce_user user
          send @server, "001", @name, "Welcome to this in crystal written IRC server"
          send @server, 422, @name, "This server does not yet support MOTDs"
        end
      end
    end

    private macro ensure_params(num)
      if params.length < {{ num }}
        send @server, 461, @name, msg.command, "Not enough parameters"
      else
        {{ yield }}
      end
    end
  end
end
