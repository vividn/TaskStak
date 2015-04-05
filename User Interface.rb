require_relative 'task'


#top_level_list = Task.new("Top Level") TODO: uncomment to actually have top_level
# current_list = top_level_list
current_list = Task.new("Top Level")

while true
  system "clear" or system "cls"
  print current_list

  input = gets() #TODO add input string

  # If command starts with a number, it is referring to that spot in the list
  # '0' adds new task at top of list
  # '0/4' adds new task above subtask 4 in task 0
  # '0/' opens task 0
  # '-2' adds new item above 2nd from last task in list
  if input.match /^(-?\d+)((?:\/-?\d+)*)(\/?) *(.*)$/

    # Current level item selection
    item_num = $1.to_i


    # Subtask selection [optional], removes first '/'
    subtask_str = $2[1..-1] || ""
    subtask_lineage = subtask_str.split '/'

    # Detection of ending slash in task number for open command rather than add
    ending_slash = $3.eql? '/'

    # The command to pass to the item
    command_str = $4

    target_list = current_list
    item = target_list[item_num]

    # If sublists are specified, 'navigate' to them
    subtask_lineage.each do |task_index|
      task_index = task_index.to_i
      target_list = item
      item_num = task_index
      item = target_list[item_num]
    end

    case command_str

      when /^ *$/
        # No command text
        # If there is no ending slash, add mode
        # Ending slash, open the list
        if ending_slash
          current_list = item
        else
          target_list.add_subtask(item_num)
        end

      when /^a *(.*)$/
        # 'a [text]'
        # Adds optional text as a new task above selected spot
        # if no text is given, continuous input is entered until a blank line is given
        if $1.empty?
          target_list.add_subtask(item_num)
        else
          current_list.insert_subtask(item_num,$1)
        end
    end




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

