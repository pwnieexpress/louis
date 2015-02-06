base_path = File.expand_path(File.join(File.basename(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(base_path) unless $LOAD_PATH.include?(base_path)

require 'rspec'
require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.add_filter "/spec/"
SimpleCov.add_filter do |source_file|
  source_file.lines.count < 3
end

SimpleCov.start

require 'louis'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
    mocks.verify_doubled_constant_names = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.disable_monkey_patching!
  config.warnings = true

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.profile_examples = 3
  config.order = :random

  Kernel.srand(config.seed)
end
