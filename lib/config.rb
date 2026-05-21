require 'toml-rb'

require_relative 'runner'

class Config
	attr_reader :runners
	attr_reader :runner

	private

	@@app_name = 'pipeline-runner'

	def add_runner(config)
		runner = Runner.new(config)
		@runners[runner.name] = runner
	end

	def init_runners(runners)
		if runners == nil
			puts "No runners configured. Exit."
			exit 1
		end

		runners.each do |runner|
			add_runner(runner)
		end
	end

	def init_default_runner(runner)
		# If no default runner is defined into the pipeline, then choose the first one.
		if runner == nil
			@runner = @runners.values[0]
			return
		end

		@runner = @runners[runner]
	end

	public

	def initialize()
		@runners = {}
		@config = "config.toml"
		context_config = ".#{@@app_name}/#{@config}"
		home_config = "~/.config/#{@@app_name}/#{@config}"
		sys_config = "/usr/local/etc/#{@@app_name}/#{@filename}"

		# Order to check:
		#   1. Context directory is where is executed pipeline-runner, so: .pipeline-runner/config.toml;
		#   2. Home directory (~/.config/pipeline-runner/config.toml)
		#   3. System directory (/usr/local/etc/pipeline-runner)
		if File.exist?(context_config)
			@config = context_config
		elsif File.exist?(home_config)
			@config = home_config
		elsif File.exist?(sys_config)
			@config = sys_config
		else
			puts "No config found. Exit."
			exit 1
		end

		data = TomlRB.load_file(@config)

		init_runners(data["runners"])
		init_default_runner(data["runner"])
	end
end
