require "./spec_helper"

describe IRCd::Server do
  it "lets you register a new user" do
    server = IRCd::Server.new "test.example.org"
    server.introduce_user IRCd::User.new("test", "test", "test", "test", nil)
  end

  it "makes the user accessible" do
    server = IRCd::Server.new "test.example.org"
    user = IRCd::User.new("test", "test", "test", "test", nil)
    server.introduce_user user
    server.user("test").should eq(user)
  end

  it "does not care about case when accessing user" do
    server = IRCd::Server.new "test.example.org"
    user = IRCd::User.new("test", "test", "test", "test", nil)
    server.introduce_user user
    server.user("TEST").should eq(user)
  end

  pending "makes channels accessible as targets" do
    fail "Not implemented"
  end
  pending "makes users accessible as targets" do
    fail "Not implemented"
  end

end
