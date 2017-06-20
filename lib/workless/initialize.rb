Delayed::Worker.max_attempts = 3
Delayed::Backend::ActiveRecord::Job.send(:include, Delayed::Workless::Scaler) if defined?(Delayed::Backend::ActiveRecord::Job)
