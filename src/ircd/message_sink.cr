module IRCd
  module MessageSink
    abstract def receive_message(msg: Message)
    abstract def name: String
    abstract def can_receive_from?(source: MessageSource): Bool
  end
end
