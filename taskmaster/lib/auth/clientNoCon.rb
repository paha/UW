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
$: << 'lib'
require 'socket'
require 'auth/auth_client'

unless ARGV.length == 2
  puts "Expecting username and password."
  exit 1
end 

user = ARGV[0]
passwd = ARGV[1]

host, port = 'localhost', 24842
# establish a connection to Auth server
begin
  session = TCPSocket.new( host, port )
rescue
  puts "Failed to connect to #{host}:#{port}"
  exit 1
end
puts "--- Successfully connected to auth server. #{Time.now}"

# Getting salt from the auth server
puts "--- Sending username \"#{user}\""
salt = AuthClient.get_salt( session, user )
exit 1 if AuthClient.verify_salt == 'failed'
puts "--- Recieved \"salt\" from the server. Cooking..."

puts "--- Sending encrypted passwd"
result = AuthClient.send_salty_passwd( session, passwd )
puts result

