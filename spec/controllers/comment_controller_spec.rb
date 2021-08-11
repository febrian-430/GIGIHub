require 'rspec'
require './controllers/comment_controller'
require './models/user'
require './exceptions/not_found'

describe CommentController do
    describe "#create" do
        context "when user_id or post_id doesnt exist in database" do
            it "returns 404, with a 'msg' field" do
                comment = double("Comment")

                allow(Comment).to receive(:new).and_return(comment)
                allow(comment).to receive(:save).and_raise(NotFoundError)

                response = CommentController.create({})
                expect(response[:status]).to eq(404)
            end
        end

        context "when database error occured" do
            it "returns 500" do
                comment = double("Comment")

                allow(Comment).to receive(:new).and_return(comment)
                allow(comment).to receive(:save).and_raise(StandardError)

                response = CommentController.create({})

                expect(response[:status]).to eq(500)
            end
        end

        context "when no error occured" do
            it "returns 201" do
                comment = double("Comment")

                allow(Comment).to receive(:new).and_return(comment)
                allow(comment).to receive(:save).and_return(true)

                response = CommentController.create({})

                expect(response[:status]).to eq(201)
                expect(response[:body]).not_to be_nil
            end
        end
    end
end