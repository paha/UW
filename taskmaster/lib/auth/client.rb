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

require File.dirname(__FILE__) + '/auth_client'

unless ARGV.length == 2
  puts "Expecting username and password."
  exit 1
end 

user = ARGV[0]
passwd = ARGV[1]

host, port = 'localhost', 24842
# establish a connection to Auth server
auth = AuthClient.new(host, port)
puts "--- Successfully connected to auth server. #{Time.now}"

# Getting salt from the auth server
puts "--- Sending username \"#{user}\""
salt = auth.get_salt( user )
exit 1 if auth.verify_salt( salt ) == 'failed'
puts "--- Recieved \"salt\" from the server. Cooking..."

puts "--- Sending encrypted passwd"
result = auth.send_salty_passwd( passwd, salt )
puts "#{result}"

