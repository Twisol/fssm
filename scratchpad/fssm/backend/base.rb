require 'fssm/backend/registry'

class FSSM::Backend::Base
  class << self
    def registry
      FSSM::Backend::Registry.instance
    end

    def inherited(backend)
      registry.create(backend)
    end

    def key(value=nil)
      value.nil? ? @key : @key = value
    end

    def usability_check(&block)
      @usability_check = block
    end
    alias :usable_when :usability_check

    def usable?
      @usability_check ? @usability_check.call(registry.env) : false
    end
  end

  def run
    raise('unimplemented')
  end

  def add_path
    raise('unimplemented')
  end
end
