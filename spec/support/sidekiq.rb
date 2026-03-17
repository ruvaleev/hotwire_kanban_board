# frozen_string_literal: true

require 'sidekiq/testing'

RSpec.configure do |config|
  config.before(:each, type: :worker) do
    Sidekiq::Worker.clear_all
  end

  config.before(:each, sidekiq: :inline) do
    Sidekiq::Testing.inline!
  end

  config.after(:each, sidekiq: :inline) do
    Sidekiq::Testing.fake!
  end

  config.before(:each, sidekiq: :disable) do
    Sidekiq::Testing.disable!
  end

  config.after(:each, sidekiq: :disable) do
    Sidekiq::Testing.fake!
  end
end
