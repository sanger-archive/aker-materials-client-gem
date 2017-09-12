module MatconClient
  class ResponseHandlerFactory

    attr_reader :model

    def initialize(options)
      @model = options.fetch(:model)
    end

    def build(response, post_query=nil)
      body = HashWithIndifferentAccess.new(response.body)

      if (body.has_key?(:_items))
        MatconClient::ResultSet.new(response: body, model: model, post_query: post_query)
      else
        model.new(body)
      end
    end

  end
end