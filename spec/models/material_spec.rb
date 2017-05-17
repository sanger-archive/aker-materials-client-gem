require "spec_helper"

describe MatconClient::Material do

  it_behaves_like "a model"

  it "has the correct endpoint" do
    expect(subject.endpoint).to eq "materials"
  end

  context "with parents" do
    let(:num_parents) { 2 }
    let(:uuids) { num_parents.times.map{ SecureRandom.uuid } }
    let(:parents) { num_parents.times.map { |i| MatconClient::Material.new(_id: uuids[i], gender: "female", parent_ids: [])} }
    let(:material1) { MatconClient::Material.new(gender: "female", parents: uuids) }
    let(:material2) { MatconClient::Material.new(gender: "female", parents: parents) }

    it "can search for parents" do
      expect(material1.parents.to_s).to eq("where={\"_id\":{\"$in\":#{parents.map(&:_id).to_json}}}")
      expect(material2.parents).to eq(parents)
    end

  end

end
