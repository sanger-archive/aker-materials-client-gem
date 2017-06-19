require 'uri'

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

    def has_next?
      _links&.has_key?(:next)
    end

    def has_prev?
      _links&.has_key?(:prev)
    end

    def is_last?
      !_links&.has_key?(:last)
    end

    def next
      request_link(_links[:next])
    end

    def prev
      request_link(_links[:prev])
    end

    def last
      request_link(_links[:last])
    end

   private

    def request_link(link)
      uri = URI(link[:href])
      model.requestor.get(nil, { query: uri.query })
    end

    def _items
      @response[:_items]
    end

    def _meta
      @response[:_meta]
    end

    def _links
      @response[:_links]
    end
	end
end