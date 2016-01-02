require_relative 'task'
#TODO: use ARGV to pass in task file

##################
# Default Values #
##################
completed_list_length_default = 5




##################
#    Settings    #
##################
view_completed_tasks = false






top_level_task = Task.new('Top Level')
open_task = top_level_task

# Create specialized inbox list
inbox = Task.new('Inbox')
inbox.move(top_level_task)

#TODO: add ability to change default action behavior
default_action_slash = 'open'
default_action_no_slash = 'add'
#TODO: add settings and default settings hashes

while true
  system 'clear' or system 'cls'
  puts open_task

  if view_completed_tasks
    puts '-----------'
    puts ' Completed '
    open_task.xsubtasks[0,view_completed_tasks].each_with_index do |subtask, ind|
      puts "✓ #{ind}. #{subtask.name}"
    end
  end

  print "\n\nCommand:"
  input = gets #TODO add input prompt
  next if input.empty?

  # Input should be in the for (subject)(action)(predicate) text
  # All parts are optional, but look specific
  # Subject, Predicate are in the form x[/y/z/...] where x,y,z are numbers specifying the path to the task of interest
  # action should be a single letter or a command (e.g, 'a', 'add', 'i', 'down')
  parsed_input = /^(?<subject>-?[0-9]+(\/-?[0-9]+)*\/?)?(?<action>[a-zA-Z]+)?(?<predicate>-?[0-9]+(\/-?[0-9]+)*\/?)?( (?<text>.+))?$/.match(input)

  #TODO: Do something with bad input
  #TODO: Refactor to_task as a generic method rather than string method, return parent task as well

  subject_str = parsed_input['subject'] || ''
  subject_task = subject_str.to_task(open_task)
  subject_end_slash = subject_str[-1].eql?('/')
  # Subject int is the last number in the series, used when doing operations on the parent task.
  subject_int =  subject_task ? /[0-9]+\/?$/.match(subject_str).to_s.to_i : nil

  action = parsed_input['action']

  predicate_str = parsed_input['predicate'] || ''
  predicate_task = predicate_str.to_task(open_task)
  predicate_int = predicate_task ? /[0-9]+$/.match(predicate_str).to_s.to_i : nil
  predicate_end_slash = predicate_str[-1].eql?('/')

  input_text = parsed_input['text']

  #Shorthand for quick commands. Does default if only subject is provided
  unless action
    action = (subject_end_slash ? default_action_slash : default_action_no_slash)
  end

  # If command starts with a number, it is referring to that spot in the list
  # '0' adds new task at top of list
  # '0/4' adds new task above subtask 4 in task 0
  # '0/' opens task 0
  # '-2' adds new item above 2nd from last task in list

  #TODO: Potentially add "all" subject
  #TODO: Add parent subject commands
  #TODO: create list of commands
  # a, add          - adds item above subject
  # x, check, done  - marks task as completed
  # o, open         - opens task
  # u, up           - moves task up in a list
  # d, down         - moves task down in a list
  # m, move         - moves task above another task
  # i, inbox        - adds tasks to the inbox
  # l, load         - loads given task from a txt file (overwrites or appends to current subtasks)
  # s, save         - saves task to a txt file
  # v, view,        - views most recently completed subtasks in the open task
  #    completed

  case action
    when 'a', 'add'
      #when 'a' follows a task add new_task after it
      #when 'a' precedes a task number add new_task before it
      #if no task is specified at to the top of the current list
      if not(subject_str.empty?)
        # 'a' follows task (e.g., 3/2a)
        parent_task = (subject_task || open_task).parent_task #TODO: look into this || as a cause of starting first subtask bug
        insert_location = subject_int
      elsif not(predicate_str.empty?)
        # 'a' precedes task (e.g., a4)
        parent_task = (predicate_task || open_task).parent_task
        insert_location = predicate_int
      else
        # 'a' is alone
        parent_task = open_task
        insert_location = 0 #TODO: change for settings
      end

      #If text is specified add it as just one subtask
      #If no text is given, add tasks successively until a blank line is given
      if input_text
        parent_task.insert_subtask(insert_location,input_text)
      else
        parent_task.add_subtask(insert_location)
      end

    when 'x', 'check', 'done'
      completing_task = subject_task || predicate_task || open_task.subtasks[0]
      completing_task.mark_complete

    when 'xx', 'ux', 'uncheck'
      #calling with number unchecks nth most recently completed subtask in open_task
      open_task.xsubtasks[subject_int || predicate_int || 0].mark_incomplete


    when 'v', 'view', 'completed'
      length = subject_int || predicate_int || completed_list_length_default

      if view_completed_tasks == length
        view_completed_tasks = false
      else
        view_completed_tasks = length
      end



    when 'z', 'undo'

    when 'l', 'last view'

    when '?', 'help'


    when 'o', 'open'
      #opens a task so that it the current task
      #if o appears by itself open parent task

      #Prioritize number entered before 'o'
      open_task = subject_task || predicate_task || open_task.parent_task


    when 'u', 'up'
    when 'd', 'down'
    when 'm', 'move'

    when 'i', 'inbox'
      if input_text
        inbox.insert_subtask(subtask = input_text)
      else
        inbox.add_subtask
      end


    when 'l', 'load'
    when 's', 'save'

    else
      #TODO: Add bad command error

  end


end

