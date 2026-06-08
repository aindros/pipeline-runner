require "optparse"

require_relative 'pipeline-type'

class ArgumentParser
	attr_reader :filename
	attr_reader :type
	attr_reader :print

	def initialize()
		parse_arguments
	end

	private

	def parse_arguments
		@print = false
		options = {}

		parser = OptionParser.new do |opts|
			opts.banner = "Usage: pipeline-runner [options]"

			opts.on("--type TYPE", "Pipeline type. Can be: gitlab, azure") do |v|
				@type = v
			end

			opts.on("-p", "--print", "Prints the generated shell script") do |v|
				@print = true
			end

			opts.on("-h", "--help", "Shows this help") do
				puts opts
				exit
			end
		end

    begin
      parser.parse!(ARGV)
    rescue OptionParser::MissingArgument => e
      warn e.message
      puts parser

      exit 1
    end

		set_filename
		set_type(options)
	end

	def set_filename
		@filename = ARGV.shift
    if @filename.nil?
			@filename = PipelineType::DEFAULT.filename
    end
	end

	def set_type(options)
		if @type.nil?
			@type = PipelineType.by_filename(filename)
		else
			@type = PipelineType.by_name(options[:type])
		end
	end
end
