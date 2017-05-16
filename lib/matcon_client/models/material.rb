module MatconClient

  class Material < Model
    self.endpoint = 'materials'

    def parents
      MatconClient::Material.where(parent_ids: {"$in" => @parent_ids})
    end

    def parents=(prnts)
      @parent_ids = prnts.map(&:_id)
    end
  end

end 