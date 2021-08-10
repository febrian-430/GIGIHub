require 'rspec'
require './controllers/tag_controller'
require './models/tag'

describe TagController do
    describe "#trending_tags" do
        it "returns 200 and the result from tag#top(5) in \'tags\' field" do
            mock_result = double("model result")
            allow(Tag).to receive(:top).with(5).and_return(mock_result)
            
            response = TagController.trending_tags

            expect(response[:status]).to eq(200)
            expect(response[:body]).not_to be_nil
            expect(response[:body][:tags]).to eq(mock_result)
        end
    end
end