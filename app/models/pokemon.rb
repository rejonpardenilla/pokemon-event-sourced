class Pokemon < ApplicationRecord
  enum gender: {
    female: 'female',
    male: 'male'
  }

  def wild_appear
    self.create(
      gender: Pokemon.genders.keys.sample,
      level: rand(5..10),
      attack: rand(0..99),
      defense: rand(0..99),
      speed: rand(0..99),
      experience: 0,
      captured_at: nil
    )
  end

  def capture
    if rand <= 0.65
      self.update! captured_at: DateTime.now
      true
    else
      false
    end
  end

  def battle(to: nil)
    enemy = to
    did_win = rand <= 0.8
    self.add_experience!(35)
  end

  def feed(berry = nil)
    self.add_experience!(25) if rand <= 0.75
  end

  def add_experience!(amount = 10)
    self.experience = self.experiece + amount
    if self.experience >= 100
      self.level = self.level + 1
      self.experiece = self.experience - 100
    end
    self.save!
  end
end
