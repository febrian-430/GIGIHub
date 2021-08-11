require 'rspec'
require './models/comment'

describe Comment do
    describe "validation" do
        before(:each) do
            
        end
        describe "#save?" do
            context "when nil comment body" do
                it "returns false" do
                    comment = Comment.new({})

                    expect(comment.save?).to be_falsey
                end
            end

            context "when empty comment body" do
                it "returns false" do
                    comment = Comment.new({
                        "body": ""
                    })

                    expect(comment.save?).to be_falsey
                end
            end
        end
    end
end
