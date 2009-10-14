require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper'))

describe Wrench::Command do
  it 'echo foo' do
    Wrench::Command.new('echo foo').join.should == "foo\n"
  end

  it 'date' do
    Date.parse(Wrench::Command.new('date').join)
  end

  it 'for i in 1 2 3 4 5; do echo $i; sleep 0.01; done' do
    Wrench::Command.new('for i in 1 2 3 4 5; do echo $i; sleep 0.01; done').join.should == %w(1 2 3 4 5).join("\n") << "\n"
  end
end
