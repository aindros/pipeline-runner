class Runner
	attr_reader :name

	def initialize(config)
		@name = config["name"]
	end
end
