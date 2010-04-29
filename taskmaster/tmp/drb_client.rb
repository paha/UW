#!/usr/bin/env ruby

###
# Student Name: Pavel Snagovsky 
# Homework Week: 3
#

# DRb client test 
# 
require 'drb'

DRb.start_service

tm = DRbObject.new_with_uri( 'druby://localhost:1234' )

tm.cookbook do
    task :test_task, :d1, :d2 do 
      puts "not real test_task"
    end
    task :d1, :d2 do 
      puts "dep one"
    end
    task :d2 do 
      puts "dep two"
    end
end
