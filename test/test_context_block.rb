require 'helper'

class Main
  include FSSM::Support::ContextBlock
  
  def child(&block)
    c = Child.new
    context_block(c, &block) if block_given?
    c
  end
end

class Child
  attr_accessor :foo
  attr_accessor :bar
end

class TestContextBlock < Test::Unit::TestCase
  context "A context block" do
    setup do
      @obj = Main.new
    end
    
    should 'eval within its context when not given a block parameter' do
      c = @obj.child do
        self.foo = 1
        self.bar = 2
      end
      
      assert_equal 1, c.foo
      assert_equal 2, c.bar
    end
    
    should 'provide its context object when given a block parameter' do
      c = @obj.child do |child|
        child.foo = 1
        child.bar = 2
      end
      
      assert_equal 1, c.foo
      assert_equal 2, c.bar
    end
    
  end
end
