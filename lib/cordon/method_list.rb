module Cordon
  module MethodList
    def includes?(subject, method)
      method_list.has_key?([subject, method])
    end

    def wrap_methods(subject, methods, options = {})
      methods.each do |method|
        wrap_method(subject, method.to_sym, options)
      end
    end

    def wrap_method(subject, method, options = {})
      return if includes?(subject, method)  # be idempotent

      # Unbind the original method, and replace it with a wrapper that
      # decides whether to bind and call the original
      unbind_method(subject, method, options)
      subject.__cordon__wrap_method__(method)
    end

    def invoke_method(instance, subject, method, *args, &b)
      unbound_method = method_list[[subject, method]]
      unbound_method.bind(instance).call(*args, &b)
    end

  protected

    def unbind_method(subject, method, options)
      # Either of these should raise NameError if the method doesn't exist
      unbound_method = options[:class_methods] ?
        subject.method(method) :
        subject.instance_method(method)

      method_list[[subject, method]] = unbound_method
    end

    def method_list
      @method_list ||= {}
    end
  end
end
