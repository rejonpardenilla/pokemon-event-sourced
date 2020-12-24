module Pokemons
  class OnWildPokemonAppeared
    def call(event)
      pokemon = ::Pokemon.find_or_initialize_by id: event.data.fetch(:pokemon_id)
      attributes = event.data.fetch(:attributes)
      pokemon.gender = attributes.fetch(:gender)
      pokemon.level = attributes.fetch(:level)
      pokemon.attack = attributes.fetch(:attack)
      pokemon.defense = attributes.fetch(:defense)
      pokemon.speed = attributes.fetch(:speed)
      pokemon.experience = attributes.fetch(:experience)
      pokemon.save!
    end
  end
end
