class NoApiKey < StandardError
  def initialize(msg="API keys are missing, please set user_name and password in some config file.")
    super
  end
end

class CpfWrongLength < StandardError
  def initialize(msg="CPF must be 11 characters long.")
    super
  end
end

class CpfError < StandardError
  def initialize(msg="CPF is invalid.")
    super
  end
end

class CnpjWrongLength < StandardError
  def initialize(msg="CNPJ must be 14 characters long.")
    super
  end
end

class CnpjError < StandardError
  def initialize(msg="CNPJ is invalid.")
    super
  end
end