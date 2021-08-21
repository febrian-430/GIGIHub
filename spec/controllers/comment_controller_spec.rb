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

        context "when body is more than 1000 characters" do
            it 'returns 400' do
                body = ""
                1001.times do 
                    body += "a" 
                end
                response = CommentController.create({
                    "user_id" => 1,
                    "post_id" => 2,
                    "body" => body
                })
                expect(response[:status]).to eq(400)
            end
        end

        context "when comment#save returns false" do
            it "returns 400" do
                comment = double("Comment")

                allow(Comment).to receive(:new).and_return(comment)
                allow(comment).to receive(:save).and_return(false)

                response = CommentController.create({
                    "body" => "",
                    "user_id" => "",
                    "post_id" => ""
                })

                expect(response[:status]).to eq(400)
                expect(response[:body]).not_to be_nil
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

        # context "when request contain attachment" do
        #     it "returns 201, and raw_attachment is not nil" do
        #         comment = double("Comment")

        #         allow(Comment).to receive(:new).and_return(comment)
        #         allow(comment).to receive(:save).and_return(true)

        #         response = CommentController.create({
        #             "attachment" => {
        #                 "filename" => "name",
        #                 "mimetype" => "mime"
        #             }
        #         })
        #         expect(comment.attachment).not_to be_nil
        #         expect(response[:status]).to eq(201)
        #         expect(response[:body]).not_to be_nil
        #     end
        # end
    end
end