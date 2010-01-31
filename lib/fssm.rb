$LOAD_PATH.unshift(File.dirname(__FILE__)) unless
  $LOAD_PATH.include?(File.dirname(__FILE__))

module FSSM
  FileNotFoundError = Class.new(StandardError)
  CallbackError = Class.new(StandardError)
end

require 'fssm/support'
#require 'fssm/dsl'
