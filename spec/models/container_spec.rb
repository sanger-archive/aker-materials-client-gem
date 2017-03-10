require "spec_helper"

describe MatconClient::Container do


  it_behaves_like "a model"

  it "has the correct endpoint" do
  	expect(subject.endpoint).to eq "containers"
  end

  context "when a container is initialised with slots" do
  	let (:container) do
  		MatconClient::Container.new(
  			slots: [
  				{ address: 'A:1' },
  				{ address: 'A:2', material: 'bananas' },
  				{ address: 'A:3', material: 'meringue' },
  			]
  		)
  	end

  	it "should have the given slots" do
  		slots = container.slots
  		expect(slots.length).to eql 3
  		expect(slots).to all(be_instance_of(MatconClient::Slot))
    end

    it "should have material_ids" do
    	expect(container.material_ids).to eq ['bananas', 'meringue']
	  end
  end

  describe '#materials' do

    context "when a container has multiple slots" do
      let (:container) do
        MatconClient::Container.new(
          slots: [
            { address: 'A:1' },
            { address: 'A:2', material: '234' },
            { address: 'A:3', material: '345' },
            { address: 'A:4', material: { id: '123' } },
          ]
        )
      end

      let(:result_set) {
        MatconClient::ResultSet.new(response: { _items: [ { _id: '234' }, { _id: '345' }] }, model: MatconClient::Material)
      }

      it 'returns all the materials from the slots' do
        query = { '_id': { '$in': ['234', '345'] } }.to_json

        expect(MatconClient::Material.requestor).to receive(:get)
          .with(nil, { query: 'where=' + query })
          .and_return(result_set)

        expect(container.materials).to all(be_instance_of(MatconClient::Material))
        expect(container.materials.length).to eq(3)
      end

    end

  end

end
