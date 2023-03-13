class Integrations::SystemOccurrence < ApplicationRecord
  SOURCE_SYSTEM = %i[
    oisol
    nudem
  ].freeze

  enum type_data: %i[
    forwarding_protocol
    incident_report
    protective_measure
    lawsuit
    people
    denunciation
    legal_assistance
  ]

  enum source_system: SOURCE_SYSTEM

  # scope

  def self.last_page_source_system(source_system)
    where(source_system: source_system)
      .maximum(:last_page_loaded)
  end

  def self.etl_itens_import(source_system, limit)
    where(source_system: source_system, already_imported: false)
      .where.not(ignore: true)
      .order(:id).limit(limit)
  end

  def self.errors_imports
    where(already_imported: false)
      .where.not(import_error: nil)
  end

  def self.errors_ignored
    where(already_imported: false)
      .where(ignore: true)
      .order(:id)
  end

  def self.by_id(ids)
    where(id: ids)
  end

  def self.distinct_source_system_errors_type_create
    find_by_sql("
      SELECT DISTINCT source_system, count(*) count
      FROM 
        system_occurrences,
        jsonb_array_elements(import_error) with ordinality arr(item_object, position)
      WHERE 
        arr.item_object->>'error_type' = 'association'
        AND ignore != true
      group by source_system")
  end

  def self.errors_type_associations(source_system)
    find_by_sql("
      SELECT DISTINCT
        source_system,
        arr.item_object->'id' classfy_id,
        arr.item_object->'classfy' resource,
        arr.item_object->'error' error,
        arr.item_object->'klass_id' klass_id,
        count(*) count,
        array_agg(id) ids
      FROM 
        system_occurrences,
        jsonb_array_elements(import_error) with ordinality arr(item_object, position)
      WHERE 
        arr.item_object->>'error_type' = 'association'
        AND source_system = #{source_system}
        AND ignore != true
      GROUP BY source_system, classfy_id, resource, klass_id, error
      ORDER BY count desc ")
  end

  def self.distinct_auxiliary_data(source_system, field)
    where(source_system: source_system)
      .where.not("response->'#{field}' in ('null')")
      .distinct.select("response->'#{field}' #{field}")
  end
end
