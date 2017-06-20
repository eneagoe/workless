require 'platform-api'

module Delayed
  module Workless
    module Scaler
      class HerokuCedar < Base
        extend Delayed::Workless::Scaler::HerokuClient

        def self.up
          client.formation.update(ENV['APP_NAME'], 'worker', {"quantity" => self.workers_needed.to_s}) if self.workers_needed > self.min_workers and self.workers < self.workers_needed
        end

        def self.down
          client.formation.update(ENV['APP_NAME'], 'worker', {"quantity" => self.min_workers.to_s}) unless self.jobs.count > 0 or self.workers == self.min_workers
        end

        def self.workers
          client.formation.info(ENV['APP_NAME'],'worker')["quantity"].to_i
        end

        # Returns the number of workers needed based on the current number of pending jobs and the settings defined by:
        #
        # ENV['WORKLESS_WORKERS_RATIO']
        # ENV['WORKLESS_MAX_WORKERS']
        # ENV['WORKLESS_MIN_WORKERS']
        #
        def self.workers_needed
          [[(self.jobs.count.to_f / self.workers_ratio).ceil, self.max_workers].min, self.min_workers].max
        end

        def self.workers_ratio
          if ENV['WORKLESS_WORKERS_RATIO'].present? && (ENV['WORKLESS_WORKERS_RATIO'].to_i != 0)
            ENV['WORKLESS_WORKERS_RATIO'].to_i
          else
            100
          end
        end

        def self.max_workers
          ENV['WORKLESS_MAX_WORKERS'].present? ? ENV['WORKLESS_MAX_WORKERS'].to_i : 1
        end

        def self.min_workers
          ENV['WORKLESS_MIN_WORKERS'].present? ? ENV['WORKLESS_MIN_WORKERS'].to_i : 0
        end
      end
    end
  end
end
