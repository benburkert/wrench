require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper'))

describe Object do
  describe '#K (the K-combinator)' do
    it 'should return the argument' do
      K(:foo).should == :foo
      K(:foo, :bar).should == [:foo, :bar]
      K([:foo]).should == [:foo]
    end
  end
end
