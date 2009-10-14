require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Wrench::Command do
  describe "#command" do
    it 'should be the argv joined by spaces' do
      Wrench::Command.new('foo', 'bar', 'baz').command.should == 'foo bar baz'
    end
  end

  describe "#run" do
    it 'should return a thread' do
      Wrench::Command.new('foo').run.should be_instance_of(Thread)
    end
  end

  describe "#open" do
    it 'should set the status' do
      c = Wrench::Command.new('date')
      lambda { c.open }.should change { c.status }.from(nil)
    end
  end
end
