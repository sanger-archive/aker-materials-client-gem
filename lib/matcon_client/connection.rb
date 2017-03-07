require 'faraday_middleware'

module MatconClient
  class Connection

    attr_reader :faraday

    def initialize(options = {})
      site = options.fetch(:site)
      connection_options = options.slice(:proxy, :ssl, :request, :headers, :params)
      adapter_options = Array(options.fetch(:adapter, Faraday.default_adapter))

      @faraday = Faraday.new(site, connection_options) do |builder|
        builder.adapter(*adapter_options)

        # Faraday Middleware
        # https://github.com/lostisland/faraday_middleware
        builder.use ::FaradayMiddleware::ParseJson, :content_type => /\bjson$/
      end

      yield(self) if block_given?
    end

    # inserted middleware will run after json parsed
    def use(middleware, *args, &block)
      return if faraday.builder.locked?
      faraday.builder.insert_before(::FaradayMiddleware::ParseJson, middleware, *args, &block)
    end

    def delete(middleware)
      faraday.builder.delete(middleware)
    end

    def run(request_method, path, params = {}, headers = {})
      faraday.send(request_method, path, params, headers)
    end

  end
end