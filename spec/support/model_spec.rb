RSpec.shared_examples "a model" do
	describe '#new' do

    it 'can be instantiated with dynamic attributes' do
      material = described_class.new(name: 'pikachu', colour: 'yellow')

      expect(material.name).to eql('pikachu')
      expect(material.colour).to eql('yellow')

      material.name = 'charizard'
      material.colour = 'red'

      expect(material.name).to eql('charizard')
      expect(material.colour).to eql('red')
    end

    it 'can be instantiated with dynamic nested attributes' do
      material = described_class.new(name: 'pikachu', meta: { 'fight_wins': 11 })

      expect(material.meta).to eq({ 'fight_wins' => 11 })
    end

  end

  describe 'deserialization' do

    it 'can be have its attributes set from json' do
      json = { name: 'pikachu', colour: 'yellow'}.to_json

      material = described_class.from_json(json)

      expect(material.name).to eql('pikachu')
      expect(material.colour).to eql('yellow')
    end

  end

  describe 'serialization' do

    it 'can serialize its attributes to json' do
      json = { name: 'pikachu', colour: 'yellow'}.to_json
      material = described_class.new(name: 'pikachu', colour: 'yellow')
      expect(material.to_json).to eql(json)
    end
  end

  describe '#find' do
    it 'can find a model with a given id' do
      expect(described_class.connection).to receive(:run).with(:get, described_class.endpoint+'/123', {}, {}).and_return({_id: '123'})
      m = described_class.find('123')
      expect(m).to be_instance_of(described_class)
      expect(m.id).to eq '123'
    end
  end
end