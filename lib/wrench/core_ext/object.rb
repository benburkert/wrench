class Object
  def K(*k)
    yield *k if block_given?
    return *k
  end
end
