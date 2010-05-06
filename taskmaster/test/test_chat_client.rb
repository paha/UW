#!/usr/bin/env ruby

###
# Student: Pavel Snagovsky
# Homework Week: 5
#

###
# Chat Client tests
# 

$: << 'lib'
require "test/unit"
require "rubygems"
require "mocha"

require "chat/chat_client"

class TestChatClient < Test::Unit::TestCase

  def setup
    @session = stubs( :puts, :gets )  
    TCPSocket.expects( :new ).returns( @session )

    @chat_client = ChatClient.new( "localhost", 12345 )
  end

end
