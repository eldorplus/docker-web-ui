class Dictionary

  def initialize
    @hash = {}
  end

  def add(key_value)
    key_value.each do |key, value|
      @hash[key] = value
    end
  end

  def get_path_content(dir)
    queue = Queue.new
    result = []
    queue << dir
    until queue.empty?
      current = queue.pop
      Dir.entries(current).each { |f|
        full_name = File.join(current, f)
        if not (File.directory? full_name)
          path, file = File.split(full_name)
          path = path.split('/').last
          if file == 'Dockerfile'
            files = add('path' => path, 'file' => file)
            result << files
          end
        elsif f != '.' and f != '..'
          queue << full_name
        end
      }
    end
    result
  end

  def get_file_content(file)
    path = get_absolute_path file
    content = File.read(path)
  end

  def get_absolute_path(file)
    pth, f = File.split(file)
    pwd = Pathname.pwd + "dockerfiles/"
    if defined? pth and pth == "dockerfiles"
      path = File.join(pwd, f)
    else
      folder = File.join(pwd, pth)
      mkdir folder
      path = File.join(pwd, file)
    end
    path
  end

  def entries
    @hash
  end

  def keywords
    @hash.keys
  end

  private
    def mkdir dir
      if Dir.exists?(dir)
        dirname = dir
      else
        Dir.mkdir(dir, 0664) unless File.exists?(dir)
        dirname = dir
      end
      dirname
    end
end