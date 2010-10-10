# encoding: UTF-8
module MongoMapper
  module Plugins
    def plugins
      @plugins ||= []
    end

    def plugin(mod)
      
      # for whatever reason mod.const_defined?(:ClassMethods) fails
      # in ruby 1.9.2
      # The following substitute should work in 1.8.7 and 1.9.2
      # the constant names are converted to strings as they're
      # strings in 1.8.7 and symbols in 1.9.2!
      extend mod::ClassMethods     if mod.constants.collect {|s| s.to_s}.include?("ClassMethods")
      
      include mod::InstanceMethods if mod.const_defined?(:InstanceMethods)
      mod.configure(self)          if mod.respond_to?(:configure)
      plugins << mod
    end
  end
end
