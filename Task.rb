class Task
  attr_reader :subtasks, :parent_task

  def initialize(name, parent_task = self)
    @name = name.chomp
    @parent_task = parent_task
    @subtasks = []
    @complete = false
    @collapsed = false
  end

  def [](index)
    @subtasks[index]
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
    #Clamp location
    location = [0,location,@subtasks.length].sort[1]

    if subtask.class == Task
      @subtasks.insert(location,subtask)
    elsif subtask.class == String
      new_subtask = Task.new(subtask,self)
      @subtasks.insert(location,new_subtask)
    else
      #TODO add argument error for bad class
    end
  end

  def rename(new_name = gets.chomp)
    @name = new_name
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