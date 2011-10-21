module MetaVars
  class Var

    attr_accessor :name, :value

    def initialize(name, value)
      @name = name
      @value = value
    end
  end
end