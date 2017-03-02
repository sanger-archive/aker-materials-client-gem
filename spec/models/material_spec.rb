require "spec_helper"

describe MatconClient::Models::Material do

  describe '#new' do

    it 'can be instantiated with dynamic attributes' do
      material = MatconClient::Models::Material.new(name: 'pikachu', colour: 'yellow')

      expect(material.name).to eql('pikachu')
      expect(material.colour).to eql('yellow')

      material.name = 'charizard'
      material.colour = 'red'

      expect(material.name).to eql('charizard')
      expect(material.colour).to eql('red')
    end

    it 'can be instantiated with dynamic nested attributes' do
      material = MatconClient::Models::Material.new(name: 'pikachu', meta: { 'fight_wins': 11 })

      expect(material.meta).to eq({ 'fight_wins' => 11 })
    end

  end

  describe 'deserialization' do

    it 'can be have its attributes set from json' do
      json = { name: 'pikachu', colour: 'yellow'}.to_json

      material = MatconClient::Models::Material.from_json(json)

      expect(material.name).to eql('pikachu')
      expect(material.colour).to eql('yellow')
    end

  end

  describe 'serialization' do

    it 'can serialize its attributes to json' do
      json = { name: 'pikachu', colour: 'yellow'}.to_json
      material = MatconClient::Models::Material.new(name: 'pikachu', colour: 'yellow')
      expect(material.to_json).to eql(json)
    end
  end

end
