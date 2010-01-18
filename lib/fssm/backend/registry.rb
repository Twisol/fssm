require 'singleton'
require 'rbconfig'

module FSSM::Backend
  class Registry
    include Singleton
    
    attr_reader :env
    
    def initialize
      @backends = {}
      @env = {
        :jruby => defined?(JRUBY_VERSION),
        :os => Config::CONFIG['target_os'],
        :mac => Config::CONFIG['target_os'] =~ /darwin/i,
        :linux => Config::CONFIG['target_os'] =~ /linux/i
      }
    end
    
    def create(backend)
      raise ArgumentError, "unimplemented: #{backend}.key" unless
        backend.respond_to?(:key) && !backend.key.nil?
      @backends["#{backend.key}".to_sym] = backend
    end
    
    def delete(backend_or_key)
      key = backend_or_key.respond_to?(:key) ? backend_or_key.key : backend_or_key
      @backends.delete("#{key}".to_sym)
    end
    
    def backends
      @backends.keys.map(&:to_s).sort
    end
    
    def choose(key=:auto)
      return @backends[key] if @backends.has_key?(key) and @backends[key].usable?
    end
    
  end
end
