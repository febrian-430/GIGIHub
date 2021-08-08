require 'rspec'
require './models/tag'
require './db/mysql'

describe Tag do
    describe "where collaborates with post object" do
        describe "#bulk_insert!" do
            context "when given empty array of string" do
                it "should return 0" do
                    rows = Tag.bulk_insert!([])
                    expect(rows).to eq(0)
                end
            end

            context "when given empty array of string" do
                it "should return the actual number of rows inserted" do
                    
                    mock_db = double("DB Client")

                    allow(MySQLDB).to receive(:client).and_return(mock_db)
                    allow(mock_db).to receive(:affected_rows).and_return(1)
                    expect(mock_db).to receive(:query).with("INSERT IGNORE INTO tags(name) VALUES('abc'),('def')")

                    rows = Tag.bulk_insert!(['abc', 'def'])
                    expect(rows).to eq(1)
                end
            end
        end
    end
end