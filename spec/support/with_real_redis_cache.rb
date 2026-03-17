# frozen_string_literal: true

module WithRealRedisCache
  def self.included(rspec) # rubocop:disable Metrics/MethodLength
    rspec.around(:each, with_real_redis_cache: true) do |example|
      WithRealRedisCache.redis.flushdb
      old_cache = ::Rails.cache

      ::Rails.cache = WithRealRedisCache.redis_store
      begin
        example.run
      ensure
        WithRealRedisCache.redis.flushdb
        ::Rails.cache = old_cache
      end
    end
  end

  def self.redis
    @redis ||= RedisService.client
  end

  def self.redis_store
    @redis_store ||= ActiveSupport::Cache.lookup_store(
      :redis_cache_store,
      redis:
    )
  end
end
