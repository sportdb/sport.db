
  def create=(boolean)
    @create = boolean
  end

  def create?
    return false if @create.nil?   # default create flag is false
    @create == true
  end
  
  
  def setup=(boolean)
    @setup = boolean
  end

  def setup?
    return false if @setup.nil?   # default setup flag is false
    @setup == true
  end


  def delete=(boolean)
    @delete = boolean
  end

  def delete?
    return false if @delete.nil?   # default create flag is false
    @delete == true
  end
 


  def sport=(boolean)
    @sport = boolean
  end

  def sport?
    return false if @sport.nil?   # default sport flag is false
    @sport == true
  end
    
    
  def world=(boolean)
    @world = boolean
  end

  def world?
    return false if @world.nil?   # default populate world tables flag is false
    @world == true
  end

########################

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
