require 'rspec'
require_relative '../../models/user'

describe User do
    describe 'validation before manipulating database' do
        describe '#save?' do
            context 'when user fields are empty' do
                it 'should return false' do
                    user = User.new
                    
                    expect(user.save?).to be_falsey
                end
            end

            context 'when username and email is not nil or empty' do
                it 'should return true' do
                    user = User.new(username: 'test', email: 'test@test.com')

                    expect(user.save?).to eq(true)
                end
            end
        end
    end
end