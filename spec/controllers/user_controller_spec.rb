require 'rspec'
require './controllers/user_controller'
require './exceptions/user_errors'

describe UserController do
    describe "#create" do
        before(:each) do
            @user_double = double
            allow(User).to receive(:new).and_return(@user_double)
        end
        context "when failing user model save validation" do
            it "returns 400, and error message" do
                params = {
                    username: "", 
                    email: "", 
                    bio_description: ""
                }
                
                allow(@user_double).to receive(:save).and_return(false)

                response = UserController.create(params)
                expect(response[:status]).to eq(400)
            end
        end

        context "when saving the user succeeded" do
            it "returns 201, and success message" do
                params = {
                    "username": "I can wait forever", 
                    "email": "adada@daw"
                }
                allow(@user_double).to receive(:save).and_return(true)

                response = UserController.create(params)
                expect(response[:status]).to eq(201)
            end
        end

        context "when email in the request already exists" do
            it "returns 400, and the error message" do
                allow(@user_double).to receive(:save).and_raise(UserErrors::DuplicateEmail)

                response = UserController.create({})
                expect(response[:status]).to eq(400)
            end
        end

        context "when username in the request already exists" do
            it "returns 400, and the error message" do
                allow(@user_double).to receive(:save).and_raise(UserErrors::DuplicateUsername)

                response = UserController.create({})
                expect(response[:status]).to eq(400)
            end
        end
    end

    

    describe "#show_by_username" do
        context "when given username doesnt exist" do
            it "returns 404" do
                allow(User).to receive(:by_username).and_return(nil)

                response = UserController.show_by_username({})

                expect(response[:status]).to eq(404)
            end
        end

        context "when given username exists" do
            it "returns 200 and the user data" do
                @user_dbl = double
                allow(User).to receive(:by_username).and_return(@user_dbl)

                response = UserController.show_by_username({})

                expect(response[:status]).to eq(200)
                expect(response[:body]).not_to eq(nil)

            end
        end
    end
end