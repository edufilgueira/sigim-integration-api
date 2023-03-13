class Site::SystemOccurrencesController < ApplicationController
  before_action :authenticate_user!
  layout 'site'
  def index
    @errors_imports = Integrations::SystemOccurrence.errors_imports
  end 
  
  def ignored
    @errors_ignoreds = Integrations::SystemOccurrence.errors_ignored.page(params[:page]).per(5)
  end

  def authorize
    set_params_authorize
    ApplicationRecord.transaction do
      resource = @klass.find(@classfy_id)
      if @ignore
        resource.ignore = true
        ignore_system_occurrence_in_batch(@resource)
      else
        if !@resource_id.blank?
          resource.sigim_id  = @resource_id
          resource.validated = true
        end
        resource.validated = true if @resource_id.blank? && @validated
        remove_specific_error(@resource)
      end
      resource.user_id = current_user.id
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
    @paginate_agruped = Kaminari.paginate_array(@errors_type_associations).page(params[:page]).per(20)
  end

  def neighborhood_by_city
    @neighborhoods = SigimImports::Neighborhood.by_city(params[:city_id])
    @cont = params[:cont]
  end

  def total_errors
    errors = Integrations::SystemOccurrence.errors_type_associations(params[:source_system])
    @total_errors = 0
    errors.each { |error| @total_errors += error.count }
    @total_errors
  end

  private

  def ignore_system_occurrence_in_batch(resource)
    system_occurrence_by_id.each do | system_occurrence |
      system_occurrence.ignore = true
      ignore_error = []
      ignore_error << { reason: I18n.t("base.data_ignore.#{resource.to_s.underscore}") }
      system_occurrence.ignore_error = ignore_error
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
    @resource = params[:resource]
    @classfy_id    = params[:classfy_id]
    @validated     = to_boolean(params[:validated])
    @ignore        = to_boolean(params[:ignore])
    @klass    = "Integrations::#{@resource}".constantize
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
