require 'rspec'
require_relative '../../models/user'
require './db/mysql'

describe User do
    before(:each) do
        @insert_ready_user = User.new(username: 'test', email: 'test@test.com')
        @empty_user = User.new
        @update_ready_user = User.new(id: 1, username: 'test', email: 'test@test.com', bio_description: 'asdasdad')
    end
    describe "validation before manipulating database" do
        describe "#save?" do
            context "when user fields are empty" do
                it "should return false" do
                    expect(@empty_user.save?).to be_falsey
                end
            end

            context "when username and email is not nil neither empty" do
                it "should return true" do
                    expect(@insert_ready_user.save?).to eq(true)
                end
            end
        end

        describe "#update?" do
            context "when user fields are empty" do
                it "should return false" do
                    expect(@empty_user.update?).to be_falsey
                end
            end

            context "when id is nil" do
                it "should return false" do
                    @update_ready_user.id = nil
                    expect(@update_ready_user.update?).to eq(false)
                end
            end

            context "when id, username, email are not nil nor empty" do
                it "should return true" do
                    expect(@update_ready_user.update?).to eq(true)
                end
            end
        end
    end

    describe "manipulates the database state" do
        before(:each) do
            @mock_db = double
            allow(MySQLDB).to receive(:client).and_return(@mock_db)
        end

        describe "#save" do
            context "when user passes validation" do
                it "should call the database" do
                    allow(@insert_ready_user).to receive(:save?).and_return(true)
                    allow(@mock_db).to receive(:last_id).and_return(1)
                    expect(@mock_db).to receive(:query)
                    
                    expect(@insert_ready_user.save).to eq(1)
                end
            end

            context "when user doesn't pass validation" do
                it "should not insert to database" do
                    allow(@insert_ready_user).to receive(:save?).and_return(false)
                    expect(@mock_db).not_to receive(:query)
                    
                    expect(@insert_ready_user.save).to eq(false)
                end
            end
        end

        describe "#update" do
            context "when user passes validation" do
                it "should call the database" do
                    allow(@update_ready_user).to receive(:update?).and_return(true)
                    expect(@mock_db).to receive(:query)
                    expect(@update_ready_user.update).to eq(true)
                end
            end
        end
    end
end