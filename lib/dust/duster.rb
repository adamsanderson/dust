module Dust
  class Duster < SexpProcessor
    attr_accessor :warnings
    
    def initialize(klass, meth)
      super()
      self.auto_shift_type = true
      self.strict = false
      self.expected = Sexp
      
      @class = klass
      @method = meth
      @warnings = []
    end
    
    def dust!
      process(ParseTree.translate(@class, @method))
    end
    
    def scan_for(warning_classes, options = {})
      matched_warnings = warning_classes.map do |warning_class|
        warning_class.discover(options[:with])
      end
      
      warn *matched_warnings
    end
    
    def warn(*warnings)
      @warnings += warnings.compact
    end
    
    def process_defn(exp)
      method = exp.shift
      result = s(:defn, method)
      result << process(exp.shift) until exp.empty?

      result
    end
  end
end
