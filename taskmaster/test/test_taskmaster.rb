#!/usr/bin/env ruby

###
# Student Name: Pavel Snagovsky
# Homework Week: 3
#

$: << 'lib'
require "test/unit"
require "taskmaster"

class TestTaskmaster < Test::Unit::TestCase
  
  # define a simple cookbook
  def setup
    Taskmaster.cookbook do
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
  end
  
  # 
  def test_cookbook_method
    expected = "chef is good"
    actual = Taskmaster.cookbook { puts "chef is good"}
    assert_equal(expected, actual)
  end
  
  def test_task_created
    assert Taskmaster.tasks[:test_task]
  end

  def test_task_object_method
    object = Taskmaster.tasks[:test_task]
    assert_respond_to(object, :make)
  end
  
  def test_task_dependancies
    expected = [ :d1, :d2 ]
    actual = Taskmaster.tasks[:test_task].deps
    assert_equal(expected, actual)
  end
  
  def test_completed_tasks
    Taskmaster.run(:test_task)
    expected = [:d2, :d1, :test_task]
    actual = Taskmaster.completed_tasks
    assert_equal(expected, actual)
  end
  
  def test_run_method   
    assert_nothing_thrown { Taskmaster.run(:d1) }
  end
  
  def test_task_object
    expected = Taskmaster::Task
    actual = Taskmaster.tasks[:d1]
    assert_kind_of(expected, actual)
  end
  
  def test_undefined_task
   out = assert_raise(RuntimeError) do
      Taskmaster.cookbook do
        task :test_task2, :bad_dep do
           puts "test_task2"
         end
       end 
    end
    assert_match( /ERROR: Undefined task bad_dep/, out.message)
  end
  
  def test_run_list
    expected = [:d2, :d1, :d2, :test_task]
    actual = Taskmaster.run_list[:test_task]
    assert_equal(expected, actual)
  end
  
  def test_run_list_for
    expected = [:d2, :d1, :test_task]
    actual = Taskmaster.run_list_for(:test_task)
    assert_equal(expected, actual)
  end
  
  def test_skip_task
    full_list = Taskmaster.run_list[:test_task]
    actual_list = Taskmaster.run_list_for(:test_task)
    assert_equal( false, full_list == actual_list )
  end
  
  def test_run_method_raise
    exception = assert_raise( RuntimeError ){ Taskmaster.run(:fake) }
    assert_match ( /Undefined task fake/, exception.message)
  end
  
end
