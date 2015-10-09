class Task
  attr_reader :subtasks, :parent_task, :name
  attr_accessor :sibling_index

  def initialize(name)
    @name = name.chomp
    @parent_task = self
    @sibling_index = 0
    @subtasks = []
    @complete = false
    @collapsed = false
  end

  def [](index)
    @subtasks[index]
  end

  def move(new_parent,location=new_parent.subtasks.length)
    #TODO: prevent moving into a subtask of self
    old_parent = @parent_task

    # Move the task to the new parent and remove from the old parent updating references
    @sibling_index = new_parent.insert_subtask(location,self)
    old_parent.remove(self)
    @parent_task = new_parent

  end

  def renumber
    @subtasks.each_with_index do |subtask,index|
      subtask.sibling_index = index
    end
  end

  def get_parent(parent_number)
    # 0 is immediate parent, 1 is parent's parent, etc.
    return @parent_task if parent_number <= 0
    @parent_task.get_parent(parent_number-1)
  end

  #TODO:delete (maybe in the main program instead)

  def remove(subtask)
    #Only call internally (use delete or move externally)
    if subtask.class == Integer
      @subtasks.delete_at(subtask)
    elsif subtask.class == Task
      #TODO: add exception here if returns nil
      @subtasks.delete(subtask)
    else
      #TODO: add exception here
    end
    self.renumber
  end

  def add_subtask(location = @subtasks.length)
    #Add tasks via user interface repeatedly.
    input = gets.chomp
    unless input.empty?
      insert_subtask(location,input)
      add_subtask(location+1)
    end
  end

  def insert_subtask(location = @subtasks.length,subtask)
    #Clamp location (so if large number entered put at end of list)
    location = [0,location,@subtasks.length].sort[1]

    if subtask.class == Task
      @subtasks.insert(location,subtask)
    elsif subtask.class == String
      new_subtask = Task.new(subtask)
      new_subtask.move(self,location)
    else
      #TODO add argument error for bad class
    end
    self.renumber
    location
  end

  def rename(new_name = gets.chomp)
    @name = new_name
  end

  def inspect
    "#{@name}; p:\"#{@parent_task.name}\", sib#:#{@sibling_index}, subs:#{@subtasks.length}"
  end

  def to_s
    create_output_string
  end
  def create_output_string(indent_level=-1,position=0)

    #Output string
    ret = ""

    #No index number for top level list
    if indent_level >= 0

      #Number of spaces per indent
      indent_spaces = 2
      ret << ' '*(indent_spaces*indent_level)

      #Add collapsing character (+ or -, · if no subtasks)
      if @collapsed && !@subtasks.empty?
        collapsing_format_str = "[%d] "
      else
        collapsing_format_str = "%d| "
      end

      #Add index number
      ret << sprintf(collapsing_format_str,position).rjust(5)

    end

    # Add name of task
    ret << @name
    ret << "\n"

    # Add underline if title
    if indent_level < 0
      ret << "~"*(@name.length+2)
      ret << "\n"
    end

    # Add subtasks
    unless @collapsed && indent_level >= 0
      @subtasks.each_index do |index|
        subtask = @subtasks[index]
        ret << subtask.create_output_string(indent_level+1,index)
      end
    end

    ret
  end

  def collapse
    @collapsed = true
  end
  def uncollapse
    @collapsed = false
  end
  def toggle_collapse
    @collapsed = !@collapsed
  end

end

class String
  def to_task(open_task)
    return open_task if self.empty?
    first_number_match = /^\/?([0-9]+)\/?/.match(self)
    target_task = open_task[first_number_match[1].to_i]
    #TODO: add end of list functionality here

    # Recurse through the rest of the string
    $'.to_task(target_task)
  end
end

class NilClass
  def to_task(open_task)
    nil
  end
end

#TODO: add gemfile and testing capabilities and test "to_task"