module FSSM::Backend
  def Build(key)
    meta_def(:key, key)
  end
  
  module_function :Build
end
