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
    ids           = params[:ids].split(" ")
    resource_id   = params[:resource_id]
    resource_text = params[:resource]
    validated     = to_boolean(params[:validated])
    ignore        = to_boolean(params[:ignore])
    klass    = "Integrations::#{resource_text}".constantize
    resource = klass.find(params[:classfy_id])
    
    resource.sigim_id  = resource_id if !resource_id.blank?
    resource.validated = true        if !resource_id.blank?
    resource.validated = true if resource_id.blank? && validated
    resource.ignore    = true if ignore
    resource.user_id   = current_user.id
    
    remove_specific_error(resource_text, ids)
    resource.save
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
    @neighborhoods = SigimImports::Neighborhood.where(city_id:  params[:city_id])
    @cont = params[:cont]
  end

  private 

  def remove_specific_error(resource, ids)
    system_occurrences = Integrations::SystemOccurrence.where(id: ids)
    system_occurrences.each do | system_occurrence |
      system_occurrence.import_error.each do | error |
        if error["classfy"] == resource
          system_occurrence.import_error.delete(error)
          system_occurrence.save
        end
      end
    end
  end

  def to_boolean(value)
    ActiveRecord::Type::Boolean.new.cast(value)
  end
end
