require 'fonetica'

class Api::NudemController < ApplicationController
  include BaseController
  include HelperController

  # Authentication

  USERNAME  = 'sigim'.freeze
  PASSWORD  = '1m86sgvl'.freeze
  BASE_URL  = 'https://nossa.defensoria.ce.def.br/psicossocial/api/sigim/'.freeze
  TOKEN_URL = 'https://nossa.defensoria.ce.def.br/api/token/'.freeze
  PER_PAGE  = 10

  # Configuration

  SOURCE_SYSTEM = :nudem
  COLLECTION = "results"
  ETL_QUANTITY  = 100
  STATE = 6 #Ceará

  TABLE_IMPORTATION = [
    :Breed,
    :City,
    :CivilStatus,
    :GenderIdentity,
    :Gender,
    :Neighborhood,
    :Scholarity,
    :SexualOrientation
  ]

  def instrumental
    url         = "#{base_url}instrumental-nudem"
    @last_page  = last_page_source_system
    @last_page  = @last_page.nil? ? 0 : @last_page
    total_pages = total_pages(url)
    if @last_page <= total_pages
      @last_page += 1
      collection_list = get_data(url, @last_page)
      same_id = import_distinct(url, collection_list[collection])
      import(url, collection_list[collection]) unless same_id
    end
    render json: success(@last_page, total_pages), status: 200
  end

  def etl_imports
    change_convertion_auxiliary_data
    association_sigim_convertion_auxiliary_data
    @success = 0
    @failure = 0
    etl_itens_import.each do | data |
      save_etl(data)
    end
    render json: success_etl(@success, @failure), status: 200
  end


  private

  # Importation

  def new_person(json)
    pes = SigimImports::Person.new
    pes.cpf            = json["cpf"].strip unless json["cpf"].nil?
    pes.name           = json["nome"].strip unless json["nome"].nil?
    pes.birth_date     = json["data_nascimento"].strip unless json["data_nascimento"].nil?
    pes.average_income = json["renda_mensal"].strip unless json["renda_mensal"].nil?
    pes.number_children= json["quant_filhos"].strip unless json["quant_filhos"].nil?
    pes.breed_id              = auxiliary_table_map(:Breed, json["raca"]).sigim_id
    pes.scholarity_id         = auxiliary_table_map(:Scholarity, json["escolaridade"]).sigim_id
    pes.gender_id = 2         # Sempre Feminino
    pes.sexual_orientation_id = auxiliary_table_map(:SexualOrientation, json["orientacao_sexual"]).sigim_id
    pes.gender_identity_id    = auxiliary_table_map(:GenderIdentity, json["identidade_genero"]).sigim_id
    pes.civil_status_id       = auxiliary_table_map(:CivilStatus, json["estado_civil"]).sigim_id
    pes.housing_situation_id  = auxiliary_table_map(:HousingSituation, json["reside_com"]).sigim_id

    
    # Provoca erros na cidade e bairro, caso exista
    city             = auxiliary_table_map(:City, search_city_in_address(json["endereco"]))
    @neighborhood_id = auxiliary_table_map(:Neighborhood, json["bairro"], :city_id, city.id).sigim_id if !city.sigim_id.nil?

    pes
  end

  def search_city_in_address(string)
    cities = SigimImports::City.array_of_names(state_id)
    regex = /\b#{ Regexp.union(cities) }\b/i
    names = string.scan(regex)
    return nil         if names.count == 0
    return names.first if names.count == 1
    names
  end

  def change_fields_people_address(json)
    address = json["endereco"]
    hash = {}
    hash["street_name"] =        address  unless is_nil_or_blank?(address)
    # hash["street_number"] =      address["numero"]      unless is_nil_or_blank?(address["numero"])
    # hash["address_complement"] = address["complemento"] unless is_nil_or_blank?(address["complemento"])
    # hash["cep"] =                address["cep"]         unless is_nil_or_blank?(address["cep"])
    hash
  end

  def update_auxiliary_data(json)
    Integrations::Breed.new_data(source_system, json["raca"])
    Integrations::CivilStatus.new_data(source_system, json["estado_civil"]) 
    Integrations::GenderIdentity.new_data(source_system, json["identidade_genero"]) 
    Integrations::SexualOrientation.new_data(source_system, json["orientacao_sexual"])
    Integrations::Scholarity.new_data(source_system, json["escolaridade"])

    state = Integrations::State.new_data(source_system, "Ceará")
    city_name = search_city_in_address(json["endereco"])
    city  = Integrations::City.new_data(source_system, city_name, state.id)
    Integrations::Neighborhood.new_data(source_system, json["bairro"], city.id) unless (city.nil? || json["bairro"].nil?)
  end
  
  # Helper
  
  # Conect Oauth2 API

  def select_max(url)
    nudem_list = get_data(url, 1)
    nudem_list['count']
  end
  
  def get_data(url, page)
    url = "#{url}?#{mount_params(page)}"
    JSON.parse(RestClient.get(url, headers))
  end

  def mount_params(page)
    "page=#{page}&sort=id"
  end

  def token 
    autentication = {'username': username, 'password': password}
    value = RestClient.post(token_url, autentication)
    JSON.parse(value)['access']
  end

  def headers
    {
      'Accept': 'application/json',
      'Content-type': 'application/json',
      'Authorization': "Bearer #{token}"
    }
  end

  # Constants

  def token_url
    self.class::TOKEN_URL
  end

  def state_id
    self.class::STATE
  end

end