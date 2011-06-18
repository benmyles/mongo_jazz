module MongoJazz::Mix::Validator
  class Options
    %w(with message).each do |f|
      define_method(f) do |val|
        instance_variable_set("@#{f}", val)
      end

      define_method("read_#{f}") do
        instance_variable_get("@#{f}")
      end
    end
  end

  extend ActiveSupport::Concern

  module ClassMethods
    def validate_doc(&block)
      opts = Options.new
      block.call(opts)

      @validations ||= { docs: [], fields: [] }
      @validations[:docs] << opts
    end

    def validate_field(regex, &block)
      opts = Options.new
      block.call(opts)

      @validations ||= { docs: [], fields: [] }
      @validations[:fields] << [regex, opts]
    end

    def read_validations
      @validations || { docs: [], fields: [] }
    end
  end

  module InstanceMethods
    def validate(some_doc=self.doc)
      MongoJazz::Validator.new(self.class.read_validations, some_doc).validate
    end
  end
end