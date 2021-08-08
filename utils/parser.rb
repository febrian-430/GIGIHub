require 'set'

class Parser
    def self.words_begin_with(marker, str)
        distinct = Set[]
        words = []
        str.split(' ').each do |word|
            without_tag = word[1..(word.length-1)]
            if word.start_with?(marker) && !distinct.include?(without_tag)
                words << without_tag 
                distinct << without_tag
            end
        end
        words
    end

    def self.hashtags(str)
        return words_begin_with('#', str)
    end
end