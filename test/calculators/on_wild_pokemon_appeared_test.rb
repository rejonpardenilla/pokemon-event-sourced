require 'test_helper'

class OnWildPokemonAppearedTest < ActiveSupport::TestCase
  test 'OnWildPokemonAppreared calculator should resolve properly' do
    # Given
    pokemon_id = SecureRandom.uuid
    event = Events::Pokemons::WildPokemonAppeared.new(
      data: {
        pokemon_id: pokemon_id,
        route: '11',
        attributes: {
          gender: 'female',
          level: 5,
          attack: 16,
          defense: 41,
          speed: 70,
          experience: 0
        }
      }
    )

    # When
    Pokemons::OnWildPokemonAppeared.new.call(event)

    # Then
    pokemon = Pokemon.find(pokemon_id)
    assert_equal event.data.fetch(:pokemon_id), pokemon.id
    assert_equal event.data.dig(:attributes, :level), pokemon.level
  end

  test 'OnWildPokemonAppreared calculator should be idempotent' do
    # Given
    pokemon_id = SecureRandom.uuid
    event = Events::Pokemons::WildPokemonAppeared.new(
      data: {
        pokemon_id: pokemon_id,
        route: '11',
        attributes: {
          gender: 'female',
          level: 5,
          attack: 16,
          defense: 41,
          speed: 70,
          experience: 0
        }
      }
    )

    # When
    Pokemons::OnWildPokemonAppeared.new.call(event)
    Pokemons::OnWildPokemonAppeared.new.call(event)

    # Then
    pokemon = Pokemon.find(pokemon_id)
    assert_equal event.data.fetch(:pokemon_id), pokemon.id
    assert_equal event.data.dig(:attributes, :level), pokemon.level
  end
end
