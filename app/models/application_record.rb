class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  # primary_abstract_class
  connects_to database: { writing: :primary, reading: :primary }

  require 'fonetica'
  require 'plural_br'
  require 'singular_br'
  require 'sem_acento'
end
