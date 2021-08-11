require 'rspec'
require './models/comment'

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

            context "when body is not nil" do
                it "returns true" do
                    comment = Comment.new(@params)

                    expect(comment.save?).to be true
                end
            end
        end
    end
end
