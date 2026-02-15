require 'yaml'

require_relative 'job'
require_relative 'stage'
require_relative 'config'

class Pipeline
	attr_accessor :jobs

	private

	def print_variables
		if @variables.length == 0 then
			return
		end

		@variables.each do |key, value|
			puts "#{key}=\"#{value}\""
		end

		# Adding an empty line for next shell instructions
		puts
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

	public

	def initialize(filename = '.gitlab-ci.yml')
		# @  -> Variabili di istanza
		# @@ -> Variabili di classe
		# $  -> Variabili globali
		@filename = filename
		@variables = {}
		@stages = {}
		@config = Config.new
	end

	def parse
		unless File.exist?(@filename)
			puts "Error: '#{@filename}' not found."
			return
		end

		config = YAML.load_file(@filename)

		@jobs = []
		config.each do |key, value|
			next if key == "stages" || key.start_with?(".")
			case key
			when "variables"
				put_variables(value)
			else
				add_job(key, value)
			end
		end
	end

	def to_shell
		print_variables

		@jobs.each do |job|
			job.to_shell
		end

		@stages.each do |key, value|
			value.jobs.each do |job|
				puts "#{job.function_name} &"
			end
			puts "wait"
			puts
		end
	end
end
