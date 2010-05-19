#!/usr/bin/env ruby

###
# Student Name: Pavel Snagovsky 
# Homework Week: 3
#
###
# Description:
#
# Creating DSL
#

require 'taskmaster'

class Task<Taskmaster
  attr_accessor :deps, :action

  def initialize( deps, &block )
    @deps = deps
    @action = block
  end

  # generating a run_list, it will contain all dependencies in order, even tasks that would need to be skipped  
  def make_list( name )
    @deps.each do |t|
      raise "ERROR: Undefined task #{t}" unless Taskmaster.tasks[t]
      Taskmaster.tasks[t].make_list(t)
    end
    c = Taskmaster.completed_tasks
    Taskmaster.instance_variable_set( :@completed_tasks, c.push(name) )
  end

  # executing the task with dependencies, iterating over not purified list to catch tasks to skip
  def make( name )
    c = Taskmaster.completed_tasks
    Taskmaster.run_list[name].each do |t|
      if c.include?(t)
        puts "** skipping completed task #{t}"
      else
        puts "\t** executing dependency #{t} of #{name}" unless t == name
        Taskmaster.tasks[t].action.call
        Taskmaster.instance_variable_set(:@completed_tasks, c.push(t))
      end
    end
  end

end
