
 def generate=(boolean)
    @generate = boolean
  end

  def generate?
    return false if @generate.nil?   # default generate flag is false
    @generate == true
  end
  
  def output_path=(value)
    @output_path = value
  end
  
  def output_path
    @output_path || '.'
  end



  # use loader? (that is, built-in seed data)
  def load=(boolean)
    @load = boolean
  end

  def load?
    return false if @load.nil?   # default create flag is false
    @load == true
  end
