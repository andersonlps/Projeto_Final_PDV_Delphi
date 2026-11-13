object dtmPrincipal: TdtmPrincipal
  Height = 480
  Width = 640
  object dtsCliente: TDataSource
    Left = 352
    Top = 56
  end
  object fdConnection: TFDConnection
    Params.Strings = (
      'Database=projeto_pdv'
      'User_Name=postgres'
      'Password=123456'
      'DriverID=PG')
    Connected = True
    Left = 128
    Top = 56
  end
  object fdDriverLink: TFDPhysPgDriverLink
    VendorLib = 'C:\Program Files\PostgreSQL\17\bin\libpq.dll'
    Left = 248
    Top = 56
  end
  object fdTableCliente: TFDTable
    IndexFieldNames = 'id'
    Connection = fdConnection
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    TableName = 'cliente'
    Left = 128
    Top = 160
    object fdTableClienteid: TIntegerField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object fdTableClientenome: TWideStringField
      FieldName = 'nome'
      Origin = 'nome'
      Size = 100
    end
    object fdTableClientecpf: TWideStringField
      FieldName = 'cpf'
      Origin = 'cpf'
      Size = 11
    end
    object fdTableClientetelefone: TWideStringField
      FieldName = 'telefone'
      Origin = 'telefone'
    end
    object fdTableClienteemail: TWideStringField
      FieldName = 'email'
      Origin = 'email'
      Size = 100
    end
  end
  object fdTableEndereco: TFDTable
    IndexFieldNames = 'id'
    Connection = fdConnection
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    TableName = 'endereco'
    Left = 344
    Top = 160
    object fdTableEnderecoid: TIntegerField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object fdTableEnderecoid_cliente: TIntegerField
      FieldName = 'id_cliente'
      Origin = 'id_cliente'
    end
    object fdTableEnderecocep: TWideStringField
      FieldName = 'cep'
      Origin = 'cep'
      Size = 8
    end
    object fdTableEnderecologradouro: TWideStringField
      FieldName = 'logradouro'
      Origin = 'logradouro'
      Size = 150
    end
    object fdTableEndereconumero: TWideStringField
      FieldName = 'numero'
      Origin = 'numero'
      Size = 10
    end
    object fdTableEnderecobairro: TWideStringField
      FieldName = 'bairro'
      Origin = 'bairro'
      Size = 80
    end
    object fdTableEnderecocidade: TWideStringField
      FieldName = 'cidade'
      Origin = 'cidade'
      Size = 80
    end
    object fdTableEnderecouf: TWideStringField
      FieldName = 'uf'
      Origin = 'uf'
      FixedChar = True
      Size = 2
    end
  end
  object fdTableProduto: TFDTable
    IndexFieldNames = 'id'
    Connection = fdConnection
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    TableName = 'produto'
    Left = 240
    Top = 160
    object fdTableProdutoid: TIntegerField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object fdTableProdutodescricao: TWideStringField
      FieldName = 'descricao'
      Origin = 'descricao'
      Size = 100
    end
    object fdTableProdutopreco: TBCDField
      FieldName = 'preco'
      Origin = 'preco'
      Precision = 10
      Size = 2
    end
    object fdTableProdutoestoque: TIntegerField
      FieldName = 'estoque'
      Origin = 'estoque'
    end
  end
  object dtsVenda: TDataSource
    Left = 448
    Top = 56
  end
  object fdTableVenda: TFDTable
    IndexFieldNames = 'id'
    Connection = fdConnection
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    TableName = 'venda'
    Left = 432
    Top = 160
    object fdTableVendaid: TIntegerField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object fdTableVendaid_cliente: TIntegerField
      FieldName = 'id_cliente'
      Origin = 'id_cliente'
    end
    object fdTableVendadata_venda: TSQLTimeStampField
      FieldName = 'data_venda'
      Origin = 'data_venda'
      ProviderFlags = [pfInUpdate]
    end
    object fdTableVendaforma_pagamento: TWideStringField
      FieldName = 'forma_pagamento'
      Origin = 'forma_pagamento'
      Size = 30
    end
    object fdTableVendatotal: TBCDField
      FieldName = 'total'
      Origin = 'total'
      Precision = 12
      Size = 2
    end
  end
  object fdTableItemVenda: TFDTable
    IndexFieldNames = 'id'
    Connection = fdConnection
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    TableName = 'item_venda'
    Left = 528
    Top = 160
    object fdTableItemVendaid: TIntegerField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object fdTableItemVendaid_venda: TIntegerField
      FieldName = 'id_venda'
      Origin = 'id_venda'
    end
    object fdTableItemVendaid_produto: TIntegerField
      FieldName = 'id_produto'
      Origin = 'id_produto'
    end
    object fdTableItemVendaquantidade: TIntegerField
      FieldName = 'quantidade'
      Origin = 'quantidade'
    end
    object fdTableItemVendapreco_unitario: TBCDField
      FieldName = 'preco_unitario'
      Origin = 'preco_unitario'
      Precision = 10
      Size = 2
    end
    object fdTableItemVendasubtotal: TBCDField
      FieldName = 'subtotal'
      Origin = 'subtotal'
      Precision = 12
      Size = 2
    end
  end
end
