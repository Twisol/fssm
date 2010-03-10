module FSSM::Support::MetaDef
  def meta_def(method_name, &block)
    (class << self; self end).send(:define_method, method_name, block)
  end
end

class Object
  include FSSM::Support::MetaDef
end
