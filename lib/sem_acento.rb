# encoding: utf-8
require 'singleton'
require 'i18n'
require 'active_support/core_ext/class/attribute'
require 'active_support/inflector/transliterate'
require 'sem_acento/core_ext/string'

class SemAcento
  include Singleton

  class_attribute :replacements

  self.replacements = {
    ['á','à','â','ä','ã'] => 'a',
    ['Ã','Ä','Â','À'] => 'A',
    ['é','è','ê','ë'] => 'e',
    ['Ë','É','È','Ê'] => 'E',
    ['í','ì','î','ï'] => 'i',
    ['Î','Ì'] => 'I',
    ['ó','ò','ô','ö','õ'] => 'o',
    ['Õ','Ö','Ô','Ò','Ó'] => 'O',
    ['ú','ù','û','ü'] => 'u',
    ['Ú','Û','Ù','Ü'] => 'U',
    ['ç'] => 'c', ['Ç'] => 'C',
    ['ñ'] => 'n', ['Ñ'] => 'N'
  }

  def sem_acento(str)
    replacements.each do |ac,rep|
      ac.each do |s|
        str = str.gsub(s, rep)
      end
    end
    str = str.gsub(/[^a-zA-Z0-9\. ]/,"")
    str = str.gsub(/[ ]+/," ")
    #str = str.downcase
    str
  end
end