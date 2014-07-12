class SessionContext

    APP_PHONE_NUMBER = "+18329812713"
    attr_accessor :stdout

    def initialize(options)
        @number = options[:number]
        @filename = options[:filename]
        @client = options[:client]
        @stdout = Array.new
    end

    def get_binding
        binding()
    end

    def stdout_str
        return @stdout.join(" ")
    end

    # methods shared by all users
    # return some kind of evaluation, message or status

    def reset()
        File.delete(@filename) if File.exists?(@filename)
        "session reset"
    end

    # NOTE this might be... dangerous
    def text(to_number, country_code = "+1")
        if block_given?
            value = yield
            to_number_str = "#{country_code}#{to_number}"
            @client.account.messages.create({
                :from => APP_PHONE_NUMBER,
                :to => to_number_str,
                :body => "from +#{@number}:\n\n#{value}"
            })
            return "\"#{value}\" sent to #{to_number_str}"
        end
        "no block given"
    end

end
