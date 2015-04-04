require_relative 'task'


#top_level_list = Task.new("Top Level") TODO: uncomment to actually have top_level
# current_list = top_level_list
current_list = Task.new("Top Level")

while true
  system "clear" or system "cls"
  print current_list

  input = gets() #TODO add input string

  # If command starts with a number, it is referring to that spot in the list
  # '0' adds new item at top of list
  # '0/4' adds new subtask above item 4 in task 0
  # '0/' opens task 0
  # '-2' adds new item above 2nd from last task in list
  if input.match /^(-?\d+)((?:\/-?\d+)*)(\/?) *(.*)$/

    # Top level selection
    item_num = $1

    # Subtask selection [optional], removes first '/'
    subtask_str = $2[1..-1]

    # Detection of ending slash in task number for open command rather than add
    ending_slash = $3 == '/'

    # The command to pass to the item
    command_str = $4




    # puts "item num: #{item_num}, subtask_str: #{subtask_str}, ending_slash: #{ending_slash}, command_str: #{command_str}"

  end

  case input

    when /^a?([\d]*)$/
      # Adds entries at a specified point in the list until a line feed is given
      if $1.empty?
        current_list.add_subtask
      else
        current_list.add_subtask($1.to_i)
      end

    when /^o([0-9]+)$/
      current_list = current_list.subtasks[$1.to_i]

    when /^p$/
      current_list = current_list.parent_task

    when /^c?([\d]*)$/
      #Collapses a given list
      if $1.empty?
        current_list.toggle_collapse
      else
        current_list.subtasks[$1.to_i].toggle_collapse
      end

    else
      p "Command not recognized."

  end


end