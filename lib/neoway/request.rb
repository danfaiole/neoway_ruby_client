require 'rest-client'

class Neoway::Request
  extend Neoway

  @@token, @@last_token_exp = nil

  ##
  # Check if the user_name and password are set
  # in the application
  def self.check_api_keys
    raise NoApiKey if Neoway.user_name.nil? || Neoway.user_name.empty? ||
                      Neoway.password.nil? || Neoway.password.empty?
  end

  ##
  # Get new token from neoway to use in the requests
  def self.get_token
    check_api_keys

    response = RestClient.post(
                "#{base_url}/auth/token",
                {
                  application: Neoway.user_name,
                  application_secret: Neoway.password
                }.to_json
              )

    body = JSON.parse(response.body)

    @@last_token_exp = Time.now
    @@token = body["token"]
  end

  ##
  # Check if the token is valid, sending it to the
  # API server.
  def self.valid_token?
    check_api_keys

    return false if @@token.nil?

    response = RestClient.get(
                "#{base_url}/auth/token/check",
                {Authorization: "Bearer #{@@token}"}
              )

    response.code == 200
  end

  def self.consulta_pessoa_fisica(doc)
    get_token unless valid_token?
    retries = 0

    cpf = doc.gsub(/[^0-9]/,"")

    raise CpfWrongLength if cpf.length != 11

    response = RestClient.get(
              "#{base_url}/v1/data/pessoas/#{cpf}?fields=nome,cpf,situacaoCpf,cpfDataInscricao,idade,dataNascimento,falecido,falecidoConfirmado,sexo,nomeMae,nis,pis,endereco.logradouro,endereco.numero,endereco.complemento,endereco.bairro,endereco.municipio,endereco.uf,endereco.cep,enderecoEmpregoRaisNovo.telefone,telefones.endereco.logradouro,telefones.endereco.numero,telefones.endereco.complemento,telefones.endereco.bairro,telefones.endereco.municipio,telefones.endereco.uf,telefones.endereco.cep,rendaPresumida,estabilidadeRenda,servidorPublico,profissaoNeoway,debitosPgfnDau.inscricao,participacaoSocietariaRF.cnpj,participacaoSocietariaRF.razaoSocial,participacaoSocietariaRF.descricaoCnae,participacaoSocietariaRF.ramoAtividade,participacaoSocietariaRF.dataAbertura,participacaoSocietariaRF.qualificacao,participacaoSocietariaRF.valorParticipacao,participacaoSocietariaRF.capitalSocialEmpresa,participacaoSocietariaRF.participacaoCapitalSocial,participacaoSocietariaRF.faixaFaturamentoPresumido,participacaoSocietariaRF.faixaFaturamentoPresumidoGrupo,participacaoSocietaria.cnpj,participacaoSocietaria.razaoSocial,participacaoSocietaria.descricaoCnae,participacaoSocietaria.ramoAtividade,participacaoSocietaria.dataAbertura,participacaoSocietaria.qualificacao,participacaoSocietaria.valorParticipacao,participacaoSocietaria.capitalSocialEmpresa,participacaoSocietaria.faixaFaturamentoPresumido,participacaoSocietaria.faixaFaturamentoPresumidoGrupo,participacaoSocietariaUnico.cnpj,participacaoSocietariaUnico.razaoSocial,participacaoSocietariaUnico.descricaoCnae,participacaoSocietariaUnico.ramoAtividade,participacaoSocietariaUnico.dataAbertura,participacaoSocietariaUnico.qualificacao,participacaoSocietariaUnico.valorParticipacao,participacaoSocietariaUnico.capitalSocialEmpresa,participacaoSocietariaUnico.faixaFaturamentoPresumido,participacaoSocietariaUnico.faixaFaturamentoPresumidoGrupo",
              {Authorization: "Bearer #{@@token}"}
            )

    body = JSON.parse(response.body)

    body

  rescue RestClient::Unauthorized => e
    retries += 1
    retry if retries <= 5
  rescue RestClient::NotFound => e
    raise CpfError
  end

  def self.consulta_pessoa_juridica(doc)
    get_token unless valid_token?
    retries = 0

    cnpj = doc.gsub(/[^0-9]/,"")

    raise CnpjWrongLength if cnpj.length != 14

    response = RestClient.get(
              "#{base_url}/v1/data/empresas/#{cnpj}?fields=cnpj,razaoSocial,fantasia,natureza.id,natureza.descricao,situacao.descricao,situacao.data,cnaePrincipal.setor,cnaePrincipal.ramoAtividade,telefones.numero,endereco.logradouro,endereco.numero,endereco.complemento,endereco.bairro,endereco.municipio,endereco.uf,endereco.cep,endereco.precisao,info.numeroTelefoneRF[0],info.numeroTelefoneRF[1],cnds.orgaoEmissor,cnds.descricaoSituacao,cnds.dataEmissao,cnds.numeroCertificacao,cnds.dataValidade,debitosPgfnDau.inscricao,debitosPgfnDau.natureza,debitosPgfnDau.valorTotal,socios.participacaoSocietaria,socios.nome,socios.qualificacao,socios.documento,socios.nivelPep,sociosJunta.participacaoSocietaria,sociosJunta.nome,sociosJunta.qualificacao,sociosJunta.documento,sociosJunta.nivelPep,filiais.cnpj,filiais.razaoSocial,filiais.situacao,filiais.dataAbertura,filiais.municipio,filiais.uf,matriz.cnpj,matriz.razaoSocial,matriz.situacao,matriz.dataAbertura,matriz.municipio,matriz.uf",
              {Authorization: "Bearer #{@@token}"}
            )

    body = JSON.parse(response.body)

    body

  rescue RestClient::Unauthorized => e
    retries += 1
    retry if retries <= 5
  rescue RestClient::NotFound => e
    raise CnpjError
  end

  ##
  # API was not responding to this route
  # def self.refresh_token
  #   check_api_keys

  #   return get_token if @@token.nil?
  # end

end