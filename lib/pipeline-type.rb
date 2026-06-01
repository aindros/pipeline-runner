Dir[File.join(__dir__, 'pipeline', '*.rb')].each { |file| require file }

class PipelineType
	attr_reader :filename
	attr_reader :name

	private_class_method :new

	def initialize(filename, name, class_name)
		@filename   = filename.freeze
		@name       = name.freeze
		@class_name = class_name.freeze
		freeze
	end

	def self.by_filename(filename)
		if filename == nil then return GITLAB end

		if filename == GITLAB.filename then
			return GITLAB
		end

		return nil
	end

	def self.by_name(name)
		case name
		when GITLAB.name
			return GITLAB
		when AZURE.name
			return AZURE
		end
	end

	def init(filename)
		return Object.const_get(@class_name).new(filename)
	end

	GITLAB    = new(".gitlab-ci.yml",      "gitlab", "GitLabPipeline")
	AZURE     = new("azure-pipelines.yml", "azure",  "AzurePipeline" )
	DEFAULT   = GITLAB
end
