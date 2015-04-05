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
  # TODO: $a* - adds one task, *, above $
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
  lineage = lineage_str.split '/'
  lineage.each do |task_index|
    task_index = task_index.to_i
    target_list = item
    item_num = task_index
    item = target_list[item_num]
  end
end