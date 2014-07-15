require_relative 'session_context'
require_relative 'lib/ruby_string'

class Session

    DIR = "sessions/"
    attr_accessor :evaluation

    def self.for(number)
        self.new(number)
    end

    def initialize(number)
        @number = number[1..-1]
        @filename = "#{DIR}#{@number}.rb"
        @mobile_filename = "#{DIR}sms-#{@number}.rb"
        @context = SessionContext.new({
            :number => @number,
            :filename => @mobile_filename
        })
    end

    def save(contents)
        File.delete(@filename) if File.exists?(@filename)
        File.write(@filename, contents)
    end

    def evaluate(message_body, use_context = false)
        evaluation = "=> "
        begin
            evaluation << eval_for(message_body, use_context).inspect
            evaluation << "nil" if evaluation.empty?
            if (!@context.stdout.empty?)
                evaluation.insert(0, @context.stdout_str)
                evaluation = evaluation.gsub(@context.stdout.to_s, "")
            end
            remember(message_body) if use_context
        rescue Exception => e
            evaluation <<  e.inspect
        end
        evaluation
    end

    def eval_for(message_body, use_context)
        context = if use_context then all_files() else "" end
        eval_string = RubyString.replace_stdout(context + "\n#{message_body}")
        eval(eval_string, @context.get_binding)
    end

    def file()
        if File.exists?(@filename) then File.read(@filename) else "" end
    end

    def mobile_file()
        if File.exists?(@mobile_filename) then File.read(@mobile_filename) else "" end
    end

    def all_files()
        file() + "\n" + mobile_file()
    end

    def remember(message_body)
        File.open(@mobile_filename, 'a+') do |f|
            f << "\n\n#{message_body}"
        end
    end

end
