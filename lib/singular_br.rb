# encoding: utf-8
require 'singleton'
require 'i18n'
require 'active_support/core_ext/class/attribute'
require 'active_support/inflector/transliterate'
require 'singular_br/core_ext/string'

class SingularBr
  include Singleton

  class_attribute :replacements

  self.replacements = [
    # if word ends in "al", "el", "ol", "ul": trade "l" with "is"
    # Ex: farol, hospital, telemovel, pincel, anzol
    [/^([a-zA-z]*)ais$/i, '\1AL'],
    [/^([a-zA-z]*)eis$/i, '\1EL'],
    [/^([a-zA-z]*)ois$/i, '\1OL'],
    [/^([a-zA-z]*)uis$/i, '\1UL'],
    # general rule: remove "s" to the end of the word  
    # Ex: casa, pe, carro, pneu
    [/^([a-zA-z]*)as$/i, '\1A'],
    [/^([a-zA-z]*)es$/i, '\1E'],
    [/^([a-zA-z]*)is$/i, '\1I'],
    [/^([a-zA-z]*)os$/i, '\1O'],
    [/^([a-zA-z]*)us$/i, '\1U'],
    # if word ends in "r" or "z", add "es"
    # Ex: luz, flor, arroz
    [/^([a-zA-z]*)res$/i, '\1R'],
    [/^([a-zA-z]*)zes$/i, '\1Z'],
    # if word ends in "il" and has tónic accent in last syllable, trade "il" with "is"
    # Ex: cantis
    [ /^([a-zA-z]*)is$/i, '\1IL'],
    # if word ends in "m", trade "m" with "ns"
    # Ex: armazens, portagens
    [ /^([a-zA-z]*)ns$/i, '\1M'],
    # if word ends in "ao", trade "ao" with "oes"
    # Ex: cães, colchões, portões
    [ /^([a-zA-z]*)oes$/i, '\1AO'],
    # Irregular
    ['caes', 'cao'],
    ['paes', 'pao'],
    ['maos', 'mao'],
    ['alemaes', 'alemao'],
    ['permissoes', 'permissao']
  ]

  def singular(word)
    result = I18n.transliterate(word).upcase

    replacements.each do |search, replace|
      result.gsub!(search, replace)
    end

    result.strip
  end
end