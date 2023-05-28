-- Removendo banco de dados, usuários e schemas que possam ter o mesmo nome.
drop database if exists 						uvv;
drop role if exists 							arthur_velemem
drop schema if exists 							lojas;

--Criação do usuário que será o dono do Banco de Dados.
CREATE USER arthur_velemem
									SUPERUSER
									CREATEDB
									CREATEROLE
									ENCRYPETED PASSWORD 'computacao@raiz';

		
--Criação do Banco de Dados.
CREATE DATABASE uvv
 		OWNER = 						arthur_velemem
 		TEMPLATE = 						template0
 		ENCODING = 						'UTF-8'
 		lc_collate = 						'pt_BR.UTF-8'
		LC_CTYPE = 						'pt_BR.UTF-8'
			
--Conectando o Banco de Dados "uvv".
\c 									uvv;

--Criando o esquema padrão da tabela.
CREATE SCHEMA 								lojas
authorization								arthur_velemem;

--Ajustando o esquema da tabela.
SET SEARCH_PATH TO 							lojas, "$user", public;
SET SEARCH_PATH TO							lojas TO arthur_velemem;

--Criando o projeto lógico do Banco de Dados "Lojas UVV".
DROP TABLE IF EXISTS lojas CASCADE;
CREATE TABLE lojas (
                loja_id 						NUMERIC(38) NOT NULL,
                nome 							VARCHAR(255) NOT NULL,
                endereco_web 						VARCHAR(100),
                endereco_fisico						VARCHAR(512),
                latitude 						NUMERIC,
                longitude 						NUMERIC,
                logo 							BYTEA,
                logo_mime_type 						VARCHAR(512),
                logo_arquivo 						VARCHAR(512),
                logo_charset 						VARCHAR(512),
                logo_ultima_atualizacao 				DATE,
                CONSTRAINT lojas_pk 					PRIMARY KEY (loja_id)
);

COMMENT ON TABLE lojas 							IS 				'Local onde a loja se encontro';
COMMENT ON COLUMN lojas.loja_id 					IS 				'Id da loja';
COMMENT ON COLUMN lojas.nome 						IS 				'Nome da loja';
COMMENT ON COLUMN lojas.endereco_web 					IS 				'Endereço do site da empresa';
COMMENT ON COLUMN lojas.endereco_fisico 				IS 				'Endereço fisico da loja';
COMMENT ON COLUMN lojas.logo_mime_type 					IS 				'Tipo de arquivo da logo';
COMMENT ON COLUMN lojas.logo_arquivo 					IS 				'Logo da loja';
COMMENT ON COLUMN lojas.logo_charset 					IS 				'Codificação da logo da loja';
COMMENT ON COLUMN lojas.logo_ultima_atualizacao 			IS 				'Data da ultima atualização da logo da loja';

DROP TABLE IF EXISTS produtos CASCADE;
CREATE TABLE produtos (
          		produto_id 					NUMERIC(38) NOT NULL,
                nome 							VARCHAR(255) NOT NULL,
                preco_unitario 						NUMERIC(10,2) NOT NULL,
                detallhes 						BYTEA,
                imagem 							BYTEA,
                imagem_mime_type 					VARCHAR(512),
                imagem_arquivo 						VARCHAR(512),
                imagem_charset 						VARCHAR(512),
                imagem_ultima_atualizacao 				DATE,
                CONSTRAINT produtos_pk 					PRIMARY KEY (produto_id)
);

COMMENT ON TABLE produtos 						IS 				'Produtos da loja';
COMMENT ON COLUMN produtos.produto_id 					IS 				'Id do produto na loja';
COMMENT ON COLUMN produtos.nome 					IS 				'Nome do produto';
COMMENT ON COLUMN produtos.preco_unitario 				IS 				'Preço unitário do produto';
COMMENT ON COLUMN produtos.imagem_mime_type 				IS 				'Tipo de arquivo da logo do produto';
COMMENT ON COLUMN produtos.imagem_arquivo 				IS 				'Arquivo da logo';
COMMENT ON COLUMN produtos.imagem_charset 				IS 				'dawa';
COMMENT ON COLUMN produtos.imagem_ultima_atualizacao 			IS 				'Data da ultima atualização da logo da loja';


DROP TABLE IF EXISTS estoques CASCADE;
CREATE TABLE estoques (
                estoque_id 						NUMERIC(38) NOT NULL,
                loja_id 						NUMERIC(38) NOT NULL,
                produto_id 						NUMERIC(38) NOT NULL,
                quantidade 						NUMERIC(38) NOT NULL,
                CONSTRAINT estoques_pk 					PRIMARY KEY (estoque_id)
);

COMMENT ON TABLE estoques 						IS 				'Quantidade do estoque da empresa';
COMMENT ON COLUMN estoques.estoque_id 					IS 				'Id do estoque do produto';
COMMENT ON COLUMN estoques.loja_id 					IS 				'Id da loja';
COMMENT ON COLUMN estoques.produto_id 					IS 				'Id do produto';
COMMENT ON COLUMN estoques.quantidade 					IS 				'Quantidade do produto no estoque';


DROP TABLE IF EXISTS clientes CASCADE;
CREATE TABLE clientes (
                cliente_id 						NUMERIC(38) NOT NULL,
                nome 							VARCHAR(255) NOT NULL,
                email 							VARCHAR(255) NOT NULL,
                telefone_1 						VARCHAR(20),
                telefone_2 						VARCHAR(20),
                telefone_3 						VARCHAR(20),
                CONSTRAINT clientes_pk 					PRIMARY KEY (cliente_id)
);

COMMENT ON TABLE clientes 						IS 				'Cadastro dos clientes';
COMMENT ON COLUMN clientes.cliente_id 					IS 				'Número de identificação do cliente';
COMMENT ON COLUMN clientes.nome 					IS 				'Nome do cliente';
COMMENT ON COLUMN clientes.email 					IS 				'Email do cliente';
COMMENT ON COLUMN clientes.telefone_1 					IS 				'Telefone principal do cliente';
COMMENT ON COLUMN clientes.telefone_2 					IS 				'Telefone reserva do cliente';
COMMENT ON COLUMN clientes.telefone_3 					IS 				'Segundo telefone reserva do cliente';

DROP TABLE IF EXISTS pedidos CASCADE;
CREATE TABLE pedidos (
                pedido_id 						NUMERIC(38) NOT NULL,
                data_hora 						TIMESTAMP NOT NULL,
                cliente_id 						NUMERIC(38) NOT NULL,
                status 							VARCHAR(15) NOT NULL,
                loja_id 						NUMERIC(38) NOT NULL,
                CONSTRAINT pedidos_pk 					PRIMARY KEY (pedido_id)
);

COMMENT ON TABLE pedidos 						IS 				'Tabela de pedidos da empresa';
COMMENT ON COLUMN pedidos.pedido_id 					IS 				'Id dos pedidos';
COMMENT ON COLUMN pedidos.data_hora 					IS 				'Data e hora do pedido';
COMMENT ON COLUMN pedidos.cliente_id 					IS 				'Id do cliente';
COMMENT ON COLUMN pedidos.status 					IS 				'Status do pedido';
COMMENT ON COLUMN pedidos.loja_id 					IS 				'Id da loja';

DROP TABLE IF EXISTS pedidos_itens CASCADE;
CREATE TABLE pedidos_itens (
                pedido_id 						NUMERIC(38) NOT NULL,
                produto_id 						NUMERIC(38) NOT NULL,
                numero_da_linha					 	NUMERIC(38) NOT NULL,
                preco_unitario 						NUMERIC(10,2) NOT NULL,
                quantidade 						NUMERIC(38) NOT NULL,
                envio_id 						NUMERIC(38) NOT NULL,
                CONSTRAINT pedidos_itens_pk 				PRIMARY KEY (pedido_id, produto_id)
);

COMMENT ON TABLE pedidos_itens 						IS 				'Os itens da loja que são produtos para os clentes';
COMMENT ON COLUMN pedidos_itens.pedido_id 				IS 				'Id do pedido';
COMMENT ON COLUMN pedidos_itens.produto_id 				IS 				'Id do produto';
COMMENT ON COLUMN pedidos_itens.numero_da_linha 			IS 				'Número da linha do pedido';
COMMENT ON COLUMN pedidos_itens.preco_unitario 				IS 				'Preço unitário do pedido';
COMMENT ON COLUMN pedidos_itens.quantidade 				IS 				'Quantidade de pedidos';
COMMENT ON COLUMN pedidos_itens.envio_id 				IS 				'Id de envio';

DROP TABLE IF EXISTS envios CASCADE;
CREATE TABLE envios (
                envio_id 						NUMERIC(38) NOT NULL,
                loja_id 						NUMERIC(38) NOT NULL,
                cliente_id 						NUMERIC(38) NOT NULL,
                endereco_entrega 					VARCHAR(512) NOT NULL,
                status 							VARCHAR(15) NOT NULL,
                CONSTRAINT envios_pk 					PRIMARY KEY (envio_id)
);

COMMENT ON COLUMN envios.envio_id 					IS 				'Id de envio';
COMMENT ON COLUMN envios.loja_id 					IS 				'Id da loja';
COMMENT ON COLUMN envios.cliente_id 					IS 				'Id do cliente';
COMMENT ON COLUMN envios.endereco_entrega 				IS 				'Endereço de entrega do cliente';
COMMENT ON COLUMN envios.status 					IS 				'Status de envio do produto para o cliente';

--Criando as Foreign Keys.

ALTER TABLE 								pedidos_itens 
ADD CONSTRAINT 								produtos_pedidos_itens_fk
FOREIGN KEY 								(produto_id)
REFERENCES 								produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE 								estoques 
ADD CONSTRAINT 								produtos_estoques_fk
FOREIGN KEY 								(produto_id)
REFERENCES 								produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE 								pedidos 
ADD CONSTRAINT 								lojas_pedidos_fk
FOREIGN KEY 								(loja_id)
REFERENCES 								lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE 								estoques 
ADD CONSTRAINT 								lojas_estoques_fk
FOREIGN KEY 								(loja_id)
REFERENCES 								lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE 								envios 
ADD CONSTRAINT 								lojas_envios_fk
FOREIGN KEY 								(loja_id)
REFERENCES 								lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE 								pedidos 
ADD CONSTRAINT 								clientes_pedidos_fk
FOREIGN KEY 								(cliente_id)
REFERENCES 								clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE 								envios
ADD CONSTRAINT 								clientes_envios_fk
FOREIGN KEY 								(cliente_id)
REFERENCES 								clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE 								pedidos_itens 
ADD CONSTRAINT 								envios_pedidos_itens_fk
FOREIGN KEY 								(envio_id)
REFERENCES 								envios (envio_id)
ON DELETE NO ACTION
ON UPDATE SET default
NOT DEFERRABLE;

ALTER TABLE 								pedidos_itens 
ADD CONSTRAINT 								pedidos_pedidos_itens_fk
FOREIGN KEY 								(pedido_id)
REFERENCES 								pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Criando as restiçoes de checagem.

ALTER TABLE 								pedidos
ADD CONSTRAINT 								cc_pedido_status
CHECK 									(status IN ('CANCELADO','CONCLUIDO','EM ANDAMENTO','PAGO','EXTORNADO','ENVIADO'));

ALTER TABLE 								envios
ADD CONSTRAINT 								cc_status_envios
CHECK 									(status IN ('CONCLUIDO','ENVIADO','EM TRANSITO','ENTREGUE'));

ALTER TABLE 								lojas
ADD CONSTRAINT 								cc_lojas_endereco
CHECK 									((endereco_web IS NOT NULL) OR (endereco_fisico IS NOT NULL));       

ALTER TABLE 								produtos
ADD CONSTRAINT 								cc__preco_unitario_produto
CHECK 									(preco_unitario >= 0);

ALTER TABLE 								estoque
ADD CONSTRAINT 								cc_quantidade_estoque
CHECK 									(quantidade >= 0);

ALTER TABLE 								pedidos_itens
ADD CONSTRAINT 								cc_quantidade_de_pedidos_itens
CHECK 									(quantidade >= 0);

ALTER TABLE 								pedidos_itens
ADD CONSTRAINT 								cc_preco_unitario_dos_pedidos_itens
CHECK 									(preco_unitario >= 0);

ALTER TABLE 								cleintes
ADD CONSTRAINT 								cc_telefone1_cleinte
CHECK 									(telefone1 !~'-');

ALTER TABLE 								cleintes
ADD CONSTRAINT 								cc_telefone2_cleinte
CHECK 									(telefone2 !~'-');

ALTER TABLE 								cleintes
ADD CONSTRAINT 								cc_telefone3_cleinte
CHECK 									(telefone3 !~'-');


















