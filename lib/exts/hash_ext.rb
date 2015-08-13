class Hash
  
  if !Hash.instance_methods.include?(:transform_keys)
    def transform_keys
      return enum_for(:transform_keys) unless block_given?
      result = self.class.new
      each_key do |key|
        result[yield(key)] = self[key]
      end
      result
    end
  end

  if !Hash.instance_methods.include?(:stringify_keys)
    def stringify_keys
      transform_keys{ |key| key.to_s }
    end
  end
end 
