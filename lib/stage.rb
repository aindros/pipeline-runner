class Stage
	@@order = 0
	attr_accessor :name
	attr_accessor :jobs
	attr_reader   :id

	def initialize(name)
		@name = name
		@jobs = []
		@@order += 1
		@id = @@order
	end

	def add_job(job)
		@jobs << job
	end
end
