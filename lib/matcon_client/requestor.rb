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

    def post(path=nil, params = {}, headers = {})
      request(:post, fullpath(path), params, headers)
    end

    def put(path, params = {}, headers = {})
      request(:put, fullpath(path), params, headers)
    end

    def delete(path, params = {}, header = {})
      request(:delete, fullpath(path), params, header)
    end

  private

    def fullpath(path, query=nil)
      f = klass.endpoint
      f += '/'+path unless path.nil?
      f = "#{f}?#{query}" unless query.nil?
      f
    end

    def request(action, path, params, headers)
      klass.response_handler.build(klass.connection.run(action, path, params, headers))
    end

  end
end