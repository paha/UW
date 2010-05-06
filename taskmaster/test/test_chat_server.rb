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
require "stringio"
require "rubygems"
require "mocha"

require "chat/chat_server"

class TestChatServer < Test::Unit::TestCase

  PORT = 12345

  def simulate_request( request )
    client = StringIO.new( request )
    @server.serve( client )
    return client.string
    # client.string[request.size - client.size .. -2]
  end
  
  def setup
    @test_user = "user0"
    
    # gserver = mock( 'gserver' )
    # @session = mock( 'session' )
    
    # @clients = { @test_user => @session }
    
    # ChatServer.any_instance.stubs( :super ).with( PORT ).returns( gserver )
    @server = ChatServer.new( PORT )
    # @server.instance_variable_set( :@clients, @clients )
  end
  
  def test_process_msg
    msg = "test message"
    
    @server.process_msg( @test_user, msg )  
  end
  
end
