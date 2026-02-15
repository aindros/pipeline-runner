require_relative 'executor'

class Runner
	attr_writer :executor
	attr_reader :name

	def initialize(config)
		@name = config["name"]
		@executor = Executor.new(config)
	end

	def execute()
		@executor.execute()
	end
end
