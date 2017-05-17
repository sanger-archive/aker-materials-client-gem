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

  end

end 