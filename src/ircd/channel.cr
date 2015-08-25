require "./message_sink"
require "./user"

module IRCd
  class Channel
    include MessageSink

    @users = [] of User

    def initialize(name: String)
      raise ArgumentError.new("Invalid channel name") if name.count(" ") > 0 || !name.starts_with? '#'
      @name = name
    end

    def receive_message(msg: Message)
      @users.receive_through(self, message)
    end
  end
end
