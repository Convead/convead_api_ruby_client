class Hash
  unless Hash.instance_methods.include?(:symbolize_keys!)
    def symbolize_keys!
      keys.each do |key|
        new_key = key.to_sym rescue key
        self[new_key] = delete(key)
      end
      self
    end
  end
end