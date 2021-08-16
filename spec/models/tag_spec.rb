require 'rspec'
require './models/tag'
require './db/mysql'
require './exceptions/not_found'



describe Tag do
    describe "where collaborates with post object" do
        # describe "#bulk_insert!" do
        #     context "when given empty array of string" do
        #         it "should return 0" do
        #             rows = Tag.bulk_insert!([])
        #             expect(rows).to eq(0)
        #         end
        #     end

        #     context "when given non empty array of string" do
        #         it "should return the actual number of rows inserted" do
                    
        #             mock_db = double("DB Client")

        #             allow(MySQLDB).to receive(:client).and_return(mock_db)
        #             allow(mock_db).to receive(:affected_rows).and_return(1)
        #             expect(mock_db).to receive(:query).with("INSERT IGNORE INTO tags(name) VALUES('abc'),('def')")

        #             rows = Tag.bulk_insert!(['abc', 'def'])
        #             expect(rows).to eq(1)
        #         end
        #     end
        # end

        # describe "#link_tags_to_post!" do
        #     context "when given empty array of string" do
        #         it "should return 0" do
        #             rows = Tag.link_tags_to_post!('1', [])
        #             expect(rows).to eq(0)
        #         end
        #     end

        #     context "when given non empty array of string" do
        #         it "should return the actual number of rows inserted" do
                    
        #             mock_db = double("DB Client")
        #             tags = ['abc', 'def']
        #             post_id = 1
        #             allow(MySQLDB).to receive(:client).and_return(mock_db)
        #             allow(mock_db).to receive(:affected_rows).and_return(1)
        #             allow(Tag).to receive(:bulk_insert!).and_return(0)

        #             expect(mock_db).to receive(:query).with(
        #             "INSERT IGNORE INTO tags(post_id, tag_id)
        #     SELECT #{post_id}, id
        #     FROM tags
        #     WHERE name IN (#{tags.join(',')})")

        #             rows = Tag.link_tags_to_post!(post_id, tags)
        #             expect(rows).to eq(1)
        #         end
        #     end
        # end

        describe "#insert_post_tags" do
            context "when post id doesnt exist" do
                it "should return false" do
                    allow(Post).to receive(:by_id).and_return(nil)

                    expect { Tag.insert_post_tags(-1, []) }.to raise_error(NotFoundError)
                end
            end

            context "when post id exists and empty array for tags" do
                it "should return true but call link method" do
                    post_dbl = double("post")
                    allow(Post).to receive(:by_id).and_return(post_dbl)
                    
                    expect(Tag.insert_post_tags(1, [])).to eq(true)
                    expect(Tag).not_to receive(:link_tags_to_post!)
                end
            end

            context "when post id exists and empty array for tags" do
                it "should return true and call link method" do
                    post_id = 1
                    tags = ["gigih"]
                    post_dbl = double("post")
                    allow(Post).to receive(:by_id).and_return(post_dbl)
                    allow(post_dbl).to receive(:id).and_return(post_id)
                    allow(Tag).to receive(:link_tags_to_post!).and_return(0)

                    expect(Tag).to receive(:link_tags_to_post!)
                    expect(Tag.insert_post_tags(post_id, tags)).to eq(true)
                end
            end
        end

        describe "#insert_comment_tags" do
            before(:each) do
                @mock_db = double("db")
                allow(MySQLDB).to receive(:client).and_return(@mock_db)
            end
            context "when empty array of tags" do
                it "returns 0" do
                    allow(Tag).to receive(:bulk_insert!)

                    expect(Tag).not_to receive(:bulk_insert!)
                    expect(@mock_db).not_to receive(:query)
                    expect(Tag.insert_comment_tags(-1, [])).to eq(0)
                end
            end

            context "when non empty array for tags" do
                it "should return true and call link method" do
                    comment_id = 1
                    tags = ["gigih"]

                    allow(Tag).to receive(:bulk_insert!)
                    allow(@mock_db).to receive(:query)

                    expect(Tag.insert_comment_tags(comment_id, tags)).to eq(true)
                end
            end
        end
    end

    describe "fetch" do
        before(:each) do
            @mock_db = double("mock db")
            allow(MySQLDB).to receive(:client).and_return(@mock_db)
        end

        describe "#by_post" do
            context "when post_id doesnt exist" do
                it "raises not found error" do
                    allow(Post).to receive(:by_id_exists?).and_return(false)

                    expect { Tag.by_post(-1) }.to raise_error(NotFoundError)
                end
            end

            context "when post_id exists" do
                it "returns array of tags" do
                    post_dbl = double("post")
                    mock_result = double("mock result")
                    allow(Post).to receive(:by_id_exists?).and_return(post_dbl)
                    allow(@mock_db).to receive(:query).and_return(mock_result)

                    expect(Tag).to receive(:bind).with(mock_result)
                    Tag.by_post(1)
                end
            end
        end

        describe "#top" do
            it "returns top tags within the last 24h" do
                mock_result = double("mock result")
                mock_data = double("database data")
                allow(@mock_db).to receive(:query).and_return(mock_result)
                allow(mock_result).to receive(:each).and_return(mock_data)
                
                expect(Tag).to receive(:bind).with(mock_data)
                Tag.top(5)                                                                             
            end
        end
    end
end