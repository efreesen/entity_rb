module Entity
  class Base
    def initialize(attributes={})
      attributes.each do |key, value|
        send("#{key}=", value) if fields.include? key.to_sym
      end
    end

    def attributes
      hash = {}

      fields.each do |key|
        hash[key.to_sym] = self.send(key)
      end

      hash
    end

    def self.fields
      @fields
    end

    def fields
      self.class.fields
    end

    protected
    def self.field(key)
      raise ArgumentError.new('Key must be a String, Symbol or Array') unless [String, Symbol, Array].include? key.class

      @fields ||= []

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
  end
end
