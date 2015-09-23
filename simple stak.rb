simple_stack = []

while (input = gets.chomp) != "exit"

  next if input.empty?

  if input == "done"
    simple_stack.pop
  else
    simple_stack.push(input)
  end

  system 'cls'
  simple_stack.reverse.each do |task|
    print "· #{task}\n"
  end

end