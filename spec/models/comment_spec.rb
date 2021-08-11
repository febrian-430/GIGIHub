require 'rspec'
require './models/comment'
require './models/user'
require './models/post'
require './exceptions/not_found'


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
end
