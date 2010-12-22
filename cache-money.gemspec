Gem::Specification.new do |s|
  s.name = "cache-money"
  s.version = "0.2.17"
  s.date = "2010-9-17"
  s.summary = "Write-through and Read-through Cacheing for ActiveRecord"
  s.email = "engineering@sidereel.com"
  s.homepage = "http://github.com/sidereel/cache-money"
  s.description = "Cache utilities."
  s.has_rdoc = false
  s.authors = ["SideReel Engineering"]
  s.files = [
    "README",
    "TODO",
    "UNSUPPORTED_FEATURES",
    "init.rb",
    "lib/cash/accessor.rb",
    "lib/cash/buffered.rb",
    "lib/cash/config.rb",
    "lib/cash/faks.rb",
    "lib/cash/finders.rb",
    "lib/cash/index.rb",
    "lib/cash/local.rb",
    "lib/cash/lock.rb",
    "lib/cash/mock.rb",
    "lib/cash/query/abstract.rb",
    "lib/cash/query/calculation.rb",
    "lib/cash/query/primary_key.rb",
    "lib/cash/query/select.rb",
    "lib/cash/request.rb",
    "lib/cash/transactional.rb",
    "lib/cash/util/array.rb",
    "lib/cash/util/marshal.rb",
    "lib/cash/write_through.rb",
    "lib/cache_money.rb",
    "rails/init.rb",
    "lib/mem_cached_session_store.rb",
    "lib/mem_cached_support_store.rb",
    "lib/memcached_wrapper.rb"
  ]
  s.test_files = [
    "config/environment.rb",
    "config/memcache.yml",
    "db/schema.rb",
    "spec/cash/accessor_spec.rb",
    "spec/cash/active_record_spec.rb",
    "spec/cash/calculations_spec.rb",
    "spec/cash/finders_spec.rb",
    "spec/cash/lock_spec.rb",
    "spec/cash/order_spec.rb",
    "spec/cash/transactional_spec.rb",
    "spec/cash/window_spec.rb",
    "spec/cash/write_through_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.add_dependency("activerecord", [">= 2.2.0"])
  s.add_dependency("activesupport", [">= 2.2.0"])
  s.add_dependency("memcached-northscale", [">= 0.19.5.4 "])
end
