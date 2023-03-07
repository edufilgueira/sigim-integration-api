class AddUsersToSystemOccurrenceAndAuxiliary < ActiveRecord::Migration[7.0]
  def change
    add_reference :system_occurrences, :user, foreign_key: true
    add_reference :breeds, :user, foreign_key: true
    add_reference :cities, :user, foreign_key: true
    add_reference :civil_statuses, :user, foreign_key: true
    add_reference :contact_types, :user, foreign_key: true
    add_reference :crime_types, :user, foreign_key: true
    add_reference :ethnicities, :user, foreign_key: true
    add_reference :gender_identities, :user, foreign_key: true
    add_reference :genders, :user, foreign_key: true
    add_reference :housing_situations, :user, foreign_key: true
    add_reference :neighborhoods, :user, foreign_key: true
    add_reference :protective_measure_types, :user, foreign_key: true
    add_reference :relationship_degrees, :user, foreign_key: true
    add_reference :scholarities, :user, foreign_key: true
    add_reference :sexual_orientations, :user, foreign_key: true
    add_reference :skin_colors, :user, foreign_key: true
    add_reference :states, :user, foreign_key: true
    add_reference :violence_motivations, :user, foreign_key: true
    add_reference :violence_types, :user, foreign_key: true
  end
end
