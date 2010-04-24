#!/usr/bin/env ruby

###
# Student Name: Pavel Snagovsky
# Homework Week: 3
#

$: << 'lib'
require "test/unit"
require "rubygems"
require "mocha"
require "auth/client2"

class TestAuthClient < Test::Unit::TestCase
  
  def setup
    # no TCPSocket.puts by default
    @session = stubs( :puts )
    # authentication happens at initialisation, skipping it by default    
    AuthClient.any_instance.stubs( :authenticate )
    # mocking new socket connection
    TCPSocket.expects( :new ).returns( @session )
    # Initialising the client
    assert @cl = AuthClient.new( 'user', 'passwd' )
  end
  
  def test_verify_salt
    salt = Digest::MD5.hexdigest( "str" )
    actual = @cl.verify_salt( salt )
    assert_not_equal( 'failed', actual )
  end
  
end
