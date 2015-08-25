class Fiber
  class Mutex
    @lock = nil
    @waiting = [] of Fiber
    @lock_level = 0

    def lock(&block)
      current = Fiber.current
      if @lock != current
        while @lock
          @waiting << current unless @waiting.includes? current
          Scheduler.reschedule
        end
        @lock = Fiber.current
      end
      @lock_level += 1
      block.call
      @lock_level -= 1
      if @lock_level == 0
        @lock = nil
        Scheduler.enqueue @waiting.shift unless @waiting.empty?
      end
    end
  end
end
