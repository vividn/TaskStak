require_relative 'task'

#TODO: merge these into Task class

# load_task returns a task loaded from a .txt file where indents create subtasks
def load_task(task_file_str, name=nil)
  name = name || task_file_str.slice(/^.*\./)

  lines = []
  File.open(task_file_str,'r') do |task_file|
    while line = task_file.gets
      lines.push(line)
    end
  end

  return_task = Task.new(name)

  previous_task = return_task
  indent_level = -1
  until lines.empty?
    line = lines.shift

    #Count the number of tabs to get the indent level
    new_indent_level = line.slice!(/^\t*/).length

    #Make a new task named everything after the initial tabs
    current_task = Task.new(line)

    indent_difference = new_indent_level - indent_level
    if indent_difference <= 0
      #This task belongs to some parent of the previous_task read
      parent_task = previous_task.get_parent(-indent_difference)
    elsif indent_difference == 1
      #This task is a subtask of the previous_task read
      parent_task = previous_task
    else
      #Indent level skips by at least 2, unacceptable
      #TODO: return error
    end

    current_task.move(parent_task)

    previous_task = current_task
    indent_level = new_indent_level

  end

  return_task
end

def save_task(task,task_file_str)
  # Define a recursive function to iterate through when making the file
  def task_writer(task_file, current_task, indent_level)
    current_task.subtasks.each do |subtask|
      task_file.puts "\t"*indent_level + subtask.name
      task_writer(task_file, subtask, indent_level+1)
    end
  end

  File.open(task_file_str,'w') do |task_file|
    task_writer(task_file, task, 0)
  end
end

a = load_task("Sample_task_list.txt")
save_task(a,"sample_out.txt")