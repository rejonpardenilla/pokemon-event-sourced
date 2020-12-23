class EventGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  argument :module_name, type: :string, default: 'default'

  def create_event_file
    module_constant = module_name.camelcase.pluralize
    module_underscore = module_name.tableize
    name_constant = name.classify
    name_underscore = name.tableize.singularize

    event_content = """module Events
  module #{module_constant}
    class #{name_constant} < RailsEventStore::Event
    end
  end
end
"""
    calculator_content = """module #{module_constant}
  class On#{name_constant}
    def call(event)
      # Here goes your awesome code. Make sure to use the `event.data`.
    end
  end
end
"""

    create_file "app/domain/events/#{module_underscore}/#{name_underscore}.rb", event_content
    create_file "app/calculators/#{module_underscore}/on_#{name_underscore}.rb", calculator_content

    inject_into_file 'config/initializers/rails_event_store.rb', after: "Rails.configuration.event_store.tap do |store|\n" do
      "    store.subscribe #{module_constant}::On#{name_constant}, to: [Events::#{module_constant}::#{name_constant}]\n"
    end
  end
end
