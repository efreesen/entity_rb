module Entity
  class Base
    def initialize(attributes={})
      attributes.each do |key, value|
        send("#{key}=", value) if self.class.fields.include? key.to_sym
      end
    end

    protected
    def self.fields
      @fields
    end

    def self.field(key)
      raise ArgumentError.new('Key must be a String, Symbol or Array') unless [String, Symbol, Array].include? key.class

      @fields ||= []

      p @fields

      if key.is_a? Array
        key.each do |k|
          begin
            self.field k
          rescue ArgumentError
          end
        end
      else
        @fields.push key.to_sym unless @fields.include? key.to_sym

        attr_accessor key.to_sym
      end
    end
  end
end
