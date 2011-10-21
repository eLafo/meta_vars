module MetaVars
  class MetaContainer

    attr_reader :collection
    
    def initialize
      @collection = {}
    end

    def add(meta_var, namespace)
      if namespace.nil?
        @collection[meta_var.name.to_s] = meta_var
      else
        current_level, tail = namespace.split('.', 2)
        @collection[current_level.to_s] ||= MetaContainer.new
        @collection[current_level.to_s].add(meta_var, tail)
      end
    end

    def find(namespace)
      current_level, tail = namespace.split('.', 2)
      if tail.nil?
        @collection[current_level.to_s]
      else
        @collection[current_level.to_s].present? ? @collection[current_level.to_s].find(tail) : nil
      end
    end

    def meta_vars
      @collection.keys.inject([]) do |a,k|
        case @collection[k]
          when MetaVars::MetaContainer
            a += @collection[k].meta_vars
          when MetaVars::MetaVar
            a << @collection[k]
        end
        a
      end
    end

    def vars(env)
      @collection.keys.inject([]) do |a,k|
        case @collection[k]
          when MetaVars::MetaContainer
            a += @collection[k].vars(env)
          when MetaVars::MetaVar
            a << @collection[k].to_var(env)
        end
      end
    end

    def to_hash
      @collection.keys.inject({}) do |h,k|
        if @collection[k].is_a?(MetaVars::MetaContainer)
          h[k] = @collection[k].to_hash
        else
          h[k] = @collection[k]
        end
        h
      end
    end

  end

end