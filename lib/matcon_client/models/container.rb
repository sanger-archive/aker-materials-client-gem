module MatconClient
  class Container < Model
    self.endpoint = 'containers'

    def serialize
      container_hash = super
      container_hash.merge!(slots: serialize_slots) if has_attribute?(:slots)
      container_hash
    end

    def slots
    	@slots ||= make_slots(super)
    end

    def material_ids
    	slots.lazy.reject(&:empty?).map(&:material_id).force
    end

    def materials
      slots_to_fetch = slots.select do |slot|
        !slot.empty? && slot.material.nil?
      end

      if (!slots_to_fetch.empty?)
        rs = MatconClient::Material.where(_id: { "$in": slots_to_fetch.map(&:material_id) }).result_set

        slots_to_fetch.each do |s|
          s.material = rs.find { |material| s.material_id == material.id }
        end
      end

      slots.select { |slot| !slot.empty? }.map(&:material)
    end

  private

    def make_slots(superslots)
    	superslots.map { |s| MatconClient::Slot.new(s) }
    end

    def serialize_slots
      slots.map(&:serialize)
    end
  end
end