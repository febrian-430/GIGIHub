require 'rspec'
require './models/comment'
require './models/user'
require './models/post'
require './exceptions/not_found'
require './db/mysql'


describe Comment do
    describe "validation" do
        before(:each) do
            @params = {
                "user_id" => "1".to_i,
                "body" => "abc",
                "post_id" => "2".to_i
            }
        end
        describe "#save?" do
            context "when nil comment body" do
                it "returns false" do
                    @params["body"] = nil
                    comment = Comment.new(@params)

                    expect(comment.save?).to be_falsey
                end
            end

            context "when empty comment body" do
                it "returns false" do
                    @params["body"] = ""
                    comment = Comment.new(@params)

                    expect(comment.save?).to be_falsey
                end
            end


            context "when user_id is nil" do
                it "returns false" do
                    @params["user_id"] = nil
                    comment = Comment.new(@params)

                    expect(comment.save?).to be_falsey
                end
            end

            context "when post_id is nil" do
                it "returns false" do
                    @params["post_id"] = nil
                    comment = Comment.new(@params)

                    expect(comment.save?).to be_falsey
                end
            end


            context "when user with user id doesnt exist in database" do
                it "raise NotFoundError" do
                    allow(User).to receive(:by_id).and_return(nil)
                    comment = Comment.new(@params)

                    expect { comment.save? }.to raise_error(NotFoundError) 
                end
            end

            context "when post with post id doesnt exist in database" do
                it "raise NotFoundError" do
                    user_dbl = double("User")
                    allow(User).to receive(:by_id).and_return(user_dbl)

                    allow(Post).to receive(:by_id).and_return(nil)
                    comment = Comment.new(@params)

                    expect { comment.save? }.to raise_error(NotFoundError)
                end
            end

            context "when body, user_id, and post_id are not nil AND user and post with given ids exist" do
                it "returns true" do
                    user_dbl = double("User")
                    allow(User).to receive(:by_id).and_return(user_dbl)
                    post_dbl = double("Post")
                    allow(Post).to receive(:by_id).and_return(post_dbl)
                    comment = Comment.new(@params)

                    expect(comment.save?).to be true
                end
            end
        end
    end

    describe "manipulates database by" do
        before(:each) do
            @mock_db = double("Database")
        end
        describe "#save" do
            context "when doesnt pass validation" do
                it "returns false" do
                    comment = Comment.new({})
                    allow(comment).to receive(:save?).and_return(false)

                    expect(comment.save).to be false
                end
            end

            context "when passes validation" do
                it "returns true" do
                    comment = Comment.new({
                        "user_id" => "1".to_i,
                        "body" => "abc",
                        "post_id" => "2".to_i
                    })
                    
                    allow(comment).to receive(:save?).and_return(true)
                    allow(MySQLDB).to receive(:client).and_return(@mock_db)
                    allow(@mock_db).to receive(:query)
                    allow(@mock_db).to receive(:last_id).and_return(1)


                    expect(comment.save).to be true
                end
            end

            context "when body contains no hashtags" do
                it "inserts tags in body and returns true" do
                    comment = Comment.new({
                        "user_id" => "1".to_i,
                        "body" => "abc",
                        "post_id" => "2".to_i
                    })
                    
                    allow(comment).to receive(:save?).and_return(true)
                    allow(MySQLDB).to receive(:client).and_return(@mock_db)
                    allow(@mock_db).to receive(:query)
                    allow(Parser).to receive(:hashtags).and_return([])
                    allow(@mock_db).to receive(:last_id).and_return(1)


                    expect(Tag).not_to receive(:insert_comment_tags)
                    expect(comment.save).to be true
                end
            end

            context "when body contains hashtags" do
                it "inserts tags in body and returns true" do
                    comment = Comment.new({
                        "user_id" => "1".to_i,
                        "body" => "abc #ab",
                        "post_id" => "2".to_i
                    })
                    
                    allow(comment).to receive(:save?).and_return(true)
                    allow(MySQLDB).to receive(:client).and_return(@mock_db)
                    allow(@mock_db).to receive(:query)
                    allow(@mock_db).to receive(:last_id).and_return(1)

                    allow(Parser).to receive(:hashtags).and_return(["#ab"])

                    expect(Tag).to receive(:insert_comment_tags).with(1, ["#ab"])
                    expect(comment.save).to be true
                end
            end

            context "when doesn't contain an attachment" do
                it "doesn't call CommentAttachment#attach_to" do
                    comment = Comment.new({
                        "user_id": 1,
                        "body" => "ha ha"
                    })

                    allow(comment).to receive(:save?).and_return(true)
                    mock_db = double
                    allow(MySQLDB).to receive(:client).and_return(mock_db)
                    allow(mock_db).to receive(:query)
                    allow(mock_db).to receive(:last_id).and_return(123)
                    
                    expect(mock_db).to receive(:last_id)
                    expect(CommentAttachment).not_to receive(:attach_to)
                    expect(comment.save).to eq(true)
                end
            end

            context "when contains an attachment" do
                it "calls CommentAttachment#attach_to" do
                    comment = Comment.new({
                        "user_id": 1,
                        "body" => "ha ha",
                        "attachment" => {
                            "filename" => "test",
                            "mimetype" => "test"
                        }
                    })
                    allow(comment).to receive(:save?).and_return(true)
                    mock_db = double
                    allow(MySQLDB).to receive(:client).and_return(mock_db)
                    allow(mock_db).to receive(:query)
                    allow(mock_db).to receive(:last_id).and_return(123)

                    expect(mock_db).to receive(:last_id)
                    expect(CommentAttachment).to receive(:attach_to)
                    expect(comment.save).to eq(true)
                end
            end
        end
    end
end
