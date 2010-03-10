module FSSM
  class ManagedState
    def initialize
      @cache = FSSM::Tree::Cache.new
    end
    
    def all
      @cache.all
    end
    
    def build_difference
      previous = @cache.all
      yield
      current = @cache.all
      
      FSSM::Difference.new({
        :created => created(previous, current),
        :updated => modified(previous, current),
        :deleted => deleted(previous, current)
      })
    end

    def update_patterns(patterns)
      patterns.each do |pattern|
        @cache.unset "#{pattern.path}"
        pattern.resolve.each {|filename| @cache.set(filename)}
      end
    end

    def update_paths(paths)
      paths.each do |path|
        @cache.unset "#{path}"
        @cache.set "#{path}"
      end
    end
    
    private
    
    def created(previous, current)
      (current.keys - previous.keys)
    end

    def deleted(previous, current)
      (previous.keys - current.keys)
    end

    def modified(previous, current)
      (current.keys & previous.keys).select do |path|
        (current[path] <=> previous[path]) != 0
      end
    end
    
  end
end
