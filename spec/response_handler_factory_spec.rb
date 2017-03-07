require 'spec_helper'

describe MatconClient::ResponseHandlerFactory do

  let(:model) { double('Model', new: model_instance ) }
  let(:model_instance) { double('Model instance') }
  let(:response_handler) { MatconClient::ResponseHandlerFactory.new(model: model) }

  let(:response) do
    {
        "_updated": "Mon, 23 Jan 2017 09:53:00 GMT",
        "gender": "male",
        "_links": {
            "self": {
                "href": "materials/a341279d-7dde-472a-9b74-bb2612ee9977",
                "title": "Material"
            },
            "collection": {
                "href": "materials",
                "title": "materials"
            },
            "parent": {
                "href": "/",
                "title": "home"
            }
        },
        "donor_id": "asdf",
        "phenotype": "asdf",
        "supplier_name": "asdf",
        "common_name": "asdf",
        "_created": "Mon, 23 Jan 2017 09:53:00 GMT",
        "_id": "a341279d-7dde-472a-9b74-bb2612ee9977"
    }
  end

  let(:response_with_items) do
    {
        "_items": [
            {
                "_updated": "Mon, 23 Jan 2017 09:53:00 GMT",
                "gender": "male",
                "_links": {
                    "self": {
                        "href": "materials/a341279d-7dde-472a-9b74-bb2612ee9977",
                        "title": "Material"
                    }
                },
                "donor_id": "asdf",
                "phenotype": "asdf",
                "supplier_name": "asdf",
                "common_name": "asdf",
                "_created": "Mon, 23 Jan 2017 09:53:00 GMT",
                "_id": "a341279d-7dde-472a-9b74-bb2612ee9977"
            },
            {
                "_updated": "Mon, 30 Jan 2017 15:33:12 GMT",
                "gender": "male",
                "_links": {
                    "self": {
                        "href": "materials/d2eb2d4e-c772-428c-ba64-68ec87fa9741",
                        "title": "Material"
                    }
                },
                "donor_id": "sdaf",
                "phenotype": "sadf",
                "supplier_name": "adsf",
                "common_name": "sadf",
                "_created": "Mon, 30 Jan 2017 14:21:37 GMT",
                "_id": "d2eb2d4e-c772-428c-ba64-68ec87fa9741"
            }
          ],
        "_links": {
            "self": {
                "href": "materials",
                "title": "materials"
            },
            "last": {
                "href": "materials?page=3",
                "title": "last page"
            },
            "parent": {
                "href": "/",
                "title": "home"
            },
            "next": {
                "href": "materials?page=2",
                "title": "next page"
            }
        },
        "_meta": {
            "max_results": 25,
            "total": 2,
            "page": 1
        }
      }
  end

  describe '#initialize' do

    it 'accepts a model' do
      expect(response_handler.model).to eq(model)
    end

  end

  describe '#build' do

    context 'when build is passed a response with no _items' do

      it 'calls new on its model' do
        expect(model).to receive(:new).with(response)
        expect(response_handler.build(response)).to be model_instance
      end
    end

    context 'when build is passed a response with _items' do
      it 'builds a ResultSet' do
        result_set = response_handler.build(response_with_items)
        expect(result_set).to be_instance_of MatconClient::ResultSet
      end
    end

  end

end