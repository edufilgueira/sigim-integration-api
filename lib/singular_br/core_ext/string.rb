class String
  def singular
    SingularBr.instance.singular(self)
  end
end
