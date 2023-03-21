class SigimImports::Person < SigimRecord
  include Fonetical

  # Atributos simbolicos que armazenam os dados auxiliares da Integração
  attr_accessor :old_breed,
                :old_city,
                :old_civil_status,
                :old_gender_identity,
                :old_gender,
                :old_neighborhood,
                :old_scholarity,
                :old_sexual_orientation,
                :old_housing_situation
  
  OISOL_FROM_TO = {
    "cpf"            => "cpf",
    "rg"             => "rg",
    "name"           => "nome",
    "nis"            => "nis",
    "social_name"    => "nomeSocial",
    "birth_date"     => "dataNascimento",
    "average_income" => "rendaDescricao",
    "_gender_id"             => "generoDescricao",
    "_gender_identity_id"    => "identidadeGeneroDescricao",
    "_sexual_orientation_id" => "sexualidadeDescricao",
    "_breed_id"              => "racaCorDescricao",
    "_civil_status_id"       => "estadoCivilDescricao",
    "_scholarity_id"         => "grauInstrucaoDescricao"
  }

  NUDEM_FROM_TO = {
    "cpf"             => "cpf",
    "name"            => "nome",
    "birth_date"      => "data_nascimento",
    "average_income"  => "renda_mensal",
    "number_children" => "quant_filhos",
    "_breed_id"              => "raca",
    "_scholarity_id"         => "escolaridade",
    "_sexual_orientation_id" => "orientacao_sexual",
    "_gender_identity_id"    => "identidade_genero",
    "_civil_status_id"       => "estado_civil",
    "_housing_situation_id"  => "situacao_moradia"
  }


  # Helper

  def oisol_from_to 
    self.class::OISOL_FROM_TO
  end

  def nudem_from_to 
    self.class::NUDEM_FROM_TO
  end

  
  # Scope

  def without_default_fields
    self.attributes.except!("id", "fonetical", "created_at", "updated_at")
  end
  
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
