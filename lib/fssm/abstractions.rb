module FSSM::Abstractions
  InvalidAbstraction = Class.new(StandardError)
  
  class Path    
    def initialize(path)
      @path = FSSM::Support::Pathname.for(path).expand_path
    end
    
    def to_s
      "#{@path}"
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
    attr_reader :paths
    attr_reader :patterns
    
    def initialize(args={})
      @paths = args[:paths] || []
      @patterns = args[:patterns] || []
    end
    
    def path(path)
      @paths.push(Path.new(path))
    end
    
    def pattern(path, glob=nil)
      @patterns.push(Pattern.new(path, glob))
    end
  end
end
