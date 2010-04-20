#!/usr/bin/env ruby

###
# Student Name: Pavel Snagovsky 
# Homework Week: 3
#
###
# Description:
#
# Creating DSL
# Authentication server
# 

require 'yaml'
require 'socket'
require 'digest/md5'

port = 24842
auth_data = YAML::load( File.read('passwd') )

auth_server = TCPServer.new( port )

loop do
  puts "\nReady to accept new connections. Listening on port: #{port}. #{Time.now}"
  session = auth_server.accept
  puts "--- #{session.peeraddr[2]} connected. #{Time.now}"
  username = session.gets.chomp
  puts "--- Received \"#{username}\" for username. #{Time.now}"
  unless auth_data[username] 
    puts "FAILED. Unknown username provided. Closing session with #{session.peeraddr[2]} #{Time.now}"
    session.puts "Unknown user \"#{username}\""
    session.close
    next
  end
  salt = Digest::MD5.hexdigest( username + Time.now.strftime('%M%S') + rand(300).to_s )
  session.puts salt
  passwd_salty = session.gets.chomp
  puts "--- Received salty password. #{Time.now}"
  if passwd_salty == Digest::MD5.hexdigest( salt + auth_data[username] )
    session.puts "Successfully authenticated \"#{username}\""
    puts "--- \"#{username}\" successfully authenticated. Closing session. #{Time.now}"
  else
    session.puts "Failed. Password mismatch."
    puts "FAILED. password mismatch. Closing session. #{Time.now}"
  end
  session.close
end