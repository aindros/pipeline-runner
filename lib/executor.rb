require 'tempfile'
require 'securerandom'

class Executor
	private

	def execute_as_container(pipeline)
	end

	def execute_as_shell(pipeline)
		pipeline.to_shell("/tmp/pipeline-runner-#{SecureRandom.uuid}")
	end

	public

	def initialize(config)
		@type = config["executor"]
	end

	def execute(pipeline)
		case @type
		when "shell"  ; execute_as_shell(pipeline)     ;
		when "podman" ; execute_as_container(pipeline) ;
		end
	end
end
