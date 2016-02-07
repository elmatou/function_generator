module FunctionGenerator
  class Function
    def initialize(&block)
      raise ArgumentError unless block_given?
      @block = block
    end

    def [](*args)
      @block.call(*args)
    end

  end

  require 'fiber'
  
  class TimeBasedFunction < Function
    attr_accessor :started_at
    attr_reader   :runner

    def start
      @started_at = Time.now
      self
    end

    def stop
      @started_at = nil
      self
    end

    def value(with_abscissa = false)
      if @started_at
        abscissa = Time.now - @started_at
        with_abscissa ? [abscissa, self[abscissa]] : self[abscissa]
      end
    end


    def run(sample_rate, lenght = nil , &callback)
      raise ArgumentError, '#run need a callback block to return value' unless block_given? 
      @runner = Fiber.new do
        self.start
        time_gap = (1.0 / sample_rate)
        loop do
          abscissa, returned_value = self.value(true)
          Fiber.yield(Fiber.current) if ( !started_at || (lenght && abscissa > lenght))
          Fiber.new { callback.call(abscissa, returned_value) }.resume
          sleep(time_gap)
        end
        self.stop
      end.resume
      self
    end

    # def legacy_run(sample_rate, lenght = nil , &callback)
    #   raise ArgumentError, '#run need a callback block to return value' unless block_given? 
    #   fles = self
    #   @runner = Thread.new do
    #     fles.start
    #     time_gap = (1.0 / sample_rate)
    #     loop do
    #       abscissa, returned_value = self.value(true)
    #       Thread.new { callback.call(abscissa, returned_value) }
    #       break if lenght && abscissa > lenght
    #       sleep(time_gap)
    #     end
    #     fles.stop
    #   end
    #   self
    # end

  end

end
