require_relative 'task'

def parse_input(input,current_list)
  # Inputs can take on a few different forms, the most common being:
  #
  # (subject)(verb)(direct object)(parameter)
  #
  # The subject and direct object are references to specific lists, and the verb is a one character command letter
  # The parameter is optional and speeds up the process sometimes
  # Some verbs do not take direct objects
  # If the subject is supplied without anything else, the parser sends an 'add' command or 'open' command if the subject
  # ends with a slash.
  #
  # Another kind of input takes only the verb
  # These actions apply to the program (opening settings), or to the current list, or to some default sublist
  #
  # Finally if the user types in a string that doesn't begin with '(command letter) ', the program searches for that
  # list and then opens it
  #
  #
  # Commands ($ = subject, &=direct object, *=parameter text, ~=parameter number):
  #
  # #a - Adding
  # TODO: $a  - adds multiple tasks above $ (until empty line is received)
  # TODO: $a * - adds one task, *, above $
  # TODO: a   - adds multiple tasks at end of list
  # TODO: A   - adds multiple tasks at beginning of list (equivalent to 0a)
  #
  # #d - move item down
  # TODO: $d  - moves $ down by 1 in the list
  # TODO: $d~ - moves $ down by ~ in the list
  #
  # #u - move item up
  # TODO: $u  - moves $ up by 1 in the list
  # TODO: $u~ - moves $ up by ~ in the list
  #
  # TODO: $o  - opens $
  # TODO: $/  - opens $


  #
  # Sample input:
  # '3/2m0' moves the sublist at 3/2 to the top of the current list
  # 2a Buy Groceries, adds the task 'Buy Groceries' above the second item in the current list
  # 3/2/ opens list 3/2
  #
end

def get_task(lineage_str,cur_list)
  #need to output parent task, target task, target index
  lineage = lineage_str.split '/'

  parent_list = cur_list
  target_task = cur_list
  target_index = 0

  lineage.each do |task_index|
    task_index = task_index.to_i

    # Move down the tree of tasks if sublevels are indicated
    parent_list = target_task
    target_task = parent_list[task_index]
    target_index = task_index
  end

  return parent_list,target_task,target_index

end

samp = Task.new("Top Level")
samp.insert_subtask(0,'AB')
samp.insert_subtask(1,'BC')
samp.insert_subtask(2,'CD')
samp.insert_subtask(3,'DE')
samp2 = samp[2]
samp2.insert_subtask(0,'EF')
samp2.insert_subtask(0,'FG')

parent_list, target_task, target_index = get_task('2/1',samp)
print "P: #{parent_list}\n\n T: #{target_task}\n\n I: #{target_index}"