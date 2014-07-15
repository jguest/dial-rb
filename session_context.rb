class SessionContext

    attr_accessor :stdout

    def initialize(options)
        @number = options[:number]
        @filename = options[:filename]
        @stdout = Array.new
    end

    def get_binding
        binding()
    end

    def stdout_str
        return @stdout.join("\n") + "\n"
    end

    # methods shared by all users
    # return some kind of evaluation, message or status

    def reset()
        File.delete(@filename) if File.exists?(@filename)
        "session reset"
    end
    
    alias exit reset

end
