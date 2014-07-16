require_relative '../user_lib/available_methods'

class EvalContext < AvailableMethods

    # this class serves as the context within which code is executed
    # it also collects any stdout from the evaluation with some hackery

    attr_accessor :stdout

    def initialize(filename)
        @filename = filename
        @stdout = Array.new
    end

    def get_binding
        binding()
    end

    def stdout_str
        return "" if @stdout.empty?
        @stdout.join("\n") + "\n"
    end

    # methods shared by all users that require file manipulation
    # return some kind of evaluation, message or status

    def reset()
        File.delete(@filename) if File.exists?(@filename)
        "session reset"
    end
    
    alias exit reset

end
