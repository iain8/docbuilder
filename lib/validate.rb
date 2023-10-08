# require 'commander'
require 'json'
require 'json_schemer'
require 'pathname'

module Validator
  def handle_validation_fail(history)
  #   Commander::Runner::say(@@validator.validate(history, { insert_property_defaults: true }).to_a.first)
  #
  #   # TODO: output error
  #   raise 'History JSON validation failed'
  end

  def load_and_validate_history(options)
    validator = JSONSchemer.schema(Pathname.new("#{Dir.pwd}/schema.json"))

    history = JSON.parse(File.read(Pathname.new("#{Dir.pwd}/#{options.data}")))

    history['email'] = options.email
    history['phone'] = options.phone
    
    return history if validator.valid?(history)

    handle_validation_fail(history)
  end
end
