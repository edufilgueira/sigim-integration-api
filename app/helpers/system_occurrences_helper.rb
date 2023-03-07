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
end