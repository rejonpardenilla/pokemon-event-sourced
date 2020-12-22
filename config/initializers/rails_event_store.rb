require 'rails_event_store'
require 'aggregate_root'

Rails.configuration.to_prepare do
  Rails.configuration.event_store = RailsEventStore::Client.new

  AggregateRoot.configure do |config|
    config.default_event_store = Rails.configuration.event_store
  end

  Rails.configuration.event_store.tap do |store|
  end
end
