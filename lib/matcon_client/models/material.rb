module MatconClient

  class Material < Model
    self.endpoint = 'materials'

    def parents
      if @attributes["parents"].all? {|s| s.kind_of? String }
        MatconClient::Material.where("_id" => {"$in" =>  @attributes["parents"]})
      else
        super
      end
    end

    # This method raises an exception if the ownership is not verified
    def self.verify_ownership(owner_id, material_ids)
      data = { owner_id: owner_id, materials: material_ids }
      connection.run(:post, endpoint+'/verify_ownership', data.to_json)
    end
  end

end
