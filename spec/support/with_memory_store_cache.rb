# frozen_string_literal: true

module WithMemoryStoreCache
  def self.included(rspec) # rubocop:disable Metrics/MethodLength
    rspec.around(:each, with_memory_store_cache: true) do |example|
      cache.clear
      old_cache = ::Rails.cache
      ::Rails.cache = cache

      begin
        example.run
      ensure
        cache.clear
        ::Rails.cache = old_cache
      end
    end
  end

  def cache
    @cache ||= ActiveSupport::Cache.lookup_store(:memory_store)
  end
end
