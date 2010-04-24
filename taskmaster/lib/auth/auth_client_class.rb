#!/usr/bin/env ruby

###
# Student Name: Pavel Snagovsky 
# Homework Week: 3
#
###
# Description:
#
# Creating DSL
# Authentication client class
# 

require 'socket'
require 'digest/md5'

# user = ARGV[0]
# passwd = ARGV[1]

# Authentication client class
class AuthClient
  
  HOST = 'localhost'
  PORT = 24842
  
  def initialize( user, passwd, debug = true )
    @debug = debug
    begin
      @con = TCPSocket.new( HOST, PORT )
    rescue
      debug_msg "Failed to connect to #{HOST}:#{PORT}"
      exit 1
    end
    debug_msg "--- Successfully connected to auth server. #{Time.now}"  
    authenticate( user, passwd )  
  end
  
  # output debug messages to stdout, unless debug isn't 'true'. Wasn't sure if messages should go to a file or not.
  def debug_msg( str )
    if @debug == true
      puts str
    end
  end
  
  def get_salt( user )
    @con.puts user
    return @con.gets.chomp
  end
  
  def verify_salt( salt )
    # Auth server will return NOT AUTHORIZED, if it wasn't able to verify the user
    if salt == "NOT AUTHORIZED" or salt.length != 32
      debug_msg salt
      return 'failed'
    end
  end
  
  def send_salty_passwd( passwd, salt )
    passwd_hash = Digest::MD5.hexdigest( salt + passwd )
    @con.puts passwd_hash
    return @con.gets.chomp
  end
  
  def authenticate( user, passwd )
    debug_msg "--- Sending username \"#{user}\""
    salt = get_salt( user )
    exit 1 if verify_salt( salt ) == 'failed'
    debug_msg "--- Recieved \"salt\" from the server. Cooking..."
    debug_msg "--- Sending encrypted passwd"
    result = send_salty_passwd( passwd, salt )
    debug_msg "#{result}"
  end
  
end

# AuthClient.new( user, passwd )
