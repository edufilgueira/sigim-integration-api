class SigimImports::Neighborhood < SigimRecord
	include BaseSigim
	include Fonetical
	
	# Associations

	belongs_to :city

	# has_many :sectorials
	# has_many :facilities
	# has_many :people_addresses
	# has_many :neighborhood_communities

	# Validation
		
	validates :name, presence: true

	# Scope

  def self.by_city(id)
    where(city_id: id)
  end

end
