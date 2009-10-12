module Wrench
  class PushPipe < Wrench::Pipe
    include Extlib::Hook

    attr_accessor :downstream

    (IN - %w( << < )).each do |i|
      after i.to_sym, :flush_downstream
    end

    def initialize(io = nil)
      super()
      @downstream = io
    end

    #Extlib can't hook symbolic methods
    alias_method :_redirect, :<
    def <(*a, &b)
      K _redirect(*a, &b) do
        flush_downstream
      end
    end

    alias_method :_output, :<<
    def <<(*a, &b)
      K _output(*a, &b) do
        flush_downstream
      end
    end

    def attach(io)
      K @downstream = io do
        flush_downstream
      end
    end

    def close(*a,&b)
      @downstream.close(*a,&b) unless @downstream.nil?
      super(*a,&b)
    end

    def flush_downstream
      unless @downstream.nil?
        if length = ready?
          @downstream << read(length)
        end
      end
    end
  end
end

