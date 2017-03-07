module MatconClient
  class ResponseHandlerFactory

    attr_reader :model

    def initialize(options)
      @model = options.fetch(:model)
    end

    def build(response)
      if (response.has_key?(:_items))
        MatconClient::ResultSet.new(response: response)
      else
        model.new(response)
      end
    end

  end
end