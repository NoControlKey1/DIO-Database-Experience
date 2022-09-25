CREATE DATABASE IF NOT EXISTS oficina;

USE oficina;

CREATE TABLE IF NOT EXISTS cliente(
cpf CHAR(11),
nome VARCHAR(45) NOT NULL UNIQUE,
genero ENUM('M', 'F', 'Outro') NOT NULL,
dataNascimento DATE NOT NULL,
endereco VARCHAR(100) NOT NULL,
cnh CHAR(10) NOT NULL UNIQUE,
CONSTRAINT pk_cliente PRIMARY KEY (cpf)
);

CREATE TABLE IF NOT EXISTS veiculo(
placa CHAR(7),
cpfCliente CHAR(11) NOT NULL,
modelo VARCHAR(30) NOT NULL,
marca VARCHAR(30) NOT NULL,
ano CHAR(4) NOT NULL,
PRIMARY KEY (placa),
CONSTRAINT fk_veiculo FOREIGN KEY (cpfCliente) REFERENCES cliente(cpf)
);

CREATE TABLE IF NOT EXISTS mecanico(
cpf CHAR(11),
nome VARCHAR(45) NOT NULL,
genero ENUM('M', 'F', 'Outro') NOT NULL,
dataNascimento DATE NOT NULL,
endereco VARCHAR(100) NOT NULL,
especialidade VARCHAR(30) NOT NULL,
UNIQUE(nome)
);

ALTER TABLE mecanico ADD PRIMARY KEY (cpf);

-- ALTER TABLE mecanico ADD UNIQUE (nome);
-- ALTER TABLE mecanico ADD CONSTRAINT u_nome UNIQUE (nome);

CREATE TABLE IF NOT EXISTS equipe(
id TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
responsavel CHAR(11) NOT NULL
);

-- ALTER TABLE equipe ADD CONSTRAINT pk_equipe PRIMARY KEY (id);
ALTER TABLE equipe ADD CONSTRAINT fk_equipe FOREIGN KEY (responsavel) REFERENCES mecanico(nome);

CREATE TABLE IF NOT EXISTS equipe_mecanico(
idEquipe TINYINT UNSIGNED,
mecanico CHAR(11),
PRIMARY KEY (idEquipe, mecanico),
FOREIGN KEY (idEquipe) REFERENCES equipe(id),
FOREIGN KEY (mecanico) REFERENCES mecanico(nome)
);

CREATE TABLE IF NOT EXISTS pedido(
id MEDIUMINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
cpfCliente CHAR(11) NOT NULL,
placaVeiculo CHAR(7) NOT NULL,
idEquipe TINYINT UNSIGNED,
tipoRequisicao VARCHAR(45) NOT NULL,
FOREIGN KEY (cpfCliente) REFERENCES cliente(cpf),
FOREIGN KEY (placaVeiculo) REFERENCES veiculo(placa),
FOREIGN KEY (idEquipe) REFERENCES equipe(id)
);

CREATE TABLE IF NOT EXISTS ordemDeServico(
id MEDIUMINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
idEquipe TINYINT UNSIGNED NOT NULL,
idPedido MEDIUMINT UNSIGNED NOT NULL,
dataEntrega DATE NOT NULL,
dataEmissao DATE NOT NULL,
valor FLOAT NOT NULL,
FOREIGN KEY (idEquipe) REFERENCES equipe(id),
FOREIGN KEY (idPedido) REFERENCES pedido(id)
);

ALTER TABLE ordemDeServico ADD CHECK (dataEmissao <= dataEntrega);

CREATE TABLE IF NOT EXISTS servico(
id TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(45) NOT NULL,
descricao VARCHAR(45) NOT NULL,
valor FLOAT NOT NULL,
CHECK (valor>=0)
);

CREATE TABLE IF NOT EXISTS servico_ordemDeServico(
idOrdemDeServico MEDIUMINT UNSIGNED,
idServico TINYINT UNSIGNED,
quantidade TINYINT UNSIGNED NOT NULL,
valor FLOAT NOT NULL,
autorizado CHAR(3),
PRIMARY KEY (idOrdemDeServico, idServico),
FOREIGN KEY (idOrdemDeServico) REFERENCES ordemDeServico(id),
FOREIGN KEY (idServico) REFERENCES servico(id),
CONSTRAINT ch_valor CHECK (valor>=0)
);

-- ALTER TABLE servico ADD CONSTRAINT ck_valor CHECK (valor>0);

-- DROP DATABASE oficina;
