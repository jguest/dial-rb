class RubyString

    OFF_LIMITS = %w(File IO sleep Kernal ENV sessions)
    STDOUT = %w(puts putc print printf)
    ENCAPS = %w(def class module)
    ASSIGNMENT = "="

    def initialize(code)
        @code = code.dup
    end

    def prepare()
        check_hacks()
        replace_stdout()
        @code
    end

    def replace_stdout()
        STDOUT.each do |func|
            @code = @code.gsub func, "@stdout << "
        end
    end

    def check_hacks()
        OFF_LIMITS.each do |badword|
            if @code.include? badword
                raise 'I will find you and I will kill you.'
            end
        end
    end


    # note: methods below not currently in use

    def encapsulation?
        ENCAPS.each do |word|
            return true if @code.start_with? word
        end
        false
    end

    def assignment?
        @code.count(ASSIGNMENT) > @code.scan(/"([^""]*)"/).length
    end

end
