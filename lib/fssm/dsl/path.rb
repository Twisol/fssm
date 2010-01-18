class FSSM::DSL::Path
  include FSSM::Support::ContextBlock
  
  attr_reader :callbacks
  
  def initialize(path=nil, glob=nil, &block)
    set_path(path || '.')
    set_glob(glob || '**/*')
    
    @callbacks = {:collect => {}}
    init_blank_callbacks
    
    context_block(self, &block) if block_given?
  end
  
  def glob(value=nil)
    return @glob if value.nil?
    set_glob(value)
  end
  
  def create(&block)
    @callbacks[:create] = &block
  end

  def update(&block)
    @callbacks[:update] = &block
  end

  def delete(&block)
    @callbacks[:delete] = &block
  end
  
  def all(&block)
    @callbacks[:all] = &block
  end
  
  def collect(type = :all, &block)
    @callbacks[:collect][type] = &block
  end
  
  private
  
  def set_path(path)
    path = FSSM::Support::Pathname.for(path)
    raise FSSM::FileNotFoundError, "#{path}" unless path.exist?
    @path = path.expand_path
  end

  def set_glob(glob)
    @glob = glob.is_a?(Array) ? glob : [glob]
  end
  
  def init_blank_callbacks
    [:create, :update, :delete, :all].each {|type| @callbacks[type] = lambda {|base, relative|}}
    [:create, :update, :delete, :all].each {|type| @callbacks[:collect][type] = lambda {|events|}}
  end

  def get_callback(type)
    @callbacks[type]
  end
  
end
