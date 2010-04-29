#!/usr/bin/env ruby

###
# Student Name: Pavel Snagovsky
# Homework Week: 3
#

###
# Chat Server tests
# 

$: << 'lib'
require "test/unit"
require "rubygems"
require "mocha"

require "chat/chat_server"

class TestChatServer < Test::Unit::TestCase
  
  def test_server_start
    # the server will start here.
    # assert ChatServer.new
  end
  
  def test_expecting_client_connections
    # assert_respond_to 
  end
end