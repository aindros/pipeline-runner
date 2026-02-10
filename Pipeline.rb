require 'yaml'

require_relative 'Job'

class Pipeline
	attr_accessor :jobs

	def initialize(filename = '.gitlab-ci.yml')
		# @  -> Variabili di istanza
		# @@ -> Variabili di classe
		# $  -> Variabili globali
		@filename = filename
	end

	def parse
		unless File.exist?(@filename)
			puts "Error: '#{@filename}' not found."
			return
		end

		config = YAML.load_file(@filename)

		@jobs = []
		config.each do |key, value|
			job = Job.new
			@jobs << job

			job.name        = key
			job.stage       = config["#{key}"]["stage"]
			job.script      = config["#{key}"]["script"]
			job.environment = config["#{key}"]["environment"]
		end

		@jobs.each do |job|
			job.toShell
		end
	end
end
