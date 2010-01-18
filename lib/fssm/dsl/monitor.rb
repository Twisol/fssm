class FSSM::DSL::Monitor
  include FSSM::Support::ContextBlock
  
  def initialize
    @paths = []
  end
  
  def backend(*args, &block)
    @backend = FSSM::DSL::Backend.new(*args)
    context_block(@backend, &block) if block_given?
  end
  
  def path(*args, &block)
    path = FSSM::DSL::Path.new(*args)
    context_block(path, &block) if block_given?
    @paths.push(path)
  end
end
