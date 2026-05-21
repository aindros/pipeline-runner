class PipelineType
	attr_reader :filename
	attr_reader :name

	private_class_method :new

	def initialize(filename, name)
		@filename = filename.freeze
		@name     = name.freeze
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

	GITLAB    = new(".gitlab-ci.yml",   "gitlab")
	AZURE     = new("azure.yaml",       "azure")
	DEFAULT   = GITLAB
end
