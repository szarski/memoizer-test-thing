module Memoizer
  def memoize
    unless method_defined? :unmemoized_call
      alias_method :unmemoized_call, :call
      prepend InstanceMethods
    end
  end

  module InstanceMethods
    def call(*args)
      key = args.map(&:hash).join('*')
      @memoized_values ||= {}
      unless @memoized_values.has_key?(key)
        @memoized_values[key] = unmemoized_call(*args)
      end
      return @memoized_values[key]
    end
  end
end
