require "spec_helper"

describe MatconClient do
  it "has a version number" do
    expect(MatconClient::VERSION).to_not be nil
  end
end
