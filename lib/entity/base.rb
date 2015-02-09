module Entity
  class Base
    @@fields = []

    def initialize(attributes={})
      attributes.each do |key, value|
        send("#{key}=", value) if @@fields.include? key.to_sym
      end
    end

    protected
    def self.field(key)
      raise ArgumentError.new('Key must be a String, Symbol or Array') unless [String, Symbol, Array].include? key.class

      if key.is_a? Array
        key.each do |k|
          begin
            self.field k
          rescue ArgumentError
          end
        end
      else
        @@fields.push key.to_sym

        attr_accessor key.to_sym
      end
    end
  end
end
