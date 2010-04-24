#!/usr/bin/env ruby

###
# Student Name: Pavel Snagovsky
# Homework Week: 3
#

###
# Authentication Server tests
# 

$: << 'lib'
require "test/unit"
require "rubygems"
require "mocha"
require "auth/server2"

class TestAuthServer < Test::Unit::TestCase
 
  DATA = { 'bob' => 'pa$$wd' }
  
  def setup
    # 
    @session = stub( :puts => "send", :gets => "receive", :close => "bye" )   
    @server = stub( :accept => @session )
    YAML.expects( :load_file ).returns( DATA )
    TCPServer.expects( :new ).returns( @server )
    
    AuthServer.any_instance.stubs( :auth_sequence ).with( 24842, DATA, @server ).returns( "not executed")
    
    @as = AuthServer.new
  end
  
  def test_verify_making_salt
    # @session.expects( :peeraddr ).returns( [1, 2, 'localhost'] )
    
    assert salt = @as.send_salt( @session, DATA.keys.first )
    assert_equal( 32, salt.length )
  end
  
#  def setup 
#    # mocking connection
#    @con = stub( :puts => true, :close => true )
#    YAML.expects( :load_file ).returns( DATA )
#    # @server = mock()
#    @server = stub( :accept => @con )
#    # @server.stubs()
#    TCPServer.stubs( :new ).with( 24842 ).returns( @server )
#    # skipping the server accept connection loop, the methods will be tested separately
#    # Kernel.expects( :loop )
#    @as = AuthServer.new
#    @as.username = DATA.keys.first   
#  end
#  
#  def test_verify_making_salt
#    assert salt = @as.send_salt( @con, DATA )
#    assert_equal( 32, salt.length )
#  end
#  
#  def test_get_username_unknown_user
#    @con.expects( :gets ).returns( "fakeUser" )
#    @con.expects( :peeraddr ).returns( [1, 2, 'localhost'] )
#    actual = @as.get_username( @con, DATA )
#    assert_equal( false, actual )
#  end
#  
#  def test_recieved_valid_username
#    @con.expects( :gets ).returns( "bob" )
#    actual = @as.get_username( @con )
#    assert_equal( 'bob', actual )    
#  end
#  
#  def test_recieving_salty_passwd_of_wrong_length
#     @con.expects( :gets ).returns( "fake_salt" )
#     actual = @as.get_salty_passwd( @con )
#     assert_not_equal( 32, @as.passwd_salty.length )
#     assert_equal( false, actual )
#  end
#  
#  def test_recieving_valid_salty_passwd
#    
#  end
#  
#  def test_authentication
#    # make salt, username is 'bob'
#    @as.send_salt( @con )
#    
#  end
  
end
