module Entity
  class Base
    attr_reader :attributes

    def initialize(args={})
      initialize_attributes(args || {})

      set_attributes(args)
    end

    def set_attributes(args)
    end

    def attributes=(args)
      @attributes ||= {}

      args.each do |key, value|
        set_field(key, value)
      end
    end

    alias initialize_attributes attributes=

    def to_h
      {}.tap do |hash|
        fields.each do |key|
          hash[key] = send(key) unless send(key).nil?
        end
      end
    end

    alias to_hash to_h

    def self.fields
      return @fields if @fields

      @fields = parent && parent.respond_to?(:fields) ? parent.fields.dup : []

      field @fields
    end

    def fields
      self.class.fields
    end

    protected
    def self.field(key)
      raise ArgumentError.new('Fields must be a String, Symbol or Array') unless [String, Symbol, Array].include? key.class

      if key.is_a? Array
        key.each do |k|
          begin
            self.field k
          rescue ArgumentError
          end
        end
      else
        fields.push key.to_sym unless fields.include?(key.to_sym)

        attr_accessor key.to_sym
      end
    end

    def set_field(key, value)
      key = key.to_sym

      if fields.include? key
        send("#{key}=", value)
        @attributes[key] = value
      end
    end

    private
    def self.parent
      (respond_to?(:superclass) && superclass != Object) ? superclass : nil
    end
  end
end
