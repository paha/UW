#!/usr/bin/env ruby

###
# Student Name: Pavel Snagovsky
# Homework Week: 3
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
  def test_client_can_connect
    #ChatClient.new
  end
end