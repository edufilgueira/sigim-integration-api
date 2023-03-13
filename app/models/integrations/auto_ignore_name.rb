class Integrations::AutoIgnoreName < ApplicationRecord
  include BaseIntegration

  # Scope

  def self.array_of_names
    pluck(:name)
  end

end
