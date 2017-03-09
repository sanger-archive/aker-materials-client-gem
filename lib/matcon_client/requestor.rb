module MatconClient
  class Requestor

    attr_reader :klass

    def initialize(options)
      @klass = options.fetch(:klass)
    end

    def get(path=nil, params = {}, headers = {})
      fullpath = klass.endpoint
      fullpath += '/'+path unless path.nil?
      query = params.delete(:query)
      fullpath = "#{fullpath}?#{query}" if query.present?
      request(:get, fullpath, {}, headers)
    end

    def post(path=nil, params = {}, headers = {})
      fullpath = klass.endpoint
      fullpath += '/'+path unless path.nil?
      request(:post, fullpath, params, headers)
    end

    def put(path, params = {}, headers = {})
      fullpath = klass.endpoint
      fullpath += '/'+path unless path.nil?
      request(:put, fullpath, params, headers)
    end

  private

    def request(action, path, params, headers)
      klass.response_handler.build(klass.connection.run(action, path, params, headers))
    end

  end
end