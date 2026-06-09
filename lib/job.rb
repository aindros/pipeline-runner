require 'securerandom' # To generate random names for containers

class Job
	attr_reader   :name
	attr_reader   :function_name
	attr_accessor :image
	attr_accessor :services
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
		out.puts "	local commands=$(cat << 'EOF'"
		out.puts "		echo \"Executing job: #{@name} on stage: #{@stage}\""
		@script&.each do |cmd|
			out.puts "		#{cmd}"
		end
		out.puts "		echo \"Executed job: #{@name} on stage: #{@stage}\""
		out.puts "EOF"
		out.puts ")"
		out.puts ""

		if @image.nil?
			out.puts '	run_in_shell "$commands"'
		else
			prepare_containers(out)
		end

		out.puts "}"
		out.puts
	end

	private

	def prepare_containers(out)
		if @image.nil?
			return
		end

		variables = []
		commands = []

		oci = "podman"
		network_name = "#{@name}-network"

		variables << "	echo '#{network_name}' >> /tmp/networks.list"

		# First of all, generate the network
		commands << "	#{oci} network create #{network_name}"

		# Generate service containers
		service_containers = []
		@services&.each do |srv|
#			container_name = @name + "-" + (srv.sub! ':', '-')
			container_name = "#{@name}-#{SecureRandom.hex(4)}"
			commands << "	#{oci} run --privileged --network #{network_name} --name #{container_name} -d #{srv} --tls=false"
			service_containers << container_name
		end

		service_containers&.each do |c|
			variables << "	echo '#{c}' >> /tmp/containers.list"
		end

		commands << "	podman run --rm \\"
		commands << "		--network #{network_name} \\"
		commands << '		-v "$(pwd)":/workspace:Z \\'
		commands << "		-w /workspace \\"
		commands << "		#{@image} \\"
		commands << "		sh -c \"$commands\""

		# Print all statements

		variables.each do |v|
			out.puts v
		end
		out.puts

		commands.each do |c|
			out.puts c
		end
	end
end
