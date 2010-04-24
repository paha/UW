#!/usr/bin/env ruby

###
# Student Name: Pavel Snagovsky 
# Homework Week: 3
#
###
# Description:
#
# Creating DSL
# Authentication server class
# 

require 'yaml'
require 'socket'
require 'digest/md5'

# Authentication server class
class AuthServer
  # Authentication sequence executed initializing the class
  def initialize( port = 24842, debug = true )
    @debug = debug
    data = YAML.load_file( File.dirname(__FILE__) + '/passwd' )    
    auth_server = TCPServer.new( port )
    auth_sequence( port, data, auth_server )
  end
  
  # Authentication sequence with debug messages, error mesgs will come from corresponding methods
  def auth_sequence( port, data, auth_server )
    while true
      debug_msg "\nReady to accept new connections. Listening on port: #{port}. #{Time.now}"
      session = auth_server.accept
      debug_msg "--- #{session.peeraddr[2]} connected. #{Time.now}"
      user = get_username( session, data )
      next if user == false
      debug_msg "--- Received \"#{user}\" for username. #{Time.now}"
      salt = send_salt( session, user )
      debug_msg "--- Sent salt to the client. #{Time.now}"
      passwd_salty = get_salty_passwd( session )
      debug_msg "--- Received salty password from the client. #{Time.now}"
      authenticate?( session, salt, passwd_salty, user, data )
    end
  end
  
  # output debug messages to stdout, unless debug isn't 'true'. Wasn't sure if other loging method was expected.
  def debug_msg( str )
    if @debug == true
      puts str
    end
  end
  
  # Getting username, and verifying it against our data
  def get_username( session, data )
    username = session.gets.chomp
    unless data[username]
      debug_msg "NOT AUTHORIZED. Unknown username \"#{username}\". Closing session with #{session.peeraddr[2]} #{Time.now}"
      session.puts "NOT AUTHORIZED"
      session.close
      return false
    end
    return username
  end
  
  # Generating salt and sending it to the client
  def send_salt( session, user )
    salt = Digest::MD5.hexdigest( user + Time.now.strftime('%M%S') + rand(300).to_s )
    session.puts salt
    return salt
  end
  
  # Receiving and verifying salt
  def get_salty_passwd ( session )
    passwd_salty = session.gets.chomp
    if passwd_salty.length != 32
      session.puts "NOT AUTHORIZED"
      session.close
      debug_msg "NOT AUTHORIZED. Unexpected salty passwd hash. #{Time.now}"
      return false
    end
    return passwd_salty
  end
  
  # Authentication
  def authenticate?( session, salt, passwd_salty, user, data )
    if passwd_salty == Digest::MD5.hexdigest( salt + data[user] )
      session.puts "AUTHORIZED"
      debug_msg "AUTHORIZED \"#{user}\". Closing session. #{Time.now}"
      result = true
    else
      session.puts "NOT AUTHORIZED"
      debug_msg "NOT AUTHORIZED \"#{user}\". password mismatch. Closing session. #{Time.now}"
      result = false
    end
    session.close
    return result
  end

end

# AuthServer.new()