class JSONable
    def to_json(options = {})
        hash = {}
        showable = self.instance_variable_get :@showable_variables
        puts showable.inspect
        self.instance_variables.each do |var_symbol|
            attribute = var_symbol.to_s
            attribute = attribute[1..(attribute.length-1)]
            hash[attribute] = self.instance_variable_get var_symbol if showable.include? attribute
        end 
        hash.to_json
    end
    
    # def from_json! string
    #     JSON.load(string).each do |var, val|
    #         self.public_send var, val
    #     end
    # end
end
