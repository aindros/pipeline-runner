require_relative 'pipeline'

class PipelineFactory
	def self.create(filename, type, _print)
		return type.init(filename, _print)
	end
end
