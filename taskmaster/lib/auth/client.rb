#!/usr/bin/env ruby

###
# Student Name: Pavel Snagovsky 
# Homework Week: 3
#
###
# Description:
#
# Creating DSL
# Authentication client
# 

require 'socket'
require 'digest/md5'

user = ARGV[0]
passwd = ARGV[1]

class AuthClient
  
  HOST = 'localhost'
  PORT = 24842
  
  attr_reader :user, :passwd
  
  def initialize
    begin
      @session = TCPSocket.new( HOST, PORT )
    rescue
      puts "Failed to connect to #{host}:#{port}"
    end
  end
  
  def get_salt( user )
    @session.puts user
    return @session.gets.chomp
  end
  
  def send_salty_passwd( passwd, salt )
    passwd_hash = Digest::MD5.hexdigest( salt + passwd )
    @session.puts passwd_hash
    return @session.gets.chomp
  end
  
end

begin
  session = TCPSocket.new( 'localhost', 24842 )
  session.puts user
  puts "--- Successfully connected to auth server and sent username. #{Time.now}"
  salt = session.gets.chomp
  puts "--- Recieved \"salt\" from the server. Cooking..."
  passwd_hash = Digest::MD5.hexdigest( salt + passwd )
  session.puts passwd_hash
  puts "--- Authentication response: #{session.gets.chomp}"
rescue
  puts "FAILED. Server closed connection. #{Time.now}"
end