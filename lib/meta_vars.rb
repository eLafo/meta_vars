require 'meta_vars/version'
require 'class_level_inheritable_attributes'
require 'meta_vars/var'
require 'meta_vars/meta_var'
require 'meta_vars/meta_container'

module MetaVars
  def self.included(base)
    base.send(:include, MetaVars::ClassLevelInheritableAttributes)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def has_meta_var(name, options = {})

      default_namespace = (options[:default_namespace])
      method_name = name.to_s.singularize
      container_name = "#{name.to_s.pluralize}_container"
      inheritable = options[:inheritable]

      meta_programming = %Q(
        @#{container_name} = MetaVars::MetaContainer.new
        @default_#{method_name}_namespace = '#{default_namespace}'

        inheritable_attributes :#{container_name}, :default_#{method_name}_namespace if #{inheritable}.present?

        class << self

          attr_reader :#{container_name}
          attr_accessor :default_#{method_name}_namespace

          def #{method_name}(var_name, *namespaces, &block)
            namespaces = ['#{default_namespace}'] if namespaces.empty?
            namespaces.each do |namespace|
              @#{container_name}.add(MetaVars::MetaVar.new(var_name, &block), namespace)
            end
          end

          def find_meta_#{method_name}(var_name, namespace='#{default_namespace}')
            @#{container_name}.find([namespace,var_name].join('.'))
          end

        end

        def meta_#{method_name.pluralize}
          #{container_name}.meta_vars
        end

        def find_meta_#{method_name.pluralize}(namespace = '#{default_namespace}')
          #{container_name}.find(namespace).try(:meta_vars) || []
        end

        def find_meta_#{method_name}(var_name, namespace = '#{default_namespace}')
          #{container_name}.find([namespace, var_name].join('.'))
        end

        def #{method_name.pluralize}(contxt)
          #{container_name}.vars(contxt)
        end

        def find_#{method_name}(contxt, var_name, namespace = '#{default_namespace}')
          #{container_name}.find([namespace, var_name].join('.')).try(:to_var,contxt)
        end

        def find_#{method_name.pluralize}(contxt, namespace = '#{default_namespace}')
          #{container_name}.find(namespace).try(:vars,contxt) || []
        end

        def #{container_name}
          self.class.#{container_name}
        end

        def default_#{method_name}_namespace
          self.class.default_#{method_name}_namespace
        end
      )
      self.class_eval(meta_programming)
    end
  end
end
