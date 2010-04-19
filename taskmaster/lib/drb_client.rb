#!/usr/bin/env ruby

###
# Student Name: Pavel Snagovsky 
# Homework Week: 3
#
##### 
# DRb client 
# 
require 'drb'

tm = DRbObject.new( nil, 'druby://localhost:1234' )

tm.cookbook do

  task :sandwich, :meat, :bread do
    puts "making a sammich!"
  end

  task :meat, :clean do
    puts "preparing the meat"
  end
  
  task :bread, :clean do
    puts "preparing the bread"
  end
  
  task :clean, :mop, :handwash do
    puts "cleaning"
  end
  
  task :handwash do
    puts "washing hands"
  end
  
  task :mop do
    puts "mopping!"
  end
  
end

tm.run_list_for( :meat )
