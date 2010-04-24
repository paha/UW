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
    @tcp_server = mock()
    TCPServer.stubs( :new ).returns( @tcp_server )

    YAML.expects( :load_file ).
      with( 'passwd' ).
      returns( KNOWN_CREDS )

    @server = Server.new
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
    user = KNOWN_CREDS.keys.first
    salt = @server.generate_salt

    actual = @server.calculate_auth_string( salt, user )
    expected = @server.hash( salt, KNOWN_CREDS.values.first )

    assert_equal expected, actual
  end

  def test_can_generate_salt
    actual = @server.generate_salt
    assert_kind_of String, actual
    assert_equal 32, actual.length
  end

  def test_can_check_credentials
    username = KNOWN_CREDS.keys.first
    salt = @server.generate_salt
    auth_string = @server.calculate_auth_string( salt, username )

    assert @server.authenticate?(
      username,
      salt,
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
    tcp_server = mock( 'tcp server' )
    tcp_server.stubs( :accept ).returns( false )
    TCPServer.expects( :new ).with( 24842 ).returns( tcp_server )
    @server.start
  end

  def test_can_start_server_on_alternate_port
    TCPServer.expects( :new ).with( 1111 ).returns( @tcp_server )
    @server.start( 1111 )
  end


  def test_can_converse
    session = mock( 'session' )
    @tcp_server.expects( :accept ).returns( session )

    @server.start

    to_say  = "hello"
    to_hear = "wassup"

    session.expects( :puts ).with( to_say )
    session.expects( :gets ).returns( to_hear )

    assert_equal to_hear, @server.converse( to_say )
  end

  def test_converse_can_just_listen
    session = mock( 'session' )
    session.expects( :gets ).returns( "foo" )
    @tcp_server.expects( :accept ).returns( session )

    @server.start
    assert_equal "foo", @server.converse
  end

  def test_full_transaction
    session = mock( 'session' )
    @tcp_server.expects( :accept ).returns( session )

    @server.start

      # 1) get the username
      # 2) send the salt
      # 3) get auth string
      # 4) check the auth string
      # 5) return results
  end
end