class RubyString

    KEYWORDS = %w(def class module)
    ASSIGNMENT = "="

    def self.replace_stdout(code)
        code.gsub 'puts', "@stdout <<"
    end

    def initialize(code)
        @code = code
    end

    # TODO sanatize input ENV, File, etc.
    # TODO methods below not in use

    def definition?
        KEYWORDS.each do |word|
            return true if @code.start_with? word
        end
        false
    end

    def assignment?
        @code.count(ASSIGNMENT) > @code.scan(/"([^""]*)"/).length
    end

end
