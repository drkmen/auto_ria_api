require 'bundler/setup'
require 'auto_ria_api'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

RSpec.shared_examples 'success responses' do
  it { is_expected.to be_instance_of Array || Hash }
  it { is_expected.to_not be_empty }
end

RSpec.shared_examples 'success hash responses' do
  it { is_expected.to be_instance_of Hash }
  it { is_expected.to_not be_empty }
end