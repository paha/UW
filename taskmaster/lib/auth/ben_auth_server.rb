#!/usr/bin/env ruby

require 'digest/md5'
require 'socket'

class Server
  def initialize
    @creds = YAML.load_file( 'passwd' )
  end

  # checks the credentials provided for +user+
  def authenticate?( user, salt, auth )
    return auth == calculate_auth_string( salt, user )
  end

  # given a string, returns its MD5
  def hash( *strs )
    return Digest::MD5.hexdigest( strs.join )
  end

  # calculate the auth string, which is
  # hash( salt + passwd )
  def calculate_auth_string( salt, user )
    return hash( salt, @creds[user] )
  end

  # creates a unique string
  def generate_salt
    return hash(
      Time.now.to_s,
      rand(999_999_999).to_s,
      Time.now.usec
    )
  end

  # starts a server on the given +port+
  def start( port = 24842 )
    server = TCPServer.new( port )

    while @session = server.accept
      # event loop
      #
      # 1) get the username
      # 2) send the salt
      # 3) get auth string
      # 4) check the auth string
      # 5) return results
    end

  end

  # sends an optional +msg+ to the client
  # and then reads a response
  def converse( msg = nil )
    @session.puts msg if msg
    return @session.gets
  end

end