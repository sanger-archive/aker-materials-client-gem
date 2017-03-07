module MatconClient
  class ResultSet

    def initialize(options)
      @response = options.fetch(:response)
    end

  end
end