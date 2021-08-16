require 'rspec'
require 'tempfile'
require './models/comment_attachment'
require './models/comment'


describe CommentAttachment do
    describe "#attach_to" do
        context "when not given an object that is not a Comment" do
            it "raises TypeError" do
                expect { CommentAttachment.attach_to({}, [])}.to raise_error(TypeError)
            end
        end

        context "when given empty array of files" do
            it "returns 0" do
                comment = Comment.new({})
                # allow(post).to receive(:instance_of?).and_return(true)

                expect(CommentAttachment.attach_to(comment, [])).to eq(0)
            end
        end

        context "when given a comment object and array of files" do
            it "returns the number of files saved" do
                comment = Comment.new({})
                files = [{"filename" => "test", "mimetype" => "image/png", "file" => Tempfile.new('test')}]
                mock_db = double("database")

                allow(MySQLDB).to receive(:client).and_return(mock_db)
   
                allow(CommentAttachment).to receive(:store_files).with(files)
                allow(mock_db).to receive(:affected_rows).and_return(files.length)
                
                expect(mock_db).to receive(:query)
                expect(CommentAttachment.attach_to(comment, files)).to eq(files.length)
            end
        end
    end
end