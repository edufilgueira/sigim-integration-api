module BaseIntegration
  extend ActiveSupport::Concern

  included do
    
    enum source_system: Integrations::SystemOccurrence::SOURCE_SYSTEM

    def self.new_data(source_system, name)
      name = name.strip unless name.nil?
      find_or_create_by(source_system: source_system, name: name) if (!name.nil? || !name.blank?) 
    end

    # Scope

    # Lista os sigim_id=(nil) e que NÃO FORAM validados
    def self.list_to_convertion
      where(sigim_id: nil, validated: false, ignore: false)
    end

    # Lista os sigim_id=(nil) e que FORAM validados
    def self.list_to_add_convertion_sigim
      where(sigim_id: nil, validated: true, ignore: false)
    end

  end

end