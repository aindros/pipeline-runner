class PipelineType
	attr_reader :filename
	attr_reader :name

	private_class_method :new

	def initialize(filename, name, _class)
		@filename = filename.freeze
		@name     = name.freeze
		@_class   = _class.freeze
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
		return Pipeline.new(filename)
	end

	GITLAB    = new(".gitlab-ci.yml",   "gitlab", "GitLabPipeline")
	AZURE     = new("azure.yaml",       "azure",  "AzurePipeline" )
	DEFAULT   = GITLAB
end
