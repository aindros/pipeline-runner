require_relative 'pipeline-type'

class ArgumentParser
	attr_reader :filename
	attr_reader :type

	def initialize()
		@filename = retrieve_filename
		@type     = retrieve_type(@filename)
	end

	private

	def retrieve_filename
		if ARGV.length == 0 then
			return PipelineType::DEFAULT.filename
		end

		return ARGV[0]
	end

	def retrieve_type(filename)
		if ARGV.length < 1 then
			type = PipelineType.by_filename(filename)
		else
			type = PipelineType.by_name(ARGV[1])
		end

		if type == nil then
			type = PipelineType::DEFAULT
		end

		return type
	end
end
