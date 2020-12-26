require 'test_helper'

class PokemonAppearOnTheWildTest < ActiveSupport::TestCase
  # Setup
  @@event_store = RailsEventStore::Client.new(
    repository: RubyEventStore::InMemoryRepository.new
  )
  @@repository = AggregateRoot::Repository.new(@@event_store)

  test 'appear_on_the_wild action should apply a WildPokemonAppeared event' do
    # Given
    @pokemon_id = SecureRandom.uuid
    @stream_name = "Pokemon$#{@pokemon_id}"
    pokemon = @@repository.load(Aggregates::Pokemon.new(@pokemon_id), @stream_name)
    pokemon_data = {
      pokemon_id: @pokemon_id,
      route: '11'
    }

    # When
    pokemon.appear_on_the_wild(**pokemon_data)
    @@repository.store(pokemon, @stream_name)

    # Then
    event = @@event_store.read
      .stream(@stream_name)
      .last
    assert_equal pokemon_data.fetch(:pokemon_id), event.data.fetch(:pokemon_id)
    assert_equal pokemon_data.fetch(:route), event.data.fetch(:route)
  end

  test 'appear_on_the_wild action should raise an exeption if pokemon already appeared' do
    # Given
    @pokemon_id = SecureRandom.uuid
    @stream_name = "Pokemon$#{@pokemon_id}"
    pokemon = @@repository.load(Aggregates::Pokemon.new(@pokemon_id), @stream_name)

    # Then
    assert_raises Aggregates::Pokemon::InvalidPokemonStatus do
      # When
      pokemon.appear_on_the_wild(pokemon_id: @pokemon_id, route: '11')
      pokemon.appear_on_the_wild(pokemon_id: @pokemon_id, route: '12')
      @@repository.store(pokemon, @stream_name)
    end
  end
end
