module MongoJazz::Mix::Core
  extend ActiveSupport::Concern

  module ClassMethods
    def from_doc(doc)
      obj = new
      obj.doc = doc
      obj
    end
  end

  module InstanceMethods
    def doc=(val)
      @doc = ActiveSupport::HashWithIndifferentAccess.new(val || {})
    end

    def doc
      @doc ||= ActiveSupport::HashWithIndifferentAccess.new
    end
  end
end