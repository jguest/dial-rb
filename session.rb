require_relative 'session_context'
require_relative 'lib/ruby_string'

class Session

    DIR = "sessions/"
    attr_accessor :evaluation, :file

    def self.for(number)
        self.new(number)
    end

    def initialize(number)
        @number = number[1..-1]
        @filename = "#{DIR}#{@number}.rb"
        @client = _client
        @context = SessionContext.new({
            :number => @number,
            :client => @client,
            :filename => @filename
        })
    end

    def _client
        Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']
    end

    def save(contents)
        File.delete(@filename) if File.exists?(@filename)
        File.write(@filename, contents)
        @evaluation = "code saved"
    end

    def evaluate(message_body)
        begin
            @evaluation = eval_for(message_body).inspect
            if (!@context.stdout.empty?)
                @evaluation.insert(0, @context.stdout_str + " ")
                @evaluation = @evaluation.gsub @context.stdout.to_s, ""
            end
            @evaluation << "nil" if @evaluation.empty?
        rescue Exception => e
            @evaluation = e.inspect
        end
    end

    def eval_for(message_body)
        eval_string = RubyString.replace_puts((file || "") + "\n#{message_body}")
        eval(eval_string, @context.get_binding)
    end

    def file
        return File.read(@filename) if File.exists?(@filename)
    end

    def remember(message_body)
        if RubyString.new(message_body).definition_or_assignment?
            File.open(@filename, 'a+') do |f|
                f << "\n#{message_body}"
            end
        end
    end

end
