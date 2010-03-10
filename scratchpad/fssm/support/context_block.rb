module FSSM::Support::ContextBlock
  def context_block(context, &block)
    block.arity == 1 ? block.call(context) : context.instance_eval(&block)
  end
end
