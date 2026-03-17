# frozen_string_literal: true

require 'webmock/rspec'

RSpec.configure do |config|
  config.before(:all) do
    WebMock.enable!
  end
end
