###
# Student Name: Pavel Snagovsky
# Homework Week: 3
#

###
# Authentication Server tests
# 

require "test/unit"
require "rubygems"
require "mocha"
# require 'test/zentest_assertions'
require "auth/server"

class TestAuthServer < Test::Unit::TestCase
 
  DATA = { 'bob' => 'pa$$wd' }
  PORT = 12345
  
  # Testing all the methods except for the authentication sequence
  def setup
    # mocking session, will be overwriten in other tests as needed
    @session = stub( 'session_setup',
      :puts => "send", 
      :gets => "receive", 
      :close => "closed" )
    
    YAML.stubs( :load_file ).returns( DATA )
    TCPServer.stubs( :new ).returns( @server )   
    
    # bypass authentication sequence
    AuthServer.any_instance.stubs( :auth_sequence ).
      with( PORT, DATA, @server )
    
    @as = AuthServer.new( PORT, false )
  end
  
  def test_verify_making_salt  
    assert salt = @as.send_salt( @session, DATA.keys.first )
    assert_equal( 32, salt.length )
  end
  
  def test_salt_uniqness
    salt1 = @as.send_salt( @session, DATA.keys.first )
    salt2 = @as.send_salt( @session, DATA.keys.first )
    assert_not_equal( salt1, salt2 )
  end
  
  def test_get_username_unknown_user
   @session.expects( :gets ).returns( "fakeUser" )
   @session.expects( :peeraddr ).returns( [1, 2, 'localhost'] )
   actual = @as.get_username( @session, DATA )
   assert_equal( false, actual )
  end

  def test_recieved_valid_username
   user = DATA.keys.first
   @session.expects( :gets ).returns( user )
   actual = @as.get_username( @session, DATA )
   assert_equal( user, actual )    
  end

  def test_recieving_salty_passwd_of_wrong_length
    @session.expects( :gets ).returns( "fake_salt" )
    actual = @as.get_salty_passwd( @session )
    assert_equal( false, actual )
  end

  def test_recieving_valid_salty_passwd
    some_md5 = Digest::MD5.hexdigest( 'dodo' )
    @session.expects( :gets ).returns( some_md5 )
    actual = @as.get_salty_passwd( @session )
    assert_equal( some_md5, actual )
  end
 
end
