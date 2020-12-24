class CreatePokemons < ActiveRecord::Migration[6.1]
  def change
    create_table :pokemons, id: :uuid do |t|
      t.string :gender
      t.integer :level
      t.integer :attack
      t.integer :defense
      t.integer :speed
      t.string :species
      t.datetime :captured_at
      t.integer :experience

      t.timestamps
    end
  end
end
