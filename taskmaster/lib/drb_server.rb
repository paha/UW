#!/usr/bin/env ruby

###
# Student Name: Pavel Snagovsky 
# Homework Week: 3
#

# DRb server test

$: << 'lib'
require 'drb'
require 'taskmaster'

DRb.start_service( 'druby://:1234', Taskmaster )
puts "Started DRb server: #{DRb.uri}"
DRb.thread.join
