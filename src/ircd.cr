require "./ircd/*"

module IRCd
  Server.new("irc.test.org").debug_listen
end
