module IRCd
  class Message

    getter sender, content, timestamp

    def initialize(@sender: User, @content: String, @timestamp = Time.now: Time)
    end
  end
end
