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
    :SexualOrientation,
    :HousingSituation
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
    etl_itens_import
    render json: success_etl(@success, @failure), status: 200
  end

  def oisol_overlapping_rule(att, klass)
    model = klass.to_s.split(":")[2]

    att["state_id"] = state_id                    if model == "City"
    obj = Integrations::City.find(att["city_id"]) if model == "Neighborhood"
    att["city_id"] = obj.sigim_id                 if model == "Neighborhood"
    att
  end


  private

  # Importation

  def new_person(json)
    pes = super
    pes.gender_id = 2 # Sempre Feminino
    
    # Provoca erros na cidade e bairro, caso exista
    names_cities = search_city_in_address(json["endereco"])
    city = auxiliary_table_map(:City, names_cities)
    # Variável @address_nudem foi criada para atender anomalia do endereço do NUDEM que vem escrito nastring
    @address_nudem = names_cities.nil? ? nil : json["endereco"]
    pes.send("old_city=", city) unless city.nil?
    if !city.sigim_id.nil?
      neighborhood = auxiliary_table_map(:Neighborhood, json["bairro"], :city_id, city.id)
      @neighborhood_id = neighborhood&.sigim_id
      pes.send("old_neighborhood=", neighborhood) unless neighborhood.nil?
    end
    pes
  end

  def search_city_in_address(string)
    unless  string.nil?
      cities = SigimImports::City.array_of_names(state_id)
      regex = /\b#{ Regexp.union(cities) }\b/i
      names = string.scan(regex)
      return nil         if names.count == 0
      return names.first if names.count == 1
      return names
    end
    nil
  end

  def change_fields_people_address(json)
    address = json["endereco"]
    hash = {}
    hash["street_name"] = address  unless is_nil_or_blank?(address)
    hash
  end

  def update_auxiliary_data(json)
    Integrations::Breed.new_data(source_system, json["raca"])
    Integrations::Scholarity.new_data(source_system, json["escolaridade"])
    Integrations::SexualOrientation.new_data(source_system, json["orientacao_sexual"])
    Integrations::GenderIdentity.new_data(source_system, json["identidade_genero"]) 
    Integrations::CivilStatus.new_data(source_system, json["estado_civil"])
    Integrations::HousingSituation.new_data(source_system, json["situacao_moradia"])

    state = Integrations::State.new_data(source_system, "Ceará")
    city_name = search_city_in_address(json["endereco"])
    city  = Integrations::City.new_data(source_system, city_name, state.id) unless city_name.nil?
    Integrations::Neighborhood.new_data(source_system, json["bairro"], city.id) unless (city.nil? || json["bairro"].nil?)
  end
  
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