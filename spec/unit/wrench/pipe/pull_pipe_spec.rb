require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Wrench::PullPipe do
  it 'should be chainable' do
    p1 = Wrench::PullPipe.new
    p2 = Wrench::PullPipe.new(p1)
    p3 = Wrench::PullPipe.new(p2)

    p1 << 'blah'
    p3.read.should == 'blah'
  end

  it 'should read just in time' do
    p1 = Wrench::PullPipe.new
    p2 = Wrench::PullPipe.new(p1)
    p3 = Wrench::PullPipe.new(p2)

    p1 << 'blarg'
    p3.out.should_not be_ready
    p3.read.should == 'blarg'
  end

  describe '#attach' do
    it 'should set the upstream IO' do
      pullr, io = Wrench::PullPipe.new, StringIO.new
      lambda { pullr.attach(io) }.should change { pullr.upstream }.to(io)
    end
  end

  describe "#wait" do
    it 'should return self if the IO is ready' do
      p1 = Wrench::PullPipe.new
      p1 << 'foo'
      p1.wait.should == p1
    end

    it 'should return self if the upstream is ready' do
      p1, up = Wrench::PullPipe.new, Wrench::PullPipe.new
      p1.attach(up)
      up << 'foo'
      p1.wait.should == p1
    end

    it 'should return nil if the upstream is ready but the IO is closed' do
      p1, up = Wrench::PullPipe.new, Wrench::Pipe.new
      p1.attach(up)
      up << 'foo'
      p1.close
      p1.wait.should == nil
    end
  end
end
