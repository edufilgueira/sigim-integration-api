class String
  def plural
    PluralBr.instance.plural(self)
  end
end
