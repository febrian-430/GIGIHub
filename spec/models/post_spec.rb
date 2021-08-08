require 'rspec'
require './models/post'

describe Post do
    describe "validation before database manipulation" do
        describe "#save?" do
            context "when post body is empty or nil" do
                it "returns false" do
                    post = Post.new({})
                    expect(post.save?).to eq(false)
                end
            end
        end
    end
end