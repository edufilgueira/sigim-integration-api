require 'fonetica'

class Api::OisolController < ApplicationController
  include BaseController
  include HelperController

  # Authentication

  USERNAME = '33400188000114'.freeze
  PASSWORD = 'mQE42ETrJgSgc8B'.freeze
  BASE_URL = 'https://oisol.sps.ce.gov.br/oisol-api/'.freeze
  CLIENT_ID     = 'oisol'
  CLIENT_SECRET = 'admin'
  PER_PAGE      = 100
  
  # Configuration

  SOURCE_SYSTEM = :oisol
  COLLECTION = "content"
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
  
  def vitimas
    url         = "#{base_url}vitimas/mulheres/paginadas"
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
    att["state_id"] = state_id if model == "City"
    if model == "Neighborhood"
      obj = Integrations::City.find(att["city_id"])
      att["city_id"] = obj.sigim_id
    end
    att
  end


  private

  # Importation

  def new_person(json)
    pes = super
    
    address = json["endereco"]["bairro"]
    if !address["cidadeNome"].nil?
      city = auxiliary_table_map(:City, address["cidadeNome"])
      pes.send("old_city=", city) unless city.nil?
      if (!city.nil? && !city.sigim_id.nil?)
        neighborhood = auxiliary_table_map(:Neighborhood, address["nome"], :city_id, city.id)
        @neighborhood_id = neighborhood&.sigim_id
        pes.send("old_neighborhood=", neighborhood) unless neighborhood.nil?
      end
    end
    pes
  end

  def change_fields_people_address(json)
    address = json["endereco"]
    hash = {}
    hash["street_name"]        = address["logradouro"]  unless is_nil_or_blank?(address["logradouro"])
    hash["street_number"]      = address["numero"]      unless is_nil_or_blank?(address["numero"])
    hash["address_complement"] = address["complemento"] unless is_nil_or_blank?(address["complemento"])
    hash["cep"]                = address["cep"]         unless is_nil_or_blank?(address["cep"])
    hash
  end

  def update_auxiliary_data(json)
    Integrations::Breed.new_data(source_system, json["racaCorDescricao"]) 
    Integrations::CivilStatus.new_data(source_system, json["estadoCivilDescricao"]) 
    Integrations::GenderIdentity.new_data(source_system, json["identidadeGeneroDescricao"]) 
    Integrations::Gender.new_data(source_system, json["generoDescricao"]) 
    Integrations::SexualOrientation.new_data(source_system, json["sexualidadeDescricao"])
    Integrations::Scholarity.new_data(source_system, json["grauInstrucaoDescricao"])
    state = Integrations::State.new_data(source_system, "Ceará") 
    city  = Integrations::City.new_data(source_system, json["endereco"]["bairro"]["cidadeNome"], state.id)
    Integrations::Neighborhood.new_data(source_system, json["endereco"]["bairro"]["nome"], city.id)
  end
  
  # Conect Oauth2 API
  
  def select_max(url)
    oisol_list = get_data(url, 1)
    oisol_list['totalElements']
  end

  def get_data(url, last_page)
    access_token = token(client)
    JSON.parse(access_token.get(url, params: mount_params(last_page)).body)
  end
  
  def mount_params(page)
    {page: page, size: per_page, sort: 'id'}
  end

  def client
    access_token_url = "#{base_url}oauth/token"
    OAuth2::Client.new(client_id, client_secret, token_url: access_token_url)
  end

  def token(client)
    client.password.get_token(username, password)
  end

  # Constants

  def client_id 
    self.class::CLIENT_ID
  end

  def client_secret 
    self.class::CLIENT_SECRET
  end

  def state_id
    self.class::STATE
  end

end