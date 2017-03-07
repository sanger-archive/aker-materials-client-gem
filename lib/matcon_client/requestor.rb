module MatconClient
  class Requestor

    attr_reader :klass

    def initialize(options)
      @klass = options.fetch(:klass)
    end

    def get(path, params = {}, headers = {})
      query = params.delete(:query)
      path = "#{path}?#{query}" if query.present?
      request(:get, path, {}, headers)
    end

    def post(path, params = {}, headers = {})
      request(:post, path, params, headers)
    end

    def put(path, params = {}, headers = {})
      request(:put, path, params, headers)
    end

    def delete(path, params = {}, headers = {})
      request(:delete, path, params, headers)
    end

  private

    def request(action, path, params, headers)
      klass.result_set.build(klass.connection.run(action, path, params, headers))
    end

  end
end