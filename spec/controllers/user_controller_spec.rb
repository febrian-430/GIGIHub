require 'rspec'
require './controllers/user_controller'

describe UserController do
    describe "#create" do
        context "when failing user model save validation" do
            it "returns 400, ack false, and error message" do
                params = {
                    username: "", 
                    email: "", 
                    bio_description: ""
                }
                user_double = double
                allow(User).to receive(:new).and_return(user_double)
                allow(user_double).to receive(:save).and_return(false)

                response = UserController.create(params)
                expect(response[:status]).to eq(400)
            end
        end

        # context "when saving the user succeeded" do
        #     it "returns 201, ack true, and success message" do
        #         params = {
        #             username: "I can wait forever", 
        #             email: "adada@daw", 
        #         }

        #         response = User
        #     end
        # end
    end
end