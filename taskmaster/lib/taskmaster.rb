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
    # tasks attribute is a hash with a task name as a key and Task class object as a value
    # run_list is hash with a task name as a key and not purified, ordered list of tasks to execute
    # completed_tasks is an tmp array of tasks
    attr_accessor :tasks, :run_list, :completed_tasks
    
    # After evaluation of the cookbook, when all task class objects are created, generating run_lists
    def cookbook( &block )
      raise "Cookbook accepts a block" unless block
      @tasks = {}
      @run_list = {}
      cook = instance_eval( &block )
      generate_run_lists
      # For testing.
      return cook
    end
    
    # generating run_list for each task
    def generate_run_lists
      @tasks.each do |name, obj|
        @completed_tasks = []
        obj.make_list(name)
        @run_list[name] = @completed_tasks
      end
    end
    
    # task method makes task objects.
    def task( name, *deps, &block )
      @tasks[name] = Taskmaster::Task.new( deps, &block )
    end
    
    # execution of a task(s), resetting completed_tasks array each time
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
      # run_list attribute has all tasks, we need to remove duplicates
      return @run_list[name].uniq
    end
    
    class Taskmaster::Task
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
    
  end
end
