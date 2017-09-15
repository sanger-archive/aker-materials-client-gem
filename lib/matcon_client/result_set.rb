require 'uri'

module MatconClient
  class ResultSet
    include Enumerable

    attr_reader :model

    def initialize(options)
      @response = options.fetch(:response)
      @model = options.fetch(:model)
      @post_query = options[:post_query]
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

    # Follow a page index from a post-search.
    # I.e. rerun the post query that generated these results, but
    #  with the page set to whatever page is indicated.
    # If there is no page indicated, return nil.
    def request_post(link, post_query)
      return nil unless link && link[:page]
      params = post_query.params.merge(page: link[:page])
      Query.new(klass: post_query.klass, params: params).result_set_with_post
    end

    def request_link(link)
      return request_post(link, @post_query) if @post_query
      return nil unless link && link[:href]
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