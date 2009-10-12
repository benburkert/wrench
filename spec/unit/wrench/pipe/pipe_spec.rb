require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Wrench::Pipe do
  it 'is +rw' do
    pipe = Wrench::Pipe.new
    pipe << 'foo'
    pipe.read.should == 'foo'
  end

  describe ".join" do
    it 'should return a thread' do
      p1, p2 = Wrench::Pipe.new, Wrench::Pipe.new
      Wrench::Pipe.join(p1, p2).should be_instance_of(Thread)
    end

    it 'should close the downstream pipe when the upstream is closed' do
      p1, p2 = Wrench::Pipe.new, Wrench::Pipe.new
      t = Wrench::Pipe.join(p1, p2)

      lambda {
        p1.close
        t.join
      }.should change { p2.closed? }.to(true)
    end
  end

  describe '#>>' do
    it "should write to the argument's buffer" do
      p1, p2 = Wrench::Pipe.new, Wrench::Pipe.new
      p1 << 'bar'
      p1 >> p2
      p2.read.should == 'bar'
    end
  end

  describe '#read' do
    it 'should be non blocking' do
      Wrench::Pipe.new.read.should be_nil
    end
  end
end
