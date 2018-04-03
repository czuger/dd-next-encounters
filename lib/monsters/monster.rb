require 'json'

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
  attr_accessor :xp_value, :boss

  def initialize( challenge, name, type, source )
    set_instance_variables(binding, *local_variables)
    @key = @name.gsub( /[ -]/, '_' ).gsub( 'é', 'e' ).delete( "()'’“”" ).downcase.to_sym
    @boss = false
  end

  def to_hash
    { key: @key, challenge: @challenge, name: @name, type: @type, source: @source, xp_value: @xp_value, boss: @boss }
  end

end