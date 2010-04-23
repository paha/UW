#!/usr/bin/env ruby

###
# Student Name: Pavel Snagovsky
# Homework Week: 3
#

$: << 'lib'
require "test/unit"
require "rubygems"
require "mocha"
require "auth/server2"
# require "auth/auth_client"

class TestAuthServer < Test::Unit::TestCase
 
  # CREDENTIALS = { :bob => 'pa$$wd' }
  
  def setup
    @as = AuthServer
    @session = stub( :puts => true, :close => true )
    @as.username = 'bob' 
  end
  
  def test_verify_making_salt
    assert @as.send_salt( @session )
    assert_equal( 32, @as.salt.length )
  end
  
  def test_get_username_unknown_user
    @session.expects( :gets ).returns( "fakeUser" )
    @session.expects( :peeraddr ).returns( [1, 2, 'localhost'] )
    actual = @as.get_username( @session )
    assert_equal( false, actual )
  end
  
  def test_recieved_valid_username
    @session.expects( :gets ).returns( "bob" )
    actual = @as.get_username( @session )
    assert_equal( 'bob', actual )    
  end
  
  def test_recieving_salty_passwd_of_wrong_length
     @session.expects( :gets ).returns( "fake_salt" )
     actual = @as.get_salty_passwd( @session )
     assert_not_equal( 32, @as.passwd_salty.length )
     assert_equal( false, actual )
  end
  
  def test_recieving_valid_salty_passwd
    
  end
  
  def test_authentication
    # make salt, username is 'bob'
    @as.send_salt( @session )
    
  end
  
end