# require 'constructor'

class Object
  private

  def set_instance_variables(binding, *variables)
    variables.each do |var|
      instance_variable_set("@#{var}", eval(var.to_s, binding))
    end
  end

end

class Monster

  attr_reader :challenge, :name, :type, :source, :key
  attr_accessor :xp_value

  def initialize( challenge, name, type, source )
    set_instance_variables(binding, *local_variables)
    @key = @name.gsub( /[ -]/, '_' ).gsub( 'é', 'e' ).delete( "()'’“”" ).downcase.to_sym
  end

end