class Job
	attr_reader   :name
	attr_reader   :function_name
	attr_accessor :stage
	attr_accessor :script
	attr_accessor :environment

	def name=(name)
		@name = name
		@function_name = @name.gsub("-", "_")
	end

	def toYAML
		puts "#{@name}:"
		puts "  stage: #{@stage}"
		puts "  script:"
		@script.each do |cmd|
			puts "    - #{cmd}"
		end
		puts "  environment: #{@environment}"
	end

	def to_shell(out)
		out.puts @function_name + "()"
		out.puts "{"
		out.puts "	echo 'Executing job: #{@name} on stage: #{@stage}'"
		@script&.each do |cmd|
			out.puts "	#{cmd}"
		end
		out.puts "  echo 'Executed job: #{@name} on stage: #{@stage}'"
		out.puts "}"
		out.puts
	end
end
