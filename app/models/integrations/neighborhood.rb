class Integrations::Neighborhood < ApplicationRecord
  include BaseIntegration

  belongs_to :city
  
  # Scope

  def self.new_data(source_system, name, city_id)
    find_or_create_by(
      source_system: source_system,
      name: name,
      city_id: city_id
    )
  end

end
