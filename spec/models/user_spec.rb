require 'rspec'
require_relative '../../models/user'
require './db/mysql'
require './exceptions/user_errors'

describe User do
    before(:each) do
        @insert_ready_user = User.new({"username" => 'test', "email" => 'test@test.com'})
        @empty_user = User.new({})
        @update_ready_user = User.new({"id" => 1, "username" => 'test', "email" => 'test@test.com', "bio_description" => 'asdasdad'})
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
                    allow(@insert_ready_user).to receive(:duplicate?).and_return(true)
                    expect(@insert_ready_user.save?).to eq(true)
                end
            end

            context "when "
        end

        describe "#duplicate?" do
            context "when email duplicate exists" do
                it "should raise DuplicateEmail error" do
                    allow(User).to receive(:by_email).and_return({})
                    expect { @insert_ready_user.save? }.to raise_error(UserErrors::DuplicateEmail)
                end
            end

            context "when username duplicate exists" do
                it "should raise DuplicateUsername Error" do
                    allow(User).to receive(:by_email).and_return(nil)
                    allow(User).to receive(:by_username).and_return({})

                    expect { @insert_ready_user.save? }.to raise_error(UserErrors::DuplicateUsername)
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
                    
                    expect(@insert_ready_user.save).to eq(true)
                    expect(@insert_ready_user.id).to eq(1)
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
    end

    describe "fetches data" do
        before(:each) do
            @mock_db = double
            allow(MySQLDB).to receive(:client).and_return(@mock_db)
        end

        describe "#by_username" do
            context "username doesn't exist in the database" do
                it "should return nil" do
                    mock_result = double
                    allow(@mock_db).to receive(:query).and_return(mock_result)
                    allow(mock_result).to receive(:each).and_return([])

                    expect(User.by_username("anybody")).to eq(nil)
                end
            end

            context "username exists in the database" do
                it "should return user object" do
                    array_of_user = [User.new({
                        "id" => "1",
                        "username" => "nobody",
                        "email" => "nobody@nobody.com",
                        "bio_description" => "nobody",
                        "join_date" => "28282822"
                    })]
                    mock_result = double
                    allow(@mock_db).to receive(:query).and_return(mock_result)

                    expect(User).to receive(:bind).with(User, mock_result).and_return(array_of_user)
                    expect(User.by_username("nobody").username).to eq("nobody")
                end
            end
        end

        describe "#by_id" do
            context "when id doesn't exist in the database" do
                it "should return nil" do
                    mock_result = double
                    allow(@mock_db).to receive(:query).and_return(mock_result)
                    allow(mock_result).to receive(:each).and_return([])

                    expect(User.by_id(6969)).to eq(nil)
                end
            end

            context "when id exists in the database" do
                it "should return user object" do
                    array_of_user = [User.new({
                        "id" => "1",
                        "username" => "nobody",
                        "email" => "nobody@nobody.com",
                        "bio_description" => "nobody",
                        "join_date" => "28282822"
                    })]

                    mock_result = double
                    allow(@mock_db).to receive(:query).and_return(mock_result)

                    expect(User).to receive(:bind).with(User, mock_result).and_return(array_of_user)
                    expect(User.by_id(1).id).to eq(1)
                end
            end
        end

        describe "#by_email" do
            context "when user with email doesn't exist in the database" do
                it "should return nil" do
                    mock_result = double
                    allow(@mock_db).to receive(:query).and_return(mock_result)
                    allow(mock_result).to receive(:each).and_return([])

                    expect(User.by_email("avcdef")).to eq(nil)
                end
            end

            context "when email exists in the database" do
                it "should return user object" do
                    array_of_user = [{
                        "id" => "1",
                        "username" => "nobody",
                        "email" => "nobody@nobody.com",
                        "bio_description" => "nobody",
                        "join_date" => "28282822"
                    }]

                    mock_result = double("Result")
                    allow(@mock_db).to receive(:query).and_return(mock_result)
                    allow(mock_result).to receive(:each).and_yield(array_of_user[0])

                    # expect(User).to receive(:bind).with(User, mock_result)
                    expect(User.by_email("nobody@nobody.com").email).to eq(array_of_user[0]["email"])
                end
            end
        end
    end
end