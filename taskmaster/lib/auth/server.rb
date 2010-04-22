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
require File.dirname(__FILE__) + '/auth_server'

port = 24842
data = YAML::load( File.read( File.dirname(__FILE__) + '/passwd' ))

auth_server = TCPServer.new(port)

loop do
  puts "\nReady to accept new connections. Listening on port: #{port}. #{Time.now}"
  session = auth_server.accept
  puts "--- #{session.peeraddr[2]} connected. #{Time.now}"
  username = AuthServer.get_username( session, data )
  next if username == 'failed'
  puts "--- Received \"#{username}\" for username. #{Time.now}"
  AuthServer.make_salt( session )
  puts "--- Sent salt to the client. #{Time.now}"
  AuthServer.get_salty_passwd( session )
  puts "--- Recieved salty password from the client. #{Time.now}"
  AuthServer.check_passwd( session, data )
end
