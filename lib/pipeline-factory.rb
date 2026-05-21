require_relative 'pipeline'

class PipelineFactory
	def self.create(filename, type)
		return type.init(filename)
	end
end
