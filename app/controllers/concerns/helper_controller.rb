module HelperController
  extend ActiveSupport::Concern
  
  # Remove os acentos das palavras
  def normalize(str)
    n = I18n.transliterate(str).downcase
    n = str.strip.downcase
    n = n.parameterize
    n = n.gsub("-"," ")
    n
  end
  
  # Remove as vogais das palavras
  def remove_vogais(word)
    n = I18n.transliterate(word).downcase
    n = n.gsub(/[aeiou]/, '')
    n.strip
  end

  def remove(word)
    n = I18n.transliterate(word).downcase
    n = n.gsub(/\s*\(.+\)$/, '')
    n.strip
  end

  def is_nil_or_blank?(object)
    (object.nil? || object.blank?)
  end

  def compare_feminino(word1, word2)
    feminino(word1) == feminino(word2)
  end

  def compare_convolution(str1, str2)
    str1.include?(str2) || str2.include?(str1)
  end
  
  def feminino(word)
    replacements = [
      # Remove tudo entre () Ex: menino(a) = menino
      [/\s*\(.+\)$/, ''],
      # Exceção
      ['autor', 'triz'],
      ['homem', 'mulher'],
      ['masculino', 'feminino'],
      ['bom', 'boa'],
      ['mau', 'ma'],
      # Ex: amigo, aluno
      [/^([a-zA-z]*)o$/i, '\1a'],
      # Ex: cantor, autor
      [/^([a-zA-z]*)or$/i, '\1ora'],
      # Ex: ingles
      [/^([a-zA-z]*)es$/i, '\1esa'],
      # Ex: espanhol
      [/^([a-zA-z]*)nhol$/i, '\1nhola'],
      # Deve adicionar artigo no inicio para diferenciar. Ex O estudante, A estudante
      # [/^([a-zA-z]*)ante$/i, '\1ante'],
      # [/^([a-zA-z]*)ente$/i, '\1ente'],
      # [/^([a-zA-z]*)ista$/i, '\1ista'],
      # [/^([a-zA-z]*)agem$/i, '\1agem'],
      # Exclusividade do feminino
      # [/^([a-zA-z]*)cao$/i, '\cao'],
      # [/^([a-zA-z]*)icie$/i, '\1icie'],
    ]
    
    result = I18n.transliterate(word).downcase.strip
    replacements.each do |search, replace|
      result.gsub!(search, replace)
    end
    
    result = normalize(result)
    result.strip
  end
  
end
