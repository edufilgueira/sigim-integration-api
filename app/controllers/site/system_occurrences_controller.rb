class Site::SystemOccurrencesController < ApplicationController
  before_action :authenticate_user!
  layout 'site'
  def index
    @errors_imports = Integrations::SystemOccurrence.errors_imports #.page(params[:page]).per(10)
  end 
  
  def ignored
    @errors_ignoreds = Integrations::SystemOccurrence.errors_ignored #.page(params[:page]).per(10)
  end

  def authorize
    set_params_authorize
    resource = @klass.find(@classfy_id)
    resource.sigim_id  = @resource_id if !@resource_id.blank?
    resource.validated = true        if !@resource_id.blank?
    resource.validated = true if @resource_id.blank? && @validated
    resource.user_id = current_user.id
    ApplicationRecord.transaction do
      if @ignore
        resource.ignore = true
        ignore_system_occurrence_in_batch
      end
      remove_specific_error(@resource_text)
      raise ActiveRecord::Rollback unless resource.save
    end
  end

  def inconsistency
    @system_occurrences = Integrations::SystemOccurrence
      .etl_errors_import.all.page(params[:page]).per(10)
  end

  def agruped
    @errors_type_associations = Integrations::SystemOccurrence
      .errors_type_associations(params[:source_system])
  end

  def neighborhood_by_city
    @neighborhoods = SigimImports::Neighborhood.by_city(params[:city_id])
    @cont = params[:cont]
  end

  private

  def ignore_system_occurrence_in_batch
    system_occurrence_by_id.each do | system_occurrence |
      system_occurrence.ignore = true
      raise ActiveRecord::Rollback unless system_occurrence.save
    end
  end

  def remove_specific_error(resource)
    system_occurrence_by_id.each do | system_occurrence |
      system_occurrence.import_error.each do | error |
        if error["classfy"] == resource
          system_occurrence.import_error.delete(error)
          raise ActiveRecord::Rollback unless system_occurrence.save
        end
      end
    end
  end

  def set_params_authorize
    @resource_id   = params[:resource_id]
    @resource_text = params[:resource]
    @classfy_id    = params[:classfy_id]
    @validated     = to_boolean(params[:validated])
    @ignore        = to_boolean(params[:ignore])
    @klass    = "Integrations::#{@resource_text}".constantize
  end

  def system_occurrence_by_id
    Integrations::SystemOccurrence.by_id(get_ids)
  end

  def get_ids
    params[:ids].split(" ")
  end

  def to_boolean(value)
    ActiveRecord::Type::Boolean.new.cast(value)
  end

end
