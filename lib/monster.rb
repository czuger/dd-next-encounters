# require 'constructor'

class Monster

  attr_reader :challenge, :name, :type, :source

  def initialize( challenge, name, type, source )
    set_instance_variables(binding, *local_variables)
  end

  private

  def set_instance_variables(binding, *variables)
    variables.each do |var|
      instance_variable_set("@#{var}", eval(var.to_s, binding))
    end
  end

end