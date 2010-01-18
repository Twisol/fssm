class FSSM::DSL::Backend
  def initialize(*backends)
    @try_order = backends || [:auto]
    @options = {}
  end
  
  attr_reader :chosen
  
  def choose(be)
    @chosen = be
  end
  
  def find_backend
  end
  
  def method_missing(name, *args)
    @options[name.to_sym] = args.length == 1 ? args[0] : args
  end
  
end
