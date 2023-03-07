class Integrations::City < ApplicationRecord
  include BaseIntegration

  has_many :neighborhoods

  # Scope

  def self.array_of_names(state_id)
    # Retorna array das cidades
    where(state_id: state_id).pluck(:name)
      .uniq(&:downcase).sort_by(&:downcase)
  end

  def self.new_data(source_system, name, state_id)
    find_or_create_by(
      source_system: source_system,
      name: name,
      state_id: state_id
    )
  end
  
end
