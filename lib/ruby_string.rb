class RubyString

    KEYWORDS = %w(def class module)
    ASSIGNMENT = "="

    def self.replace_puts(code)
        code.gsub 'puts', "@stdout <<"
    end

    def initialize(code)
        @code = code
    end

    def definition_or_assignment?
        is_definition() or is_assignment()
    end

    def is_definition()
        KEYWORDS.each do |word|
            return true if @code.start_with? word
        end
        false
    end

    def is_assignment()
        @code.count(ASSIGNMENT) > @code.scan(/"([^""]*)"/).length
    end

end
