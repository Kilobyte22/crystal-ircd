require "./spec_helper"

describe IRCd::Channel do
  it "checks if name starts with a hash symbol" do
    expect_raises ArgumentError, "Invalid channel name" do
      IRCd::Channel.new "test"
    end
  end

  it "fails on empty name" do
    expect_raises ArgumentError, "Invalid channel name" do
      IRCd::Channel.new ""
    end
  end

  it "fails with spaces in name" do
    expect_raises ArgumentError, "Invalid channel name" do
      IRCd::Channel.new "#test name"
    end
  end
end
