require 'json'

module BaseController
  extend ActiveSupport::Concern

  # Authentication

  USERNAME = :null
  PASSWORD = :null
  BASE_URL = :null
  PER_PAGE = 1
  
  # Configuration

  SOURCE_SYSTEM = :null
  COLLECTION = ""
  ETL_QUANTITY  = 100
  STATE = :null
  TABLE_IMPORTATION = []
  TABLE_IMPORTATION_EXCEPTION = [:City, :Neighborhood]


  def import(url, list)
    @last_page = 0 if list.count < per_page
    system_occurrence.transaction do
      list.each do |json|
        update_auxiliary_data(json)
        status = save(url, json, mount_params(@last_page), :people)
        raise ActiveRecord::Rollback unless status
      end
    end
  end

  def import_distinct(url, list)
    same_id = same_id?(list)
    bool = same_id
    while bool
      @last_page += 1
      collection_list = get_data(url, @last_page)
      bool = same_id?(collection_list[collection])
      import(url, collection_list[collection]) if !bool
    end
    bool
  end
  
  def save(url, json, params, type_data)
    id = json['id']
    # verificar se tem CPF. RG, NOME COMPLETO ...
    return true if exist_id_import?(id)
    return true if system_occurrence.create(
      origin_id: id,
      source_system: source_system,
      type_data: :people,
      last_page_loaded: @last_page,
      params:  mount_params(@last_page).to_s,
      url_endpoint: url,
      response: json
    )
    false
  end

  def etl_itens_import
    @ignored_names = Integrations::AutoIgnoreName.array_of_names
    @success = 0
    @failure = 0
    change_and_associate_auxiliary_data
    itens = system_occurrence.etl_itens_import(source_system, etl_quantity)
    itens.each do | data |
      save_etl(data)
    end
  end

  def save_etl(data)
    @errors = []
    person = set_new_person(data)
    return if data_ignore?(data, person)
    verify_errors(person)
    if @errors.count == 0
      execute_save_etl(data, person)
    else
      @failure += 1
      data = set_error_import_etl(data, @errors)
      data.save
    end
  end

  def auxiliary_table_map(model, name, colunm=nil, value=nil)
    hash = {source_system: source_system, name: name}
    hash[colunm] = value unless colunm.nil?
    resource = constantize("Integrations", model)
    resources = resource.where(hash)
    klass = resources.first
    if resources.count == 1
      return to_approve_or_set_error_association(model, klass)
    elsif resources.count > 1
      verify_error_duplicity(resources, model)
    else
      verify_error_create_and_null(model, name)
    end
    return resource.new
  end

  def new_person(json)
    pes = SigimImports::Person.new
    pes.send("#{source_system.to_s}_from_to").each do |k,v|
      unless k[0,1] == "_"
        pes.send("#{k}=", json[v].to_s.strip) unless is_nil_or_blank?(json[v])
      else
        model = symbolic_attribute_name(k)
        resource = auxiliary_table_map(model.to_sym, json[v])
        pes.send("#{k[1..-1]}=", resource.sigim_id)
        pes.send("old_#{model.underscore}=", resource)
      end
    end
    pes
  end

  # Auxiliary Data
    
  def change_convertion_auxiliary_data
    table_importation.each do |table|
      convertions = constantize("Integrations", table)
      convertions.list_to_convertion.each do |convertion|
        sigim_list = constantize("SigimImports", table).fonetical(convertion.name)
        # Convolution
        # if sigim_list.count == 0
        #   fonetical_array = convertion.name.foneticalize.split(" ")
        #   sigim_convolutions = constantize("SigimImports", table)
        #   sigim_convolutions.fonetical(fonetical_array).each do |item|
        #     if compare_convolution(normalize(convertion.name), normalize(item.name))
        #       convertion.update(sigim_id: item.id, validated: true)
        #     end
        #   end
        # end
        # Equality
        if sigim_list.count >= 1
          sigim_list.each do | sigim |
            if compare_feminino(convertion.name, sigim.name)
              convertion.update(sigim_id: sigim.id, validated: true)
            end
          end
        end

      end
    end
  end

  def association_sigim_convertion_auxiliary_data
    table_importation.each do |model|
      klass = constantize("Integrations", model)
      klass.list_to_add_convertion_sigim.each do |add_klass|
        attr_add = attribute_remove(add_klass)
        attr_add["source_system_id"] = source_system_sigim_id
        resource = constantize("SigimImports", model).create(attr_add)
        add_klass.update(sigim_id: resource.id)
      end
    end
  end

  # def update_auxiliary(model, field)
  #   list = system_occurrence.distinct_auxiliary_data(source_system, field)
  #   import_auxiliary_data(model, list, field)
  # end
  
  # def import_auxiliary_data(model, list, field)
  #   list.each do | item |
  #     instance = model.find_by(name: item[field.downcase].strip)
  #     model.new_data(item[field.downcase].strip, source_system) if instance.nil?
  #   end
  # end


  private

  # Ignore importation data in batch

  def data_ignore?(data, person)
    @ignore_error = []
    ignore_data_in_batch(person)
    if @ignore_error.count > 0
      data.ignore_error = @ignore_error
      data.ignore = true
      data.save 
      return true
    end
    false
  end

  def ignore_data_in_batch(person)
    set_data_ignore(:cpf) if is_nil_or_blank?(person.cpf)
    set_data_ignore(:name, @ignore_name) if auto_ignore_name?(person.name)
    table_importation.each do | model |
      ignore_auxiliary_data(model, person)
    end
  end

  def auto_ignore_name?(name)
    # return true if @ignored_names.include?(name)
    name_sem_acento = name.nil? ? [] : name.sem_acento.upcase
    @ignored_names.each do |ignore_name|
      @ignore_name = ignore_name
      return true if name_sem_acento.include?(ignore_name.sem_acento.upcase)
    end
    false
  end

  def ignore_auxiliary_data(model, person)
    attribute = model.to_s.underscore+"_id"
    field = model.to_s.underscore.downcase
    old_resource = person.send("old_#{field}")
    id = person.send(attribute) if person.has_attribute?(attribute)
    unless id.nil?
      resource = constantize("Integrations", model).find_by(sigim_id: id)
      set_data_ignore(model, old_resource.name) if (!resource.nil? && resource.ignore == true)
    else
      set_data_ignore(model, old_resource.name) if (!old_resource.nil? && old_resource.ignore == true)
    end
  end

  # Page control

  def total_pages(url)
    total_count = select_max(url)
    total_pages = (total_count / per_page)
    total_pages += 1 if (total_count % per_page).positive?
    total_pages
  end

  def last_page_source_system
    system_occurrence.last_page_source_system(source_system)
  end

  # ETL data importation
  
  def create_people_address(person_id, data)
    hash = change_fields_people_address(data)
    hash["person_id"] = person_id
    hash["neighborhood_id"] = @neighborhood_id
    people_address = SigimImports::PeopleAddress.new(hash)
    return true if people_address.save
    false
  end

  def execute_save_etl(data, person)
    ApplicationRecord.transaction do
      if person = SigimImports::Person.find_or_create_by(person.attributes)
        data = change_people_address(data, person) if @Save_address
        data.import_error     = nil
        data.already_imported = true
        data.save
        @success += 1
      else
        raise ActiveRecord::Rollback
      end
    end
  end

  def change_people_address(data, person)
    status = create_people_address(person.id, data.response)
    unless status
      msg = message_error(:address, "Error", set_msg('error_address'), data.response)
      data = set_error_import_etl(data, [msg] )
      raise ActiveRecord::Rollback
    end
    data
  end

  def change_and_associate_auxiliary_data
    change_convertion_auxiliary_data
    association_sigim_convertion_auxiliary_data
  end

  def set_new_person(data)
    person = new_person(data.response)
    person.source_system_id = source_system_sigim_id
    person.origin_id = data.origin_id
    person
  end
  
  # Helper

  def constantize(moduled, model)
    "#{moduled.to_s}::#{model.to_s}".camelize.constantize
  end

  def source_system_sigim_id
    Integrations::SourceSystem.find_by(source_system: source_system).sigim_id
  end

  def system_occurrence
    Integrations::SystemOccurrence
  end

  def symbolic_attribute_name(value)
    value[1..-1].chomp("_id").camelize
  end
  
  #Verifica se é o mesmo id presente na lista
  def same_id?(list)
    id = list[0]["id"].to_i
    list.each do |json|
      return false unless json["id"].to_i == id
    end
    true
  end
  
  #Se existir mais de uma cidade exatamente igual deve
  #carregar todas as opções para comparação manual
  def list_ids(list)
    ids = []
    list.each do |item|
      ids.push(item.id)
    end
    ids
  end

  def list_names(list)
    names = []
    list.each do |item|
      names.push(item.name)
    end
    names
  end

  def attribute_remove(klass)
    att = klass.attributes
    att_rm = ["id", "source_system", "sigim_id", "validated", "ignore", "user_id", "created_at", "updated_at", "deleted_at"]
    att_rm.each do |rm|
      att.delete(rm)
    end
    function = "#{source_system}_overlapping_rule"
    att = send(function, att, klass) if respond_to?(function.to_sym)
    att
  end

  def exist_id_import?(id)
    system_occurrence.find_by(origin_id: id, source_system: source_system).present?
  end
  
  def auxiliary_empty?(klass)
    !klass.nil? && klass.sigim_id.nil?
  end
 
  # Error management

  def verify_errors(person)
    if person.exists_cpf?
      unless person.without_default_fields.present?
        pes = SigimImports::Person.find_by(cpf: person.cpf)
        set_errors(message_error(:rule, "CPF", I18n.t('base.errors.cpf', cpf: person.cpf, pes: pes.name, id: pes.id), person.cpf))
      end
    end
    set_errors(message_error(:rule, "NIS", I18n.t('base.errors.nis', nis: person.nis), person.nis)) if person.exists_nis?
    set_errors(message_error(:rule, "RG",  I18n.t('base.errors.rg',  rg:  person.rg),  person.rg))  if person.exists_rg?
  end

  def to_approve_or_set_error_association(model, klass)
    msg = set_msg_no_association(klass)
    msg += ' ('+klass.city.name+')' if model == :Neighborhood
    city_id = klass.has_attribute?(:city_id) ? klass.city.id : nil
    if !table_importation_exception.include?(model)
      @Save_address = true
      set_errors(message_error(:association, model, msg, klass.id, city_id)) if auxiliary_empty?(klass)
    else
      @Save_address = false
    end
    klass
  end

  def verify_error_duplicity(resources, model)
    if !table_importation_exception.include?(model)
      ids = list_ids(resources)
      names = list_names(resources)
      msg = set_msg_doubt(names)
      set_errors(message_error(:duplicity, model, msg, ids))
    end
  end

  def verify_error_create_and_null(model, name)
    if !table_importation_exception.include?(model)
      if !name.nil?
        msg = set_msg_create(name)
        set_errors(message_error(:create, model, msg, "null"))
      else
        msg = set_msg_null(model)
        set_errors(message_error(:null, model, msg, "null"))
      end
    end
  end

  def set_data_ignore(type, value=nil)
    message = set_msg_ignore('cpf')  if type == :cpf
    message = set_msg_ignore('name') if type == :name
    message = set_msg_ignore(type)   if table_importation.include?(type)
    reason = value.nil? ? { reason: message } : { reason: message, value: value }
    @ignore_error << reason
  end

  def set_error_import_etl(data, errors)
    data.import_error = errors
    data.already_imported = false
    data
  end

  def set_errors(value)
    @errors << value
  end
  
  def set_msg(error)
    I18n.t("base.errors.#{error}")
  end

  def set_msg_ignore(key)
    I18n.t("base.data_ignore.#{key.to_s.underscore}")
  end

  def set_msg_no_association(klass)
    return I18n.t('base.errors.no_association', name: klass.name)
  end

  def set_msg_doubt(names)
    return I18n.t('base.errors.doubt', names: names)
  end

  def set_msg_create(name)
    return I18n.t('base.errors.create', name: name.upcase)
  end

  def set_msg_null(resource)
    resource = I18n.t("activerecord.models.#{resource.to_s.underscore}")
    return I18n.t('base.errors.is_null', resource: resource.upcase, source: source_system.upcase) 
  end

  def message_error(error_type, classfy, error, id, klass_id=nil)
    klass_id_nil = { error_type: error_type,
                     classfy: classfy,
                     error: error,
                     id: id }
    klass_id_and_address = { error_type: error_type,
                          classfy: classfy,
                          error: error,
                          id: id,
                          address: @address_nudem }
    default = { error_type: error_type,
                classfy: classfy,
                error: error,
                id: id, 
                klass_id:  klass_id }
    
    return klass_id_nil         if (klass_id.nil? && @address_nudem.nil?)
    return klass_id_and_address if (klass_id.nil? && !@address_nudem.nil?)
    default
  end

  def success(last_page, total_pages) 
    I18n.t('base.import.success_data',
            source: source_system.upcase,
            last_page: last_page,
            total_pages: total_pages
          )
  end
  
  def success_etl(success, failure) 
    I18n.t('base.import.success_etl',
            source: source_system.upcase,
            success: success, 
            failure: failure
          )
  end

  # Constants

  def source_system
    self.class::SOURCE_SYSTEM
  end

  def collection
    self.class::COLLECTION
  end
  
  def username
    self.class::USERNAME
  end
  
  def password
    self.class::PASSWORD
  end
  
  def base_url
    self.class::BASE_URL
  end
  
  def per_page
    self.class::PER_PAGE
  end

  def table_importation
    self.class::TABLE_IMPORTATION
  end

  def table_importation_exception
    self.class::TABLE_IMPORTATION_EXCEPTION
  end

  def etl_quantity 
    self.class::ETL_QUANTITY
  end

end
