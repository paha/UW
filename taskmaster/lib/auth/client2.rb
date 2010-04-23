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

user = ARGV[0]
passwd = ARGV[1]
# ***
# AuthClinet.new( user, passwd )

# Authentication client class
class AuthClient
  
  def initialize( user, passwd, host = 'localhost', port = 24842 )
    begin
      @session = TCPSocket.new( host, port )
    rescue
      puts "Failed to connect to #{host}:#{port}"
      exit 1
    end
    puts "--- Successfully connected to auth server. #{Time.now}"  
    authenticate( user, passwd )  
  end
  
  def get_salt( user )
    @session.puts user
    return @session.gets.chomp
  end
  
  def verify_salt( salt )
    # Auth server will return NOT AUTHORIZED, if it wasn't able to verify the user
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
  
  def authenticate( user, passwd )
    puts "--- Sending username \"#{user}\""
    salt = @session.get_salt( user )
    exit 1 if @session.verify_salt( salt ) == 'failed'
    puts "--- Recieved \"salt\" from the server. Cooking..."
    puts "--- Sending encrypted passwd"
    result = @session.send_salty_passwd( passwd, salt )
    puts "#{result}"
  end
  
end
