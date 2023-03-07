# encoding: utf-8
require 'singleton'
require 'i18n'
require 'active_support/core_ext/class/attribute'
require 'active_support/inflector/transliterate'
require 'fonetica/core_ext/string'

class Fonetica
  include Singleton

  class_attribute :replacements

  self.replacements = [
    ['PH', 'F'],
    ['Y', 'I'],
    ['N', 'M'],
    ['RM', 'SM'],
    ['PR', 'P'],
    [/BL|BR/, 'B'],
    [/GL|GR|MG|NG|RG/, 'G'],
    [/TR|TL/, 'T'],
    [/CT|RT|ST|PT/, 'T'],
    [/[MRS]+\b/, ''],
    [/\b[UW]/, 'V'],
    [/GE|GI|RJ|MJ/, 'J'],
    [/CA|CO|CU|CK|Q/, 'K'],
    [/AO|AUM|GM|OM|ON/, 'M'],
    [/CE|CI|CH|CS|RS|TS|X|Z/, 'S'],
    [/[AEIOUH]/, ''],
    [/[^0-9A-Za-z]/, ' ']
  ]

  def foneticalize(word)
    result = word.gsub(/ç/i, 's')
    result = I18n.transliterate(result)
    result = result.parameterize.upcase
    result = result.gsub("-"," ")

    replacements.each do |search, replace|
      result.gsub!(search, replace)
    end

    result.strip
  end
end