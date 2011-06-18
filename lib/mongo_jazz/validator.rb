class MongoJazz::Validator
  attr_accessor :validations, :some_doc

  def initialize(validations, some_doc)
    @validations = validations
    @some_doc    = some_doc
  end

  def validate
    errors = []

    self.validations[:docs].each do |opts|
      unless opts.read_with.call(self.some_doc)
        errors << opts.read_message
      end
    end

    list = MongoJazz::HashTools.hash_to_list(self.some_doc)
    list.each do |k, v|
      self.validations[:fields].each do |regex, opts|
        if k =~ regex
          args = [v]
          args << self.some_doc if opts.read_with.arity > 1
          unless opts.read_with.call(*args)
            errors << [k, opts.read_message]
          end
        end # if k
      end # self.validations
    end # list.each

    errors.uniq
  end # def validate
end