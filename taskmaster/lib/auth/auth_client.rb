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

# Authentication client class
class AuthClient
  
  def initialize( host, port )
    begin
      @session = TCPSocket.new( host, port )
    rescue
      puts "Failed to connect to #{host}:#{port}"
      exit 1
    end
  end
  
  def get_salt( user )
    @session.puts user
    return @session.gets.chomp
  end
  
  def verify_salt( salt )
    # Auth server will return NOT AUTHORIZED, if it wasn't able to verify the user
    # salt also should be 32 chars
    if salt == "NOT AUTHORIZED" or salt.length != 32
      # puts "FAILED. Recived invalid salt"
      puts salt
      return 'failed'
    end
  end
  
  def send_salty_passwd( passwd, salt )
    passwd_hash = Digest::MD5.hexdigest( salt + passwd )
    @session.puts passwd_hash
    return @session.gets.chomp
  end
  
end
