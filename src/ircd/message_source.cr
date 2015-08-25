require "fast-irc"

module IRCd
  module MessageSource
    abstract def to_prefix: FastIrc::Prefix
  end
end
