module SystemOccurrencesHelper
  def select(field_id, collection, text=nil, style=nil, id=nil, selected=nil)
    text = "Selecione um item..." if text.nil?
    
    collection_select(
      nil, field_id, collection,:id, 
      :name, {prompt: text, selected: selected},
      {class: "#{style} form-control select2", id: id, style: "width: 100%"}
    )
  end

  def neighborhood_by_city(city_id)
    SigimImports::Neighborhood.where(city_id: city_id)
  end

  def city_by_ceara
    SigimImports::City.by_ceara
  end

  def sigim_id_by_id(id)
    Integrations::City.find(id).sigim_id
  end

  def show_no_association(error_import)
    array = []
		error_import.import_error.each do | err |
			array.push(err["error_type"])
    end
		all_association = true
		array.each do |item|
			all_association = false if item != "association"
    end
    all_association
  end

  def total_errors
    cont = 0
    @errors_type_associations.each do | etl_errors_import |
      cont += etl_errors_import.count 
    end
    cont
  end
  
end
