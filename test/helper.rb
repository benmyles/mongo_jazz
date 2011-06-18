require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'mongo_jazz'

class Test::Unit::TestCase
end

class Customer
  EMAIL_RE    = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  EMAIL_TYPES = %w(work personal)

  include MongoJazz::Mix::Core
  include MongoJazz::Mix::Validator

  validate_doc do |v|
    v.with    lambda { |doc| doc[:jumps].is_a?(Fixnum) }
    v.message ["jumps", "is missing"]
  end

  validate_field( /^jumps$/ ) do |v|
    v.with    lambda { |field_val| field_val.is_a?(Fixnum) && field_val <= 100_000 }
    v.message 'nobody has THAT many jumps'
  end

  validate_field( /^emails\[\d+\].addr$/ ) do |v|
    v.with    lambda { |field_val| field_val =~ EMAIL_RE }
    v.message 'email is invalid'
  end

  validate_field( /^emails\[\d+\].type$/ ) do |v|
    v.with    lambda { |field_val| EMAIL_TYPES.include?(field_val) }
    v.message 'email type is invalid'
  end

end
