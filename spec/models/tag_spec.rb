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

                    expect(Tag.insert_post_tags(-1, [])).to eq(false)
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
    end

    describe "fetch" do
        describe "#by_post" do
            context "when post_id doesnt exist" do
                it "raises not found error" do
                    allow(Post).to receive(:by_id).and_return(nil)

                    expect { Tag.by_post(-1) }.to raise_error(NotFoundError)
                end
            end
        end
    end
end