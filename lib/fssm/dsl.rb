module FSSM::DSL
end

require 'fssm/support/context_block'
require 'fssm/dsl/path'
require 'fssm/dsl/backend'
require 'fssm/dsl/monitor'

module FSSM
  extend FSSM::Support::ContextBlock
  
  def self.monitor(&block)
    monitor = FSSM::DSL::Monitor.new
    context_block(monitor, &block) if block_given?
    monitor
  end
end
