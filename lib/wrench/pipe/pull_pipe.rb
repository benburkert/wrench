module Wrench
  class PullPipe < Wrench::Pipe
    include Extlib::Hook

    attr_accessor :upstream

    OUT.each do |out|
      before out.to_sym, :flush_upstream
    end

    def initialize(io = nil)
      super()
      @upstream = io
    end

    def attach(io)
      @upstream = io
    end

    def flush_upstream
      unless @upstream.nil? || @upstream.closed? || closed?
        if length = @upstream.ready?
          @in << @upstream.read(length)
        end
      end
    end

    def wait(*a,&b)
      if closed? || ready? || @upstream.nil?
        super(*a,&b) && self
      elsif @upstream.wait
        self
      end
    end
  end
end
