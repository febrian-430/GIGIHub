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
        end
    end
end