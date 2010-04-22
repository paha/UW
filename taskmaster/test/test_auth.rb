#!/usr/bin/env ruby

###
# Student Name: Pavel Snagovsky
# Homework Week: 3
#

$: << 'lib'
require "test/unit"
require "rubygems"
require "mocha"
require "auth/auth_server"
require "auth/auth_client"

class TestAuthServer < Test::Unit::TestCase
 
  def test_client_verify_salt
    session = stub('mysession')
    AuthServer.username = 'bob'
    session.expects(:puts).returns(true)
    assert AuthServer.make_salt(session)
    assert_equal(32, AuthServer.salt.length )
  end
  
end

class TestAuthClient < Test::Unit::TestCase
  before( :each ) do 
    @socket = mock( "socket" ) 
    TCPSocket.stub!( :new ).and_return( @socket ) 
  end
  
end

