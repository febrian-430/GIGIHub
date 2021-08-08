require 'rspec'
require './controllers/post_controller'

describe PostController do
    describe "#create" do
        before(:each) do
            @complete_params = {
                "user_id" => "6".to_i,
                "body" => "abced"
            }

            @post_dbl = double("Post")
            
        end
        context "when user id doesnt exist" do
            it 'returns 404 and not save' do
                allow(Post).to receive(:new).and_return(@post_dbl)
                allow(@post_dbl).to receive(:user_id).and_return(@complete_params["id"])
                allow(User).to receive(:by_id).and_return nil

                response = PostController.create(@complete_params)
                expect(response[:status]).to eq(404)
                expect(@post_dbl).not_to receive(:save)
            end
        end

        context "when an error happened during post#save" do
            it 'returns 500' do
                user_dbl = double("User")
                allow(Post).to receive(:new).and_return(@post_dbl)
                allow(@post_dbl).to receive(:user_id).and_return(@complete_params["id"])
                allow(User).to receive(:by_id).and_return(user_dbl)
                expect(@post_dbl).to receive(:save).and_return(false)

                response = PostController.create(@complete_params)
                expect(response[:status]).to eq(500)
                
            end
        end
    end

    describe "#show_by_id" do
        context "when id doesnt exist" do
            it "returns 404" do
                allow(Post).to receive(:by_id).and_return nil

                response = PostController.show_by_id({"id" => -1})
                expect(response[:status]).to eq(404)
            end
        end

        context "when id doesnt exist" do
            it "returns 200" do
                post_dbl = double("post")
                allow(Post).to receive(:by_id).and_return post_dbl

                response = PostController.show_by_id({"id" => -1})
                expect(response[:status]).to eq(200)
                expect(response[:body]).not_to be_nil
            end
        end
    end
end