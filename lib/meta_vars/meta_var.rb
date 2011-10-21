module MetaVars
  class MetaVar

    attr_accessor :name, :proc
    attr_reader :cache_key, :expires_in

    def initialize(name, options = {}, &block)
      @name = name
      @proc = block
      @cache_key = options[:cache_key] || "meta_vars/#{name}"
      @expires_in = options[:expires_in] || 0
    end

    def to_var(contxt)

      if @expires_in > 0
        Rails.cache.fetch(@cache_key, :expires_in => @expires_in) do
          MetaVars::Var.new(name, contxt.instance_eval(&proc))
        end
      else
        MetaVars::Var.new(name, contxt.instance_eval(&proc))
      end
    end
  end
end