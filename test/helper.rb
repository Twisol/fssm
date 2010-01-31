require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'fssm'

class Test::Unit::TestCase

  def self.should_clean_pathname(expected, input)
    should "cleanpath #{input} to #{expected}" do
      assert_equal(expected, FSSM::Support::Pathname.new(input).cleanpath.to_s)
    end
  end

  def self.should_add_pathname(expected, first, second)
    should "add #{first} and #{second} to #{expected}" do
      fp = FSSM::Support::Pathname.new(first)
      sp = FSSM::Support::Pathname.new(second)
      assert_equal(expected, (fp + sp).to_s)
    end
  end

  def self.should_be_relative_pathname(expected, dest, base)
    should "return #{expected} as the relative path of #{dest} from #{base}" do
      dp = FSSM::Support::Pathname.new(dest)
      bp = FSSM::Support::Pathname.new(base)
      relative = dp.relative_path_from(bp).to_s
      assert_equal(expected, relative)
    end
  end

end
