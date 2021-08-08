require 'rspec'
require './models/post'
require './models/user'


describe Post do
    describe "validation before database manipulation" do
        describe "#save?" do
            context "when post body is empty or nil" do
                it "returns false" do
                    post = Post.new({})
                    expect(post.save?).to eq(false)
                end
            end

            context "when the user id is nil" do
                it "returns false" do
                    post = Post.new({"user_id" => nil})
                    expect(post.save?).to eq(false)
                end
            end

            context "when the user id doesnt exist" do
                it "returns false" do
                    post = Post.new({"user_id" => -1})
                    
                    allow(User).to receive(:by_id).and_return(nil)
                    expect(post.save?).to eq(false)
                end
            end

            context "when has body and valid user id" do
                it "returns true" do
                    post = Post.new({
                        "body"=> "abcdefg",
                        "user_id" => 50
                    })
                end
            end
        end
    end
end