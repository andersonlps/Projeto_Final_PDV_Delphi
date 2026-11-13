-- =====================================================================
-- Script de criacao das tabelas do projeto
-- Execute no Query Tool do pgAdmin, DENTRO do banco usado pelo sistema.
-- Pode ser executado mais de uma vez (IF NOT EXISTS).
-- =====================================================================

CREATE TABLE IF NOT EXISTS cliente (
    id        SERIAL PRIMARY KEY,
    nome      VARCHAR(100) NOT NULL,
    cpf       VARCHAR(11)  NOT NULL UNIQUE,
    telefone  VARCHAR(20),
    email     VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS endereco (
    id          SERIAL PRIMARY KEY,
    id_cliente  INTEGER NOT NULL
                REFERENCES cliente (id) ON DELETE CASCADE,
    cep         VARCHAR(8),
    logradouro  VARCHAR(150),
    numero      VARCHAR(10),
    bairro      VARCHAR(80),
    cidade      VARCHAR(80),
    uf          CHAR(2)
);

CREATE TABLE IF NOT EXISTS produto (
    id         SERIAL PRIMARY KEY,
    descricao  VARCHAR(100) NOT NULL,
    preco      NUMERIC(10,2) NOT NULL DEFAULT 0,
    estoque    INTEGER NOT NULL DEFAULT 0
);



-- =====================================================================
-- VENDAS (master: venda / detalhe: item_venda)
-- =====================================================================

CREATE TABLE IF NOT EXISTS venda (
    id               SERIAL PRIMARY KEY,
    id_cliente       INTEGER NOT NULL REFERENCES cliente (id),
    data_venda       TIMESTAMP NOT NULL DEFAULT now(),
    forma_pagamento  VARCHAR(30) NOT NULL,
    total            NUMERIC(12,2) NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS item_venda (
    id              SERIAL PRIMARY KEY,
    id_venda        INTEGER NOT NULL
                    REFERENCES venda (id) ON DELETE CASCADE,
    id_produto      INTEGER NOT NULL REFERENCES produto (id),
    quantidade      INTEGER NOT NULL,
    preco_unitario  NUMERIC(10,2) NOT NULL,
    subtotal        NUMERIC(12,2) NOT NULL
);

-- Conferencia: deve listar as 5 tabelas (cliente, endereco, item_venda, produto, venda)
SELECT current_database() AS banco, table_schema, table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;
