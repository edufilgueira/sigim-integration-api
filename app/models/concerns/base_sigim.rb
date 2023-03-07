module BaseSigim
  extend ActiveSupport::Concern

  included do

    # Scope
  
    def self.fonetical(names)
      return where(fonetical: names.foneticalize) if names.is_a?(String)

      resource = self
      names.each do |name|
        resource = resource.or(where("LOWER(fonetical) LIKE LOWER('%#{name}%')"))
      end
      resource
    end

  end

end