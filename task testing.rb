require_relative 'task'
a = Task.new('Do the dishes')
a.add_subtask()

puts a
a.collapse
puts a


