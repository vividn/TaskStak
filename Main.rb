require_relative 'task'
#TODO: use ARGV to pass in task file

top_level_task = Task.new("Top Level")
open_task = top_level_task

# Create specialized inbox list
inbox = Task.new("Inbox")
inbox.move(top_level_task)

#TODO: add ability to change default action behavior
default_action_slash = "open"
default_action_no_slash = "add"

while true
  system "clear" or system "cls"
  print open_task

  input = gets() #TODO add input string

  # Input should be in the for (subject)(action)(predicate) text
  # All parts are optional, but look specific
  # Subject, Predicate are in the form x[/y/z/...] where x,y,z are numbers specifying the path to the task of interest
  # action should be a single letter or a command (e.g, 'a', 'add', 'i', 'down')
  parsed_input = /^(?<subject>-?[0-9]+(\/-?[0-9]+)*\/?)?(?<action>[a-zA-Z]+)(?<predicate>-?[0-9]+(\/-?[0-9]+)*\/?)?( (?<text>.+))?$/.match(input)

  #TODO: Do something with bad input

  subject_str = parsed_input["subject"]
  subject_task = subject_str.to_task(open_task)
  subject_end_slash = subject_str[-1].eql?("/")

  action = parsed_input["action"]

  predicate_str = parsed_input["predicate"]
  predicate_task = predicate_str.to_task(open_task)
  predicate_int = predicate_str.to_i
  predicate_end_slash = predicate_str[-1].eql?("/")

  input_text = parsed_input["text"]

  #Shorthand for quick commands. Does default if only subject is provided
  unless action
    action = (subject_end_slash ? default_action_slash : default_action_no_slash)
  end

  # If command starts with a number, it is referring to that spot in the list
  # '0' adds new task at top of list
  # '0/4' adds new task above subtask 4 in task 0
  # '0/' opens task 0
  # '-2' adds new item above 2nd from last task in list

  #TODO: create list of commands

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

    target_list = open_task
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
          open_task = item
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
          open_task.insert_subtask(item_num,$1)
        end
    end




    # puts "item num: #{item_num}, subtask_str: #{subtask_str}, ending_slash: #{ending_slash}, command_str: #{command_str}"

  end


end

