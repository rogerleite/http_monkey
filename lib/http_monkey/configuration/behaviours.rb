module HttpMonkey

  class Configuration::Behaviours

    attr_reader :unknown_behaviour, :error_behaviour

    def initialize
      self.clear!
    end

    def initialize_copy(source)
      super
      @behaviours = @behaviours.clone
      @behaviours_range = @behaviours_range.clone
    end

    def clear!
      @behaviours = {}
      @behaviours_range = {}
      @unknown_behaviour = nil
      @error_behaviour = nil
      nil
    end

    def on(code, &block)
      if code.is_a?(Integer)
        @behaviours[code] = block
      elsif code.respond_to?(:include?)
        @behaviours_range[code] = block
      end
      nil
    end

    def on_unknown(&block)
      @unknown_behaviour = block
    end

    def on_error(&block)
      @error_behaviour = block
    end

    def find(code)
      behaviour = @behaviours[code]
      if behaviour.nil?
        _, behaviour = @behaviours_range.detect do |range, proc|
          range.include?(code)
        end
      end
      behaviour
    end

    def execute(code)
      behaviour = self.find(code) || self.unknown_behaviour
      yield(behaviour) if block_given?
    end

  end

end
