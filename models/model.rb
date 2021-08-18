class Model
    def to_json(options = {})
        hash = {}
        showable = self.instance_variable_get :@showable_variables
    
        self.instance_variables.each do |var_symbol|
            attribute = var_symbol.to_s
            attribute = attribute[1..(attribute.length-1)]
            hash[attribute] = self.instance_variable_get var_symbol if showable.include? attribute
        end 
        hash.to_json
    end
    
    def self.bind(type, arr_of_hash)
        result = []
        arr_of_hash.each do |data|
            result << type.new(data)
        end
        return result
    end
    private_class_method :bind
end
