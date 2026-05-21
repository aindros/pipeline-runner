require_relative 'pipeline'

class PipelineFactory
	def self.create(filename, type)
		return Pipeline.new(filename)
	end
end
