require 'spec_helper'

describe Delayed::Workless::Scaler do

  context 'with ActiveRecord' do

    context 'locally' do

      before do
        Delayed::ActiveRecord::Job::Mock.send(:instance_variable_set, :@scaler, nil)
        ENV.delete('HEROKU_UPID')
      end

      it 'should be the local scaler' do
        Delayed::ActiveRecord::Job::Mock.scaler.should == Delayed::Workless::Scaler::Local
      end

    end

    context 'setting a scaler' do

      context 'with a known scaler' do

        before do
          Delayed::ActiveRecord::Job::Mock.scaler = :heroku_cedar
        end

        it 'should be properly assigned' do
          Delayed::ActiveRecord::Job::Mock.scaler.should == Delayed::Workless::Scaler::HerokuCedar
        end

      end

      context 'with a non-workless defined scaler' do

        before do
          class Delayed::Workless::Scaler::Something < Delayed::Workless::Scaler::Base
            def self.up
            end
            def self.down
            end
          end

          Delayed::ActiveRecord::Job::Mock.scaler = :something
        end

        it 'should be properly assigned' do
          Delayed::ActiveRecord::Job::Mock.scaler.should == Delayed::Workless::Scaler::Something
        end

      end

    end
  end
end
