module HttpMonkey

  class Behaviours

    attr_reader :unknown_behaviour

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

    def find(code)
      behaviour = @behaviours[code]
      if behaviour.nil?
        _, behaviour = @behaviours_range.detect do |range, proc|
          range.include?(code)
        end
      end
      behaviour
    end

  end

  class Configuration

    def initialize
      net_adapter(:net_http)  #default adapter
      @behaviours = Behaviours.new
      # behaviour default always return response
      @behaviours.on_unknown { |client, req, response| response }
    end

    def initialize_copy(source)
      super
      @behaviours = @behaviours.clone
    end

    def net_adapter(adapter = nil)
      @net_adapter = adapter unless adapter.nil?
      @net_adapter
    end

    def behaviours(&block)
      @behaviours.instance_eval(&block) if block_given?
      @behaviours
    end

  end

end
