require "minitest/autorun"
require_relative '../lib/pipeline-factory'
require_relative '../lib/pipeline-type'

class TestGitLabPipeline < Minitest::Test
	def setup
	end

	def test_empty_file
		pipeline = PipelineFactory::create("test/resources/gitlab-ci-empty.yml", PipelineType.by_name('gitlab'))
		pipeline.parse()
		pipeline.run()
	end

	def test_empty_script
		pipeline = PipelineFactory::create("test/resources/gitlab-ci-empty-script.yml", PipelineType.by_name('gitlab'))
		pipeline.parse()
		pipeline.run()
	end
end
