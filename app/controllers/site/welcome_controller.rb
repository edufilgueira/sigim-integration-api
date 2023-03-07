class Site::WelcomeController < SiteController
  before_action :authenticate_user!
  def index
    @title = "Bem vindo ao SIGIM - Importação"
  end
end
