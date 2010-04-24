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

require File.dirname(__FILE__) + '/auth_client_class'

unless ARGV.length == 2
  puts "Expecting username and password."
  exit 1
end 

user = ARGV[0]
passwd = ARGV[1]

AuthClient.new( user, passwd )