require 'yaml'

require_relative 'job'
require_relative 'stage'
require_relative 'config'

class Pipeline
	attr_accessor :jobs

	private

	def print_variables(out)
		if @variables.length == 0 then
			return
		end

		@variables.each do |key, value|
			out.puts "#{key}=\"#{value}\""
		end

		# Adding an empty line for next shell instructions
		out.puts
	end

	def put_variables(variables)
		variables.each do |key, value|
			@variables[key] = value
		end
	end

	def add_job(name, value)
		job = Job.new
		@jobs << job

		job.name        = name
		job.stage       = value["stage"]
		job.script      = value["script"]
		job.environment = value["environment"]

		if job.stage != nil && !job.stage&.empty?
			if !@stages.key?(job.stage) then
				stage = Stage.new(job.stage)
				@stages[job.stage] = stage
			end
			@stages[job.stage].jobs << job
		end
	end

	protected

	def parse_section(key, value)
		raise NotImplementedError, "#{self.class} must implement #parse_section"
	end

	def parse_pipeline(config)
		# The pipeline can be empty, so config can be too
		if config == nil then
			return
		end

		config.each do |key, value|
			parse_section(key, value)
		end
	end

	def parse_variables(config)
		raise NotImplementedError, "#{self.class} must implement #parse_stages"
	end

	public

	def initialize(filename = '.gitlab-ci.yml', _print)
		# @  -> Variabili di istanza
		# @@ -> Variabili di classe
		# $  -> Variabili globali
		@filename = filename
		@variables = {}
		@stages = {}
		@config = Config.new
		@jobs = []
		@print = _print
	end

	def parse
		unless File.exist?(@filename)
			puts "Error: '#{@filename}' not found."
			return
		end

		parse_pipeline(YAML.load_file(@filename))
	end

	def run()
		@config.runner.execute(self)
	end

	def to_shell(filename = nil)
		out =
			if filename && !@print
				File.open(filename, File::WRONLY | File::CREAT, 0755)
			else
				STDOUT
			end

		out.puts "#!/bin/sh"
		out.puts

		print_variables(out)

		@jobs.each do |job|
			job.to_shell(out)
		end

		@stages.each do |key, value|
			value.jobs.each do |job|
				out.puts "#{job.function_name} &"
			end
			out.puts "wait"
			out.puts
		end

		if out.is_a?(File)
			# Close the file and the run it
			out.close

			system(filename)
		end

		out.close if out.is_a?(File)
	end
end
