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
  #TODO: Switch ints to last number, or add last number recording for sibling number reasons

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

  case action
    when 'a', 'add'
    when 'x', 'check', 'done'
    when 'o', 'open'
    when 'u', 'up'
    when 'd', 'down'
    when 'm', 'move'
    when 'i', 'inbox'
    else
      #TODO: Add bad command error

  end


end

