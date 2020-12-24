module Aggregates
  class Pokemon
    include AggregateRoot

    InvalidPokemonStatus = Class.new(StandardError)

    def initialize(id)
      @status = :new
      @id = id
      @attributes = nil
    end

    def appear_on_the_wild(**data)
      data[:pokemon_id] ||= SecureRandom.uuid
      attributes = {
        gender: ['male', 'female', nil].sample,
        level: rand(5..10),
        attack: rand(0..99),
        defense: rand(0..99),
        speed: rand(0..99),
        experience: 0
      }
      data.merge!({ attributes: attributes })

      raise InvalidPokemonStatus if @status != :new

      apply Events::Pokemons::WildPokemonAppeared.new(data: data)
    end

    attr_reader :attributes
    attr_reader :status

    private

    def apply_wild_pokemon_appeared(event)
      @status = :wild
      @attributes = event.data.fetch(:attributes)
    end
  end
end
