class Job
	attr_accessor :name
	attr_accessor :stage
	attr_accessor :script
	attr_accessor :environment

	def toYAML
		puts "#{@name}:"
		puts "  stage: #{@stage}"
		puts "  script:"
		@script.each do |cmd|
			puts "    - #{cmd}"
		end
		puts "  environment: #{@environment}"
	end

	def toShell
		puts @name.gsub("-", "_") + "()"
		puts "{"
		puts "	echo 'Executing job: #{@name}'"
		@script.each do |cmd|
			puts "	#{cmd}"
		end
		puts "}"
		puts
	end
end
