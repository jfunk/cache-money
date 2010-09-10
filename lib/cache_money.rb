require 'active_support'
require 'active_support/all'
require 'active_record'

require 'cash/lock'
require 'cash/transactional'
require 'cash/write_through'
require 'cash/finders'
require 'cash/buffered'
require 'cash/index'
require 'cash/config'
require 'cash/accessor'

require 'cash/request'
require 'cash/fake'
require 'cash/local'

require 'cash/query/abstract'
require 'cash/query/select'
require 'cash/query/primary_key'
require 'cash/query/calculation'

require 'cash/util/array'
require 'cash/util/marshal'

class ActiveRecord::Base
  is_cached(:repository => $cache) if $cache

  def self.is_cached(options = {})
    unless @@global_write_cache
      include NoCash
    else
      options.assert_valid_keys(:ttl, :repository, :version)
      include Cash unless ancestors.include?(Cash)
      Cash::Config.create(self, options)
    end
  end

  def <=>(other)
    if self.id == other.id then 
      0
    else
      self.id < other.id ? -1 : 1
    end
  end
end

module Cash
  def self.included(active_record_class)
    active_record_class.class_eval do
      include Config, Accessor, WriteThrough, Finders
      extend ClassMethods
    end
  end

  module ClassMethods
    def self.extended(active_record_class)
      class << active_record_class
        alias_method_chain :transaction, :cache_transaction
      end
    end

    def transaction_with_cache_transaction(*args)
      if cache_config
        transaction_without_cache_transaction(*args) do
          repository.transaction { yield }
        end
      else
        transaction_without_cache_transaction(*args)
      end
    end

    def cacheable?(*args)
      true
    end
  end
end

module NoCash
  def self.included(active_record_class)
    active_record_class.class_eval do
      extend ClassMethods
    end
  end
  module ClassMethods
    def cachable?(*args)
      false
    end
  end
end

module CacheMoney
  def self.init(servers, options)
    require 'memcache'
    
    options[:logger] = Rails.logger if defined?(Rails) && Rails.logger
    servers = 
      case servers.class.to_s
        when "String"; servers.gsub(' ', '').split(',')
        when "Array"; servers
      end
    memcache = MemCache.new(servers, options)

    local = Cash::Local.new(memcache)
    lock  = Cash::Lock.new(memcache)
    $cache = Cash::Transactional.new(local, lock)

    # allow setting up caching on a per-model basis
    Rails.logger.info "cache-money: global model caching #{options[:automatic_caching].to_s == 'false' ? 'disabled' : 'enabled'}" if defined?(Rails) && Rails.logger
    ActiveRecord::Base.class_eval do
      class_variable_set(:@@global_write_cache, !(options[:automatic_caching].to_s == 'false'))
    end
  end
end
