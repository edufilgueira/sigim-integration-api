class SigimImports::State < SigimRecord
  include BaseSigim
  include Fonetical
  
  # Associations
  
  has_many :cities

  # Validation

  validates :name, presence: true

end
