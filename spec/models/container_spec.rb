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
        query = { '_id': { '$in': ['234', '345'] } }

        temp = double('temp')
        allow(temp).to receive(:result_set).and_return(result_set)
        expect(MatconClient::Material).to receive(:where).with(query).and_return(temp)
        
        expect(container.materials).to all(be_instance_of(MatconClient::Material))
        expect(container.materials.length).to eq(3)
      end

    end

  end

  describe '#serialize' do

    let(:container_args) do
      {
        "num_of_cols": 12,
        "barcode": "AKER-2",
        "num_of_rows": 8,
        "col_is_alpha": false,
        "print_count": 0,
        "row_is_alpha": true,
        "slots": [
          {
              "material": "d73ef189-2c2f-4892-b7fa-ea916dde23d7",
              "address": "A:1"
          },
          {
              "address": "A:2"
          }
        ]
      }
    end

    before :each do
      @container = MatconClient::Container.new(container_args)
    end

    it 'converts the Container into a Hash' do
      expect(@container.serialize).to eq(container_args.stringify_keys)
    end

    context "when updating the slots of a Container" do
      it "serializes slots" do
        @container.slots.second.material = MatconClient::Material.new(_id: "123")

        expected = container_args.deep_dup
        expected[:slots][1][:material] = "123"

        expect(@container.serialize).to eq(expected.stringify_keys)
      end
    end
  end

end
