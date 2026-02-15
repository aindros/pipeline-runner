class Executor
	private

	def execute_as_container()
	end

	public

	def initialize(config)
		@type = config["executor"]
	end

	def execute()
		case @type
		when "podman"; execute_as_container();
		end
	end
end
