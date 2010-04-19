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

class Taskmaster
  class << self    
    attr_accessor :tasks, :run_list, :completed_tasks
    
    # Right after evaluation of the cookbook, when all task class objects are created we generate a run_list for each task
    def cookbook( &block ) 
      @tasks = {}
      @run_list = {}
      cook = instance_eval( &block )
      @tasks.each do |name, obj|
        @completed_tasks = []
        obj.make_list(name)
        @run_list[name] = @completed_tasks
      end
      # returning evaluated block passed to the method. For testing.
      return cook
    end
    
    # task method, Task objects created. Expecting name, dependencies and action(block) 
    def task( name, *deps, &block )
      @tasks[name] = Task.new( deps, &block )
    end
    
    # excecution of a task(s), resetting completed_tasks array each time
    def run( *make_me )
      make_me.each do |m|
        raise "Undefined task #{m}" unless @tasks.has_key?(m)
        @completed_tasks = []
        puts "** executing task #{m}"
        @tasks[m].make(m)
        puts "*** done with #{m}"
      end
    end
    
    def run_list_for( name )
      # in order to demonstrate tasks that are skipped when they are a dep of multiple tasks
      # my run_list attribute has all tasks, we need to remove duplicates
      return @run_list[name].uniq
    end
  
  end
end

class Task
  attr_accessor :deps, :action
  
  def initialize( deps, &block )
    @deps = deps
    @action = block
  end
  
  # generating a run_list 
  def make_list( name )
    @deps.each do |t|
      raise "ERROR: Undefined task #{t.to_s}" unless Taskmaster.tasks[t]
      Taskmaster.tasks[t].make_list(t)
    end
    c = Taskmaster.completed_tasks
    Taskmaster.instance_variable_set(:@completed_tasks, c.push(name))
  end
  
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
