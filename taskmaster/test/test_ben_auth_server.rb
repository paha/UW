#!/usr/bin/env ruby

require 'digest/md5'
require 'test/unit'
require 'rubygems'
require 'mocha'

require 'auth/ben_auth_server'

class TestServer < Test::Unit::TestCase

  KNOWN_CREDS = {
    "alice" => "foo!"
  }

  def setup
    @tcp_server = mock( "tcp_server" )
    @session = stub( 'setup_session', 
      :puts => 'send', 
      :gets => 'receive', 
      :close => 'end' )
      
    TCPServer.stubs( :new ).returns( @tcp_server )

    YAML.expects( :load_file ).
      with( 'passwd' ).
      returns( KNOWN_CREDS )

    @server = Server.new
    # testing converse method we just want to have a fake session
    @server.instance_variable_set(:@session, @session)
    
    @user = KNOWN_CREDS.keys.first
    @salt = @server.generate_salt
    @while_loop = sequence( 'while_loop' ) 
  end

  def test_can_read_passwd_file
    server_creds = @server.instance_variable_get( :@creds )
    assert_kind_of Hash, server_creds
    assert_equal KNOWN_CREDS, server_creds
  end

  def test_can_hash_a_string
    expected = Digest::MD5.hexdigest('hi')
    actual   = @server.hash('hi')

    assert_equal expected, actual
  end

  def test_hash_takes_multiple_args
    str1 = "a"
    str2 = "b"
    str3 = "c"

    expected = Digest::MD5.hexdigest(str1 + str2 + str3)
    actual = @server.hash( str1, str2, str3 )

    assert_equal expected, actual
  end

  def test_can_calculate_auth_string

    actual = @server.calculate_auth_string( @salt, @user )
    expected = @server.hash( @salt, KNOWN_CREDS.values.first )

    assert_equal expected, actual
  end

  def test_can_generate_salt
    actual = @server.generate_salt
    
    assert_kind_of String, actual
    assert_equal 32, actual.length
  end

  def test_can_check_credentials
    auth_string = @server.calculate_auth_string( @salt, @user )

    assert @server.authenticate?(
      @user,
      @salt,
      auth_string
    )
  end

  def test_authenticate_with_mocks
    user = "blah" 
    salt = "foo"
    auth = "bees"
    @server.expects(:calculate_auth_string).with( salt, user ).returns( auth )

    assert @server.authenticate?(
      user,
      salt,
      auth
    )
  end

  def test_salts_change_over_time
    first  = @server.generate_salt
    second = @server.generate_salt

    assert_not_equal first, second
  end

  def test_can_start_server      
    @tcp_server.expects( :accept ).returns( @session ).in_sequence( @while_loop )
    @tcp_server.expects( :accept ).returns( false ).in_sequence( @while_loop )
    
    @server.start
  end
  
  def test_can_start_server_on_alternate_port       
    @tcp_server.expects( :accept ).returns( @session ).in_sequence( @while_loop )
    @tcp_server.expects( :accept ).returns( false ).in_sequence( @while_loop )
    
    @server.start( 1111 )
  end
  
  
  def test_can_converse
    to_say  = "hello"
    to_hear = "wassup"
  
    @session.expects( :puts ).with( to_say )
    @session.expects( :gets ).returns( to_hear )
  
    assert_equal to_hear, @server.converse( to_say )
  end
  
  def test_converse_can_just_listen
    @session.expects( :gets ).returns( "foo" )
    
    assert_equal "foo", @server.converse
  end

  def test_full_transaction
    auth = @server.calculate_auth_string( @salt, @user )
    # we have to use our salt for the authentication sequence
    @server.expects( :generate_salt ).returns( @salt )
    
    tcp_server = mock( 'server' )
    session = stub( 'fulltest_session',
      :puts => 'da',
      :close => 'net')
  
    tcp_server.expects( :accept ).returns( session ).in_sequence( @while_loop )
    tcp_server.expects( :accept ).returns( false ).in_sequence( @while_loop )
    
    # We only care about session.gets to test our transaction
    session.expects( :gets ).returns( auth )  
    session.expects( :gets ).returns( @user )  
  
    TCPServer.expects( :new ).returns( tcp_server )
       
    assert_equal "AUTHORIZED", @server.start  
  end
  
end