require "rspec/pact/matchers"
require "sham_rack"
require "yaml"

RSpec.configure do |config|

  config.filter_run_when_matching :focus
  config.disable_monkey_patching!
  config.order = :random
  config.default_formatter = 'doc' if config.files_to_run.one?

  Kernel.srand config.seed

  config.before(:suite) do
    ShamRack.prevent_network_connections
  end

end
