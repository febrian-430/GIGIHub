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
        end
    end
end