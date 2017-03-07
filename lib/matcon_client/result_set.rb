module MatconClient
  class ResultSet
    include Enumerable

    attr_reader :model

    def initialize(options)
      @response = options.fetch(:response)
      @model = options.fetch(:model)
    end

    def each(&block)
      _items.each do |m|
        block.call(model.new m)
      end
    end

    def max_results
      _meta[:max_results]
    end

    def total
      _meta[:total]
  	end

	  def page
	    _meta[:page]
	  end

	 private

    def _items
      @response[:_items]
    end

    def _meta
      @response[:_meta]
    end
	end
end