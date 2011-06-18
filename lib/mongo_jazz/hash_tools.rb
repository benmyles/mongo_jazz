class MongoJazz::HashTools

  def self.hash_to_list(curr_hash, path=[])
    list = {}
    curr_hash.each do |k,v|
      if v.is_a?(Hash)
        list.merge! hash_to_list(v, (path + [k]))
      elsif v.is_a?(Array)
        v.each_with_index do |o,i|
          o_key = path + ["#{k}[#{i}]"]
          if o.is_a?(Hash)
            list.merge! hash_to_list(o, o_key)
          else
            list[o_key.join(".")] = o
          end
        end

      else
        list[(path + [k]).join(".")] = v
      end
    end
    list
  end # self.hash_to_list

end # MongoJazz::HashTools