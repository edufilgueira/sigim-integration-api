class SigimRecord < ApplicationRecord
  self.abstract_class = true

  connects_to database: { writing: :sigim, reading: :sigim }

  require 'fonetica'
  require 'plural_br'
  require 'singular_br'
  require 'sem_acento'
end
