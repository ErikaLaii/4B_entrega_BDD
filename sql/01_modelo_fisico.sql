/* ============================================================
   Arquivo: 01_modelo_fisico_CORRIGIDO.sql
   Autor(es): Adriano Mota, Erika Lai e Gabriela Rodrigues
   Trabalho: Sistema de Locadora de Carros
   Curso/Turma: DS- 213
   SGBD: (PostgreSQL/MySQL) Versão: 8.0.43
   Objetivo: Criação do modelo físico (DDL)
   Execução esperada: rodar primeiro, em BD vazio
============================================================*/

DROP DATABASE IF EXISTS locadoraCarros;
CREATE DATABASE locadoraCarros;
USE locadoraCarros;


-- tabela das filiais
CREATE TABLE filial (
    id_filial INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(150) NOT NULL
);

-- tabela dos funcionarios
CREATE TABLE funcionario (
    id_func INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cargo VARCHAR(50),
    telefone VARCHAR(20),
    login VARCHAR(50) NOT NULL UNIQUE,
    senha VARCHAR(60) NOT NULL,
    id_filial INT NOT NULL,
    FOREIGN KEY (id_filial) REFERENCES filial(id_filial)
);

-- tabela para saber o tipo de carro
CREATE TABLE categoria_veiculo (
    id_categoria INT PRIMARY KEY AUTO_INCREMENT ,
    nome VARCHAR(50) NOT NULL,
    preco_diaria DECIMAL(10,2) NOT NULL
);

-- tabela para as infomações do veiculo
CREATE TABLE veiculo (
    id_veiculo INT PRIMARY KEY AUTO_INCREMENT,
    placa VARCHAR(12) NOT NULL UNIQUE,
    modelo VARCHAR(50) NOT NULL,
    marca VARCHAR(20),
    ano INT NOT NULL,
    cor VARCHAR(20),
    quilometragem INT,
    status ENUM('disponivel','alugado','manutencao') DEFAULT 'disponivel',
    id_categoria INT,
    id_filial INT,
    FOREIGN KEY (id_categoria) REFERENCES categoria_veiculo(id_categoria),
    FOREIGN KEY (id_filial) REFERENCES filial(id_filial)
);

-- tabela do cliente
CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(80) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    email VARCHAR(100) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    endereco VARCHAR(200) NOT NULL
);

-- tabela do motorista
CREATE TABLE motoristas (
    id_motorista INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(80) NOT NULL,
    cnh VARCHAR(15) NOT NULL,
    disponibilidade ENUM('sim','nao') DEFAULT 'sim' NOT NULL
);

-- tabela para informações do seguro
CREATE TABLE seguro (
    id_seguro INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(30) NOT NULL,
    valor_seguro DECIMAL(10,2) NOT NULL
);

-- tabela das reservas
CREATE TABLE reserva (
    id_reserva INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    id_veiculo INT NOT NULL,
    id_seguro INT,
    data_ini DATE NOT NULL,
    data_fim DATE,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('ativa','cancelada','finalizada') DEFAULT 'ativa',
    valor_total DECIMAL(10,2),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo),
    FOREIGN KEY (id_seguro) REFERENCES seguro(id_seguro)
    
);

-- tabela dos serviços extras (CATÁLOGO DE SERVIÇOS)
-- A coluna 'id_reserva' foi removida daqui, pois tabela é um catálogo, e a ligação é feita pela tabela 'reserva_servico'
CREATE TABLE servicos_extra (
    id_servico INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    valor_diaria DECIMAL(10,2) NOT NULL
);

-- tabela que associação da reserva com o serviço solicitado
CREATE TABLE reserva_servico (
    id_reserva INT,
    id_servico INT,
    quantidade INT DEFAULT 1,
    PRIMARY KEY (id_reserva, id_servico),
    FOREIGN KEY (id_reserva) REFERENCES reserva(id_reserva),
    FOREIGN KEY (id_servico) REFERENCES servicos_extra(id_servico)
);

-- tabela das informações de entrega e devolução do veículo
CREATE TABLE entrega_veiculo (
    id_entrega INT PRIMARY KEY AUTO_INCREMENT,
    id_reserva INT NOT NULL,
    quilometragem_retirada INT,
    quilometragem_devolucao INT,
    data_retirada DATETIME  NOT NULL,
    data_devolucao DATETIME,
    local_retirada VARCHAR(100)  NOT NULL,
    local_devolucao VARCHAR(100),
    FOREIGN KEY (id_reserva) REFERENCES reserva(id_reserva)
);

-- tabela da para ocorrencias com o carro
CREATE TABLE ocorrencia (
    id_ocorrencia INT PRIMARY KEY AUTO_INCREMENT,
    id_reserva INT NOT NULL,
    data_ocorrencia DATETIME NOT NULL,
    valor_ocorrencia DECIMAL(10,2) ,
    tipo VARCHAR(50) ,
    descricao TEXT,
    FOREIGN KEY (id_reserva) REFERENCES reserva(id_reserva)
);

-- tabela de pagamentos 
CREATE TABLE pagamento (
    id_pagamento INT PRIMARY KEY AUTO_INCREMENT,
    id_reserva INT NOT NULL,
    valor_pago DECIMAL(10,2) NOT NULL,
    data_pagamento DATETIME NOT NULL,
    metodo VARCHAR(30) NOT NULL,
    comprovante VARCHAR(200) NOT NULL,
    FOREIGN KEY (id_reserva) REFERENCES reserva(id_reserva)
);
