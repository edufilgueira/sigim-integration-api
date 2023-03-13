class SigimImports::Person < SigimRecord
  include Fonetical

  
  # Instance scope

  def without_default_fields
    self.attributes.except!("id", "fonetical", "created_at", "updated_at")
  end

  # Scope
  
  def exists_nis?
    return SigimImports::Person.find_by(nis: self.nis)
            .present? unless (self.nis.nil? || self.nis.blank?) 
    false
  end

  def exists_cpf?
    return SigimImports::Person.find_by(cpf: self.cpf)
            .present? unless (self.cpf.nil? || self.cpf.blank?) 
    false
  end

  def exists_rg?
    return SigimImports::Person.find_by(rg: self.rg)
            .present? unless (self.rg.nil? || self.rg.blank?)
    false
  end

end
