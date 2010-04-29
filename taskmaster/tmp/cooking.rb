Taskmaster.cookbook do

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

Taskmaster.run :sandwich
