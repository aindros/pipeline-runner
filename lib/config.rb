require 'toml-rb'

require_relative 'runner'

class Config
	private

	def add_runner(config)
		runner = Runner.new(config)
		@runners[runner.name] = runner
	end

	def init_runners(runners)
		if runners == nil
			return
		end

		runners.each do |runner|; add_runner(runner); end
	end

	public

	def initialize()
		@runners = {}
		@config = "config.toml"
		context_config = ".pipeline-parser/#{@config}"
		home_config = "~/.config/pipeline-parser/#{@config}"
		sys_config = "/usr/local/etc/pipeline-parser/#{@filename}"

		# Order to check:
		#   1. Context directory, where is executed pipeline-parser, so: .pipeline-parser/config.toml;
		#   2. Home directory (~/.config/pipeline-parser/config.toml)
		#   3. System directory (/usr/local/etc/pipeline-parser)
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
	end
end
