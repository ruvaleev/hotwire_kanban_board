# frozen_string_literal: true

# Insure that your .env.test config includes different redis config than production or even development.
# Otherwise every spec run will clean your redis db
RSpec.configure do |config|
  config.after(:all) do
    RedisService.client.flushall
  end
end
