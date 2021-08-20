require 'rspec'
require 'tempfile'
require './models/post_attachment'
require './models/post'
require './utils/storage_manager'
require './db/mysql'
require './exceptions/not_found'


describe PostAttachment do
    describe "#attach_to" do
        context "when not given an object that is not a Post" do
            it "raises TypeError" do
                expect { PostAttachment.attach_to({}, [])}.to raise_error(TypeError)
            end
        end

        context "when given empty array of files" do
            it "returns 0" do
                post = Post.new({})
                # allow(post).to receive(:instance_of?).and_return(true)

                expect(PostAttachment.attach_to(post, [])).to eq(0)
            end
        end

        context "when given a post object and array of files" do
            it "returns the number of files saved" do
                post = Post.new({})
                files = [{"filename" => "test", "mimetype" => "image/png", "file" => Tempfile.new('test')}]
                mock_db = double("database")

                allow(MySQLDB).to receive(:client).and_return(mock_db)
   
                allow(PostAttachment).to receive(:store_files).with(files).and_return(files)
                allow(mock_db).to receive(:affected_rows).and_return(files.length)
                
                expect(mock_db).to receive(:query)
                expect(PostAttachment.attach_to(post, files)).to eq(files.length)
            end
        end
    end

    describe "#by_post" do
        context "when post_id doesnt exist in database" do
            it "raises NotFoundError" do
                allow(Post).to receive(:by_id_exists?).and_return(false)
                expect{PostAttachment.by_post(-1)}.to raise_error(NotFoundError)
            end
        end

        context "when post_id exists in database" do
            it "returns post attachments" do
                mock_db = double("database")
                result_dbl = double("query result")
                allow(Post).to receive(:by_id_exists?).and_return(true)
                allow(MySQLDB).to receive(:client).and_return(mock_db)
                allow(mock_db).to receive(:query).and_return(result_dbl)

                expect(PostAttachment).to receive(:bind).with(PostAttachment, result_dbl)
                PostAttachment.by_post(1)
            end
        end
    end
end