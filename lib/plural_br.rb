# encoding: utf-8
require 'singleton'
require 'i18n'
require 'active_support/core_ext/class/attribute'
require 'active_support/inflector/transliterate'
require 'plural_br/core_ext/string'

class PluralBr
  include Singleton

  class_attribute :replacements

  self.replacements = [
    # if word ends in "al", "el", "ol", "ul": trade "l" with "is"
    # Ex: farois, hospitais, telemoveis, pinceis, anzois
    [/^([a-zA-z]*)al$/i, '\1AIS'],
    [/^([a-zA-z]*)el$/i, '\1EIS'],
    [/^([a-zA-z]*)ol$/i, '\1OIS'],
    [/^([a-zA-z]*)ul$/i, '\1UIS'],
    # general rule: add "s" to the end of the word  
    # Ex: casas, pes, carros, pneus
    [/^([a-zA-z]*)a$/i, '\1AS'],
    [/^([a-zA-z]*)e$/i, '\1ES'],
    [/^([a-zA-z]*)i$/i, '\1IS'],
    [/^([a-zA-z]*)o$/i, '\1OS'],
    [/^([a-zA-z]*)u$/i, '\1US'],
    # if word ends in "r" or "z", add "es"
    # Ex: luzes, flores, flores
    [/^([a-zA-z]*)r$/i, '\1RES'],
    [/^([a-zA-z]*)z$/i, '\1ZES'],
    # if word ends in "il" and has tónic accent in last syllable, trade "il" with "is"
    # Ex: cantis
    [ /^([a-zA-z]*)il$/i, '\1IS'],
    # if word ends in "m", trade "m" with "ns"
    # Ex: armazens, portagens
    [ /^([a-zA-z]*)m$/i, '\1NS'],
    # if word ends in "ao", trade "ao" with "oes"
    # Ex: cães, colchões, portões
    [ /^([a-zA-z]*)ao$/i, '\1OES'],
    # Irregular
    ['cao', 'caes'],
    ['pao', 'paes'],
    ['mao', 'maos'],
    ['alemao', 'alemaes'],
    ['permissao', 'permissoes']
  ]

  def plural(word)
    result = I18n.transliterate(word).upcase

    replacements.each do |search, replace|
      result.gsub!(search, replace)
    end

    result.downcase.strip
  end
end