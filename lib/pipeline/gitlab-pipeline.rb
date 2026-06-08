require_relative "../pipeline"

class GitLabPipeline < Pipeline
	def parse_section(key, value)
		if key == "stages" || key.start_with?(".") then return end

		case key
		when "variables"
			put_variables(value)
		else
			add_job(key, value)
		end
	end
end
