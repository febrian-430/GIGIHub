require 'rspec'
require './controllers/user_controller'

describe UserController do
    describe '#create' do
        context 'when failing user model save validation' do
            it 'returns 400, ack false, and error message' do
                params = {
                    username: "", 
                    email: "", 
                    bio_description: ""
                }

                response = UserController.create(params)
                expect(response[:status]).to eq("400")
            end
        end
    end
end