# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts 'SourceSystem >>>'
Integrations::SourceSystem.find_or_create_by(source_system: :oisol, name: 'oisol', sigim_id: 3)
Integrations::SourceSystem.find_or_create_by(source_system: :nudem, name: 'nudem', sigim_id: 4)

# puts 'Breed >>>'
# Integrations::Breed.find_or_create_by(source_system: :oisol, name: 'NÃO INFORMADO', sigim_id: 1)
# Integrations::Breed.find_or_create_by(source_system: :oisol, name: 'AMARELO', sigim_id: 2)
# Integrations::Breed.find_or_create_by(source_system: :oisol, name: 'BRANCO', sigim_id: 3)
# Integrations::Breed.find_or_create_by(source_system: :oisol, name: 'INDÍGENA', sigim_id: 4)
# Integrations::Breed.find_or_create_by(source_system: :oisol, name: 'PARDO', sigim_id: 5)
# Integrations::Breed.find_or_create_by(source_system: :oisol, name: 'PRETO', sigim_id: 6)

# puts 'CivilStatus >>>'
# Integrations::CivilStatus.find_or_create_by(source_system: :oisol, name: 'NÃO INFORMADO', sigim_id: 1)
# Integrations::CivilStatus.find_or_create_by(source_system: :oisol, name: 'CASADO(A)', sigim_id: 2)
# Integrations::CivilStatus.find_or_create_by(source_system: :oisol, name: 'DIVORCIADO(A)', sigim_id: 3)
# Integrations::CivilStatus.find_or_create_by(source_system: :oisol, name: 'UNIÃO ESTÁVEL', sigim_id: 4)
# Integrations::CivilStatus.find_or_create_by(source_system: :oisol, name: 'SEPARADO(A)', sigim_id: 5)
# Integrations::CivilStatus.find_or_create_by(source_system: :oisol, name: 'SOLTEIRO(A)', sigim_id: 6)
# Integrations::CivilStatus.find_or_create_by(source_system: :oisol, name: 'VIÚVO(A)', sigim_id: 7)

# puts 'GenderIdentity >>>'
# Integrations::GenderIdentity.find_or_create_by(source_system: :oisol, name: 'NÃO INFORMADO', sigim_id: 1)
# Integrations::GenderIdentity.find_or_create_by(source_system: :oisol, name: 'MULHER CIS', sigim_id: 2)
# Integrations::GenderIdentity.find_or_create_by(source_system: :oisol, name: 'HOMEM CIS', sigim_id: 2)
# Integrations::GenderIdentity.find_or_create_by(source_system: :oisol, name: 'HOMEM TRANS', sigim_id: 4)
# Integrations::GenderIdentity.find_or_create_by(source_system: :oisol, name: 'MULHER TRANS ', sigim_id: 4)
# Integrations::GenderIdentity.find_or_create_by(source_system: :oisol, name: 'TRAVESTI', sigim_id: 5)

# puts 'Gender >>>'
# Integrations::Gender.find_or_create_by(source_system: :oisol, name: 'NÃO INFORMADO', sigim_id: 1)
# Integrations::Gender.find_or_create_by(source_system: :oisol, name: 'FLUIDO', sigim_id: 1)
# Integrations::Gender.find_or_create_by(source_system: :oisol, name: 'FEMININO', sigim_id: 2)
# Integrations::Gender.find_or_create_by(source_system: :oisol, name: 'MASCULINO', sigim_id: 3)

# puts 'Scholarity >>>'
# Integrations::Scholarity.find_or_create_by(source_system: :oisol, name: 'NÃO INFORMADO', sigim_id: 1)
# Integrations::Scholarity.find_or_create_by(source_system: :oisol, name: 'ANALFABETO', sigim_id: 2)
# Integrations::Scholarity.find_or_create_by(source_system: :oisol, name: 'ENSINO FUNDAMENTAL - INCOMPLETO', sigim_id: 3)
# Integrations::Scholarity.find_or_create_by(source_system: :oisol, name: 'ENSINO FUNDAMENTAL - COMPLETO', sigim_id: 4)
# Integrations::Scholarity.find_or_create_by(source_system: :oisol, name: 'ENSINO MÉDIO - INCOMPLETO', sigim_id: 5)
# Integrations::Scholarity.find_or_create_by(source_system: :oisol, name: 'ENSINO MÉDIO - COMPLETO', sigim_id: 6)
# Integrations::Scholarity.find_or_create_by(source_system: :oisol, name: 'ENSINO SUPERIOR - INCOMPLETO', sigim_id: 7)
# Integrations::Scholarity.find_or_create_by(source_system: :oisol, name: 'ENSINO SUPERIOR - COMPLETO', sigim_id: 8)
# Integrations::Scholarity.find_or_create_by(source_system: :oisol, name: 'MESTRADO', sigim_id: 10)
# Integrations::Scholarity.find_or_create_by(source_system: :oisol, name: 'PÓS-GRADUAÇÃO', sigim_id: 13)
# Integrations::Scholarity.find_or_create_by(source_system: :oisol, name: 'ALFABETIZADO', sigim_id: 14)

# puts 'SexualOrientation >>>'
# Integrations::SexualOrientation.find_or_create_by(source_system: :oisol, name: 'NÃO INFORMADO', sigim_id: 1)
# Integrations::SexualOrientation.find_or_create_by(source_system: :oisol, name: 'HETERESSEXUAL', sigim_id: 2)
# Integrations::SexualOrientation.find_or_create_by(source_system: :oisol, name: 'GAY', sigim_id: 3)
# Integrations::SexualOrientation.find_or_create_by(source_system: :oisol, name: 'ASSEXUAL', sigim_id: 4)
# Integrations::SexualOrientation.find_or_create_by(source_system: :oisol, name: 'BISSEXUAL', sigim_id: 5)
# Integrations::SexualOrientation.find_or_create_by(source_system: :oisol, name: 'LÉSBICA', sigim_id: 6)
# Integrations::SexualOrientation.find_or_create_by(source_system: :oisol, name: 'PANSEXUAL', sigim_id: 7)
