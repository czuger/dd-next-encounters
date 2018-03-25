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

  attr_reader :challenge, :name, :type, :source, :key, :groups
  attr_accessor :xp_value, :boss

  def initialize( challenge, name, type, source )
    set_instance_variables(binding, *local_variables)
    @key = @name.gsub( /[ -]/, '_' ).gsub( 'é', 'e' ).delete( "()'’“”" ).downcase.to_sym
    @groups = []
    @accepted_bosses = []
    @boss = false
  end

  def add_groups( monsters_or_groups )
    monsters_or_groups.each do ||

  end
    @groups ||= []
    @groups += groups
  end

  def add_

end