# SIGIM Integration API
## Sistema de integração com as APIs dos órgão que fornecem dados para o SIGIM

# Procedimentos

# Clonar projeto:
git clone http://git.vicegov.ce.gov.br/ctigi/sigim-integration-api.git


# Instalação RVM:
Caso não possua o rvm, realize a instalação abaixo, executando no terminal linux:
gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

caso não importe a chave

curl -sSL https://rvm.io/mpapis.asc | gpg --import -
curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -

curl -L https://get.rvm.io | bash


Obs2: após concluída a instalação do rvm, instale o Rails:

rvm install 3.0.0

Executar o bundle

# Instalação NVM:
Caso não possua o nvm, realize a instalação abaixo, executando no terminal:
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash

recarregue o seu bashrc:
source /home/$USER/.bashrc


após concluída a instalação do nvm, instale uma versão do nodejs:
nvm install node

# Instalação do Yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update
sudo apt install yarn nodejs
yarn

# Instalar o Postgresql
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install postgresql
sudo apt-get install libpq-dev

#Acessar o postgres
sudo su postgres
psql

caso de erro psql: could not connect to server: No such file or directory Is the server running locally and accepting connections on Unix domain socket "/var/run/postgresql/.s.PGSQL.5432"?
#format is pg_ctlcluster   

sudo pg_ctlcluster 15 main start

#restart PostgreSQL service

sudo service postgresql restart

#colocar o usuarios postgres como proprietário

sudo chown postgres -R /var/lib/postgresql/14/main/

#set user to group back with
sudo gpasswd -a postgres ssl-cert

Fixed ownership and mode
sudo chown root:ssl-cert  /etc/ssl/private/ssl-cert-snakeoil.key
sudo chmod 740 /etc/ssl/private/ssl-cert-snakeoil.key

now postgresql starts! (and install command doesn't fail anymore)

sudo service postgresql restart

Acessar o usuário postgres
sudo su postgres

Entrar no sql
psql

Alterar usuário postgres dentro do banco postgres
ALTER USER postgres WITH PASSWORD 'postgres';

restart no service postgresql
sudo service postgresql restart

# Executar puma
rails s