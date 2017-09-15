module MatconClient
  class Requestor

    attr_reader :klass

    def initialize(options)
      @klass = options.fetch(:klass)
    end

    def get(path=nil, params = {}, headers = {})
      query = params.delete(:query)
      request(:get, fullpath(path, query), {}, headers)
    end

    def post(path=nil, params = {}, headers = {}, post_query = nil)
      request(:post, fullpath(path), params, headers, post_query)
    end

    def put(path, params = {}, headers = {})
      request(:put, fullpath(path), params, headers)
    end

    def delete(path, params = {}, headers = {})
      request(:delete, fullpath(path), params, headers)
    end

    def patch(path, params = {}, headers = {})
      request(:patch, fullpath(path), params, headers)
    end

  private

    def fullpath(path, query=nil)
      f = klass.endpoint
      f += '/'+path unless path.nil?
      f = "#{f}?#{query}" unless query.nil?
      f
    end

    def request(action, path, params, headers, post_query=nil)
      klass.response_handler.build(klass.connection.run(action, path, params, headers), post_query)
    end

  end
end