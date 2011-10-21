# MetaVars
This gem provides you a way to declare variables which value depends on some context. You can declare these variables inside a namespace so you can access easily to them.

## Installation
    gem install meta_vars

## Based on and unaware collaborators
The idea of this gem came to me thanks to the [activenetwork's OmnitureClient gem](https://github.com/activenetwork/omniture_client "activenetwork's OmnitureClient")

There is some borrowed code from unawared coders. So thank you to

*   [acatighera](https://github.com/acatighera "acatighera github homepage")
*   [activenetwork](https://github.com/activenetwork "activenetwork github homepage")
*   [John Nunemaker](http://railstips.org/about "railstips") for his [ClassLevelInheritableAttributes solution](http://railstips.org/blog/archives/2006/11/18/class-and-instance-variables-in-ruby/ "Class and instance variables in ruby")

## Usage
###Defining meta_vars
You must include MetaVars and then declare the meta\_vars you are going to use calling the has_meta_var function passing a generic name for your meta\_vars.

      class Foo
          include MetaVars
          has_meta_var :var
      end

has\_meta\_var accepts one options hash, with these options:

* **:inheritable**

  _true_ or _false_, the meta\_vars will be inherited by subclasses

* **:default\_namespace**

  default\_namespace for vars. If not given, the default namespace will be _''_

### Methods available
Once you have done this, you will be able to call all these methods inside your class. Note that these methods are generated for the generic name 'var'.

####Class methods:

* **var(varname, *namespaces, &block)**

  It creates a new meta_var, with its name like var\_name and a block, which will be evaluated when the value is needed inside a given contxt.

* **find\_meta\_var(var\_name, namespace=default\_var\_namespace)**

  Returns the MetaVar or MetaContainer corresponding to the namespace given

####Instance methods

* **meta\_vars**

  Returns an array with all meta\_vars

* **find\_meta\_vars(namespace=default\_var\_namespace)**

  Returns the MetaVar or MetaContainer corresponding to the namespace given

* **find\_meta_var(var\_name, namespace=default\_var\_namespace)**

  The same as find\_meta\_vars, but you can specify a var name. In fact, it is the same as find\_meta\_vars("#{namespace}.#{var\_name}")

* **vars(contxt)**

  Returns an array with all meta\_vars evaluated in the given contxt. The evaluation is done by calling an instance_eval in the contxt passed of the proc in the var

* **find\_vars(contxt, namespace=default\_var\_namespace)**

  Returns an array with all meta\_vars evaluated in the given contxt, which are inside the given namespace.

* **find\_var(contxt, var\_name, namespace=default\_var\_namespace)**

  The same as find\_vars, but you can specify a var name. In fact, it is the same as find\_vars(contxt, "#{namespace}.#{var\_name}")

* **vars\_container**

  Returns the MetaContainer object which keeps all meta\_vars

* **default\_var\_namespace**

  Returns the default\_namespace given. This default\_namespace is set when declaring the meta\_vars

###Components
There are three components:

* MetaContainer
* MetaVar
* Var

####MetaContainer
It stores the meta\_vars. You should not use this class directly, but if you want to... take a look to its code ;-)

####MetaVar
The MetaVar itself.

* **name**

  Returns the name of the instance

* **proc**

  Returns the proc associated to this meta_var

* **to_var(contxt)**

  Returns a Var object, which contains the value of the meta_var resulting from evaluating its proc in the given contxt

####Var
The result of the evaluation of the MetaVar in a context. You can get this by calling the to_var method in a MetaVar instance

* **name**

  Returns the name of the var -which it's the same as the meta_var

* **value**

  Returns the value of the var

###Example

Let's create a meta_var for storing the title of the page. Since this value it's not going to be the same in every action, we can use action names as namespaces.

      class FooController
          include MetaVars

          has_meta_var :seo_var, :inheritable => true, :default_namespace => 'default'

          before_filter :get_seo_title

          seo_var :title, 'index' do
              I18n.t('seo.index.title')
          end

          seo_var :title, 'show', 'edit' do
              I18n.t("seo.#{params[:action]}.title", :foo => @foo)
          end

          seo_var :title do
              I18n.t('seo.global.title')
          end

          def get_seo_title
            @seo_title = (find\_seo_var(self, 'title', params[:action]) || find\_seo_var(self, 'title')).value
          end

      end
##### Copyright (c) 2011 Javier Lafora, released under MIT license
