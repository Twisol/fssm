require 'singleton'
require 'rbconfig'

module FSSM::Backend
  class Registry
    include Singleton

    attr_reader :env

    def initialize
      @backends = {}
      @attempt_order = []
      @env = {
        :jruby => !!(defined?(JRUBY_VERSION)),
        :os => Config::CONFIG['target_os'],
        :mac => !!(Config::CONFIG['target_os'] =~ /darwin/i),
        :linux => !!(Config::CONFIG['target_os'] =~ /linux/i)
      }
    end

    def create(backend)
      raise ArgumentError, "unimplemented: #{backend}.key" unless
        backend.respond_to?(:key) && !backend.key.nil?
      key = "#{backend.key}"
      @backends[key.to_sym] = backend
      @attempt_order.unshift(key.to_sym)

      if @attempt_order.include?(:poll) && @attempt_order[-1] != :poll
        @attempt_order.delete!(:poll)
        @attempt_order.push(:poll)
      end
    end

    def delete(backend_or_key)
      key = backend_or_key.respond_to?(:key) ? "#{backend_or_key.key}" : "#{backend_or_key}"
      @backends.delete(key.to_sym)
      @attempt_order.delete(key.to_sym)
    end

    def backends
      @attempt_order.map {|k| "#{k}"}
    end

    def choose(key=:auto)
      if key == :auto
        chosen = @attempt_order.find {|key| @backends[key].usable?}
        @backends[chosen]
      elsif @backends.has_key?(key) and @backends[key].usable?
        @backends[key]
      end
    end

  end
end
