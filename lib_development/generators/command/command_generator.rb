class CommandGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  argument :aggregate_name, type: :string, default: 'my_aggregate'

  def create_event_file
    aggregate_constant = aggregate_name.classify
    name_constant = name.classify
    name_underscore = name.tableize.singularize

    command_content = """module Commands
  class #{name_constant} < Command
    # Write here the command attributes
    # attribute :id, Types::UUID

    # alias :aggregate_id :id
  end
end
"""
    command_handler_content = """module CommandHandlers
  class On#{name_constant}
    include CommandHandler

    def call(command)
      # Here goes your awesome code. Make sure to call the aggregate methods.
      # with_aggregate(Aggregates::#{aggregate_constant}, command.aggregate_id) do |aggregate|
      #   aggregate.#{name_underscore}(command.data)
      # end
    end
  end
end
"""

    create_file "app/domain/commands/#{name_underscore}.rb", command_content
    create_file "app/domain/command_handlers/on_#{name_underscore}.rb", command_handler_content

    inject_into_file 'config/initializers/rails_event_store.rb', after: "Rails.configuration.command_bus.tap do |bus|\n" do
      "    bus.register(Commands::#{name_constant}, CommandHandlers::On#{name_constant}.new)\n"
    end
  end
end
