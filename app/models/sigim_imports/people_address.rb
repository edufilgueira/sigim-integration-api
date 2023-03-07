class SigimImports::PeopleAddress < SigimRecord
	
	# Associations

	belongs_to :person
	belongs_to :neighborhood

	# Validation
    
	#validates :street_name, :street_number, :cep, presence: true

end
