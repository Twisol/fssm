require 'helper'

class TestFssmPathnameRubyspec < Test::Unit::TestCase
  context "FSSM::Support::Pathname#absolute?" do
    should "return true for the root directory" do
      assert FSSM::Support::Pathname.new('/').absolute?
    end

    should "return true for a dir starting with a slash" do
      assert FSSM::Support::Pathname.new('/usr/local/bin').absolute?
    end

    should "return false for a dir not starting with a slash" do
      assert !FSSM::Support::Pathname.new('fish').absolute?
    end

    should "return false for a path not starting with a slash" do
      assert !FSSM::Support::Pathname.new('fish/dog/cow').absolute?
    end
  end

  context "FSSM::Support::Pathname#==" do
    should "return true when identical paths are used" do
      assert_equal(FSSM::Support::Pathname.new(''), FSSM::Support::Pathname.new(""))
    end

    should "not return true when different paths are used" do
      assert_not_equal(FSSM::Support::Pathname.new(''), FSSM::Support::Pathname.new('/usr/local/bin'))
    end
  end

  context "FSSM::Support::Pathname#hash" do
    should "be equal to the hash of the pathname" do
      assert_equal(FSSM::Support::Pathname.new('/usr/local/bin/').hash, '/usr/local/bin/'.hash)
    end

    should "not be equal the hash of a different pathname" do
      assert_not_equal(FSSM::Support::Pathname.new('/usr/local/bin/').hash, '/usr/bin/'.hash)
    end
  end

  context "FSSM::Support::Pathname.new" do
    should "return a new Pathname Object with 1 argument" do
      assert_kind_of(FSSM::Support::Pathname, FSSM::Support::Pathname.new(''))
    end

    should "raise an ArgumentError when called with \\0" do
      assert_raise ArgumentError do
        FSSM::Support::Pathname.new("\0")
      end
    end

    should "be tainted if path is tainted" do
      path = '/usr/local/bin'.taint
      assert(FSSM::Support::Pathname.new(path).tainted?)
    end
  end

  context "FSSM::Support::Pathname#parent" do
    should "have a parent of root as root" do
      assert_equal('/', FSSM::Support::Pathname.new('/').parent.to_s)
    end

    should "have a parent of root as /usr/" do
      assert_equal('/', FSSM::Support::Pathname.new('/usr/').parent.to_s)
    end

    should "have a parent of /usr/ as /usr/local" do
      assert_equal('/usr', FSSM::Support::Pathname.new('/usr/local').parent.to_s)
    end
  end

  context "FSSM::Support::Pathname#relative?" do
    should "return false for the root directory" do
      assert(!FSSM::Support::Pathname.new('/').relative?)
    end

    should "return false for a dir starting with a slash" do
      assert(!FSSM::Support::Pathname.new('/usr/local/bin').relative?)
    end

    should "return true for a dir not starting with a slash" do
      assert(FSSM::Support::Pathname.new('fish').relative?)
    end

    should "return true for a path not starting with a slash" do
      assert(FSSM::Support::Pathname.new('fish/dog/cow').relative?)
    end
  end

  context "FSSM::Support::Pathname#root?" do
    should "return true for root directories" do
      assert(FSSM::Support::Pathname.new('/').root?)
    end

    should "return false for an empty string" do
      assert(!FSSM::Support::Pathname.new('').root?)
    end

    should "return false for a top level directory" do
      assert(!FSSM::Support::Pathname.new('/usr').root?)
    end

    should "return false for a top level with .. appended" do
      assert(!FSSM::Support::Pathname.new('/usr/..').root?)
    end

    should "return false for a directory below top level" do
      assert(!FSSM::Support::Pathname.new('/usr/local/bin/').root?)
    end
  end

  context "FSSM::Support::Pathname#sub" do
    should "replace the pattern with rest" do
      assert_equal('/usr/fish/bin/', FSSM::Support::Pathname.new('/usr/local/bin/').sub(/local/, 'fish').to_s)
    end

    should "return a new object" do
      p = FSSM::Support::Pathname.new('/usr/local/bin/')
      sub = p.sub(/local/, 'fish')
      assert_not_equal(p, sub)
    end
  end

end
