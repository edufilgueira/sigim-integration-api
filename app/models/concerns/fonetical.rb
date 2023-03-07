module Fonetical
  extend ActiveSupport::Concern

  included do
    
    # Action

    before_create do
      set_fonetical
    end

    before_update do
      set_fonetical
    end

    def set_fonetical 
      self.fonetical = self.name.foneticalize if has_attribute?(:fonetical)
    end
  end

end