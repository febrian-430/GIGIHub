require 'rspec'
require './utils/parser'

describe Parser do
    describe "#words_begin_with" do
        describe "given character #" do
            context "with text 'gigih #gigih #generasi'" do
                it "returns array containing gigih and generasi" do
                    text = "gigih #gigih #generasi"
                    expected = ["gigih", "generasi"]
                    words = Parser.words_begin_with('#', text)
                    expect(words).to eq(expected)
                end
            end

            context "with the entire text is a hashtag" do
                it "returns array with one element" do
                    text = "#generasi_gigih"
                    expected = ["generasi_gigih"]
                    words = Parser.words_begin_with('#', text)
                    expect(words).to eq(expected)
                    expect(words.length).to eq(1)

                end
            end

            context "with text without a word beginning with #" do
                it "returns empty array" do
                    text = "generasi_gigih"
                    expected = []
                    words = Parser.words_begin_with('#', text)
                    expect(words).to eq(expected)
                end
            end

            context "empty text" do
                it "returns empty array" do
                    text = ""
                    expected = []
                    words = Parser.words_begin_with('#', text)
                    expect(words).to eq(expected)
                end
            end

            context "with text containing duplicate" do
                it "returns array only containing distinct values" do
                    text = "#gigih #gigih #generasi"
                    expected = ["gigih", "generasi"]
                    words = Parser.words_begin_with('#', text)
                    expect(words).to eq(expected)
                end
            end
        end
    end
end