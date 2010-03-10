module FSSM
  class Difference
    attr_reader :created
    attr_reader :updated
    attr_reader :deleted
        
    def initialize(args={})
      @created = args[:created].map {|pn| "#{pn}"} || []
      @updated = args[:updated].map {|pn| "#{pn}"} || []
      @deleted = args[:deleted].map {|pn| "#{pn}"} || []
      
      @index = {
        :created => @created,
        :updated => @updated,
        :deleted => @deleted
      }.inject({}) do |idx, (type, paths)|
        paths.each {|path| idx[path] = idx[path] ? (idx[path] + [type]) : [type] }
        idx
      end
    end
    
    def path(path)
      @index["#{file}"]
    end
    
    def pattern(pattern)
      @index.select {|path, type| File.fnmatch("#{pattern}", path)}
    end
  end
end
