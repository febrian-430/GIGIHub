class Parser
    def self.words_begin_with(marker, str)
        words = []
        str.split(' ').each do |word|
            without_tag = word[1..(word.length-1)]
            words << without_tag if word.start_with?(marker)
        end
        words
    end
end