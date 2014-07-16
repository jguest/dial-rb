require_relative 'eval_context'
require_relative '../lib/ruby_string'

class Evaluator

    DIR = "sessions/"

    def self.with(number)
        self.new(number)
    end

    def initialize(number)
        @number = number[1..-1]
        @filename = "#{DIR}#{@number}.rb"
        @mobile_filename = "#{DIR}sms-#{@number}.rb"
        @context = EvalContext.new(@mobile_filename)
    end

    def store(contents)
        [@filename, @mobile_filename].each do |f|
            File.delete(f) if File.exists?(f)
        end
        File.write(@filename, contents)
    end

    def evaluate(message_body, use_context = false)
        evaluation = String.new

        begin
            evaluation << eval_for(RubyString.new(message_body), use_context).inspect
            if (!@context.stdout.empty?)
                evaluation = evaluation.gsub(@context.stdout.to_s, "")
            end

            evaluation << "nil" if evaluation.empty?
            remember(message_body) if use_context

        rescue Exception => e
            evaluation <<  e.inspect
        end

        @context.stdout_str + "=> " + evaluation
    end

    def eval_for(ruby_string, use_context)
        to_eval = ruby_string.prepare()

        if use_context
            to_eval = "#{all_files}\n#{to_eval}"
        end

        eval(to_eval, @context.get_binding)
    end

    def file()
        if File.exists?(@filename)
            File.read(@filename)
        else
            File.read(DIR + "preview.rb")
        end
    end

    def mobile_file()
        if File.exists?(@mobile_filename) then File.read(@mobile_filename) else "" end
    end

    def all_files()
        file() + "\n" + mobile_file()
    end

    def remember(message_body)
        File.open(@mobile_filename, 'a+') do |f|
            f << "#{message_body}\n"
        end
    end

end
