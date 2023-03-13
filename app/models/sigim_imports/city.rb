class SigimImports::City < SigimRecord
	include BaseSigim
	include Fonetical

	# Associations

	belongs_to :state

	# has_many :communities
	# has_many :sectorials
	# has_many :people

	# Validation

	validates :name, presence: true

	# Scope

	def self.by_ceara
		# Cidades do Ceará
		where(state_id: 6)
	end

	def self.array_of_names(state_id)
		# Retorna array das cidades
		where(state_id: state_id).pluck(:name)
			.uniq(&:downcase).sort_by(&:downcase)
	end

	def self.fonetical(names)
    return where(state_id: 6, fonetical: names.foneticalize) if names.is_a?(String)

    resource = self
    names.each do |name|
      resource = resource.or(where("LOWER(fonetical) LIKE LOWER('%#{name}%')"))
    end
    resource
  end
	
end
