module FSSM::Abstractions
  InvalidAbstraction = Class.new(StandardError)
  
  class File    
    def initialize(file)
      @file = FSSM::Support::Pathname.for(file).expand_path
      raise InvalidAbstraction unless @file.file?
    end
    
    def to_s
      "#{@file}"
    end
  end
  
  class Pattern
    attr_reader :path
    attr_reader :glob
    
    def initialize(path, glob=nil)
      @path = FSSM::Support::Pathname.for(path).expand_path
      @glob = glob || '**/*'
      raise InvalidAbstraction unless @path.directory?
    end
    
    def to_s
      "#{@path}/#{@glob}"
    end
    
    def resolve
      FSSM::Support::Pathname.glob(@path.join(@glob).to_s)
    end
  end
  
  class Group
    attr_reader :files
    attr_reader :patterns
    
    def initialize(args={})
      @files = args[:files] || []
      @patterns = args[:patterns] || []
    end
    
    def file(file)
      @files.push(File.new(file))
    end
    
    def pattern(path, glob=nil)
      @patterns.push(Pattern.new(path, glob))
    end
  end
end
