###
# Student: Pavel Snagovsky
# Homework Week: 3
#

require "test/unit"
require "rubygems"
require "mocha"
require "auth/client"

class TestAuthClient < Test::Unit::TestCase
  
  def setup
    @session = stubs( :puts )   
    AuthClient.any_instance.stubs( :authenticate )
    TCPSocket.expects( :new ).returns( @session )

    @cl = AuthClient.new( 'user', 'passwd', false )
  end
  
  def test_verify_salt
    salt = Digest::MD5.hexdigest( "str" )
    
    actual = @cl.verify_salt?( salt )
    assert_not_equal( 'failed', actual )
  end
  
end
