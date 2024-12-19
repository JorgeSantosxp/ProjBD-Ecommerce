 # Projeto de Banco de Dados de E-commerce

## Introdução
Este projeto envolve a criação de um banco de dados para um sistema de e-commerce. O objetivo é projetar o esquema do banco de dados, inserir dados de teste e criar consultas SQL avançadas para responder a perguntas específicas.

## Descrição do Projeto Lógico
O projeto lógico visa modelar e organizar os dados necessários para a operação de um sistema de e-commerce. O banco de dados abrange diferentes entidades que são essenciais para o funcionamento de um comércio eletrônico, incluindo clientes (Pessoa Física e Jurídica), produtos, pedidos, pagamentos, vendedores, fornecedores e o gerenciamento de estoque.

Cada entidade é representada por uma tabela no banco de dados, e as relações entre essas entidades são estabelecidas por meio de chaves estrangeiras. Isso permite a integridade referencial e a capacidade de realizar consultas complexas para obter insights detalhados sobre as operações do e-commerce.

### Estrutura do Banco de Dados
O banco de dados é composto por várias tabelas que armazenam informações sobre clientes, produtos, pedidos, pagamentos, vendedores, fornecedores e estoque.

### Tabelas Criadas

1. **Tabela clientPF (Clientes Pessoa Física)**
```sql
CREATE TABLE clientPF (
    idClient INT AUTO_INCREMENT PRIMARY KEY, 
    Fname VARCHAR(10),
    Minit CHAR(3),
    Lname VARCHAR(20),
    CPF CHAR(11) NOT NULL,
    address VARCHAR(30),
    CONSTRAINT unique_cpf_client UNIQUE (CPF)
);

2. **Tabela clientPJ (Clientes Pessoa Jurídica)**
```sql
CREATE TABLE clientPJ (
    idClient INT AUTO_INCREMENT PRIMARY KEY, 
    socialName VARCHAR(255) NOT NULL,
    CNPJ CHAR(15) NOT NULL,
    address VARCHAR(30),
    contact CHAR(11) NOT NULL,
    CONSTRAINT unique_cnpj_client UNIQUE (CNPJ)
);

3. **Tabela product (Produtos)**
```sql
CREATE TABLE product (
    idProduct INT AUTO_INCREMENT PRIMARY KEY, 
    Pname VARCHAR(10) NOT NULL,
    classification_kis BOOL DEFAULT FALSE,
    category ENUM('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis') NOT NULL,
    evaluation FLOAT DEFAULT 0,
    size VARCHAR(10)
);

4. **Tabela payments (Pagamentos)**
```sql
CREATE TABLE payments (
    idPayment INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT,
    typePayment ENUM('Boleto', 'Cartão', 'Dois cartões'),
    limitAvailable FLOAT,
    CONSTRAINT fk_payment_client FOREIGN KEY (idClient) REFERENCES clientPF(idClient)
);

5. **Tabela orders (Pedidos)**
```sql
CREATE TABLE orders (
    idOrder INT AUTO_INCREMENT PRIMARY KEY,
    idOrderClient INT,
    OrderStatus ENUM('Cancelado', 'Confirmado', 'Em processamento') DEFAULT 'Em processamento',
    orderDescription VARCHAR(255),
    orderFreigth FLOAT DEFAULT 10,
    idPaymentCash BOOLEAN DEFAULT FALSE,
    trackingCode VARCHAR(50),
    deliveryStatus ENUM('Enviado', 'Em Trânsito', 'Entregue', 'Cancelado') DEFAULT 'Em Trânsito',
    CONSTRAINT fk_orders_client FOREIGN KEY (idOrderClient) REFERENCES clientPF(idClient)
);

6. **Tabela productStorage (Estoque de Produtos)**
```sql

CREATE TABLE productStorage (
    idProdStorage INT AUTO_INCREMENT PRIMARY KEY,
    storageLocation VARCHAR(255),
    quantidade INT DEFAULT 0
);

7. **Tabela supplier (Fornecedores)**
```sql

CREATE TABLE supplier (
    idSupplier INT AUTO_INCREMENT PRIMARY KEY,
    socialName VARCHAR(255) NOT NULL,
    CNPJ CHAR(15) NOT NULL,
    contact CHAR(11) NOT NULL,
    CONSTRAINT unique_supplier UNIQUE (CNPJ)
);

8. **Tabela seller (Vendedores)**
```sql

CREATE TABLE seller (
    idSeller INT AUTO_INCREMENT PRIMARY KEY,
    socialName VARCHAR(255) NOT NULL,
    abstName VARCHAR(255),
    CNPJ CHAR(15),
    CPF CHAR(11),
    location VARCHAR(255),
    contact CHAR(11) NOT NULL,
    CONSTRAINT unique_cnpj_supplier UNIQUE (CNPJ),
    CONSTRAINT unique_cpf_supplier UNIQUE (CPF)
);

9. **Tabela productSeller (Produto-Vendedor)**
```sql

CREATE TABLE productSeller (
    idPseller INT,
    idPproduct INT,
    prodQuantity INT NOT NULL DEFAULT 1,
    PRIMARY KEY (idPseller, idPproduct),
    CONSTRAINT fk_product_seller FOREIGN KEY (idPseller) REFERENCES seller(idSeller),
    CONSTRAINT fk_product_product FOREIGN KEY (idPproduct) REFERENCES product(idProduct)
);

10. **Tabela productOrder (Produto-Pedido)**
```sql

CREATE TABLE productOrder (
    idPOproduct INT,
    idPOorder INT,
    poQuantity INT DEFAULT 1,
    poStatus ENUM('Disponível', 'Sem estoque') DEFAULT 'Disponível',
    PRIMARY KEY (idPOproduct, idPOorder),
    CONSTRAINT fk_productorder_seller FOREIGN KEY (idPOproduct) REFERENCES product(idProduct),
    CONSTRAINT fk_productorder_product FOREIGN KEY (idPOorder) REFERENCES orders(idOrder)
);

11. **Tabela storageLocation (Localização do Estoque)**
```sql

CREATE TABLE storageLocation (
    idLproduct INT,
    idLstorage INT,
    location VARCHAR(255) NOT NULL,
    PRIMARY KEY (idLproduct, idLstorage),
    CONSTRAINT fk_storage_location_product FOREIGN KEY (idLproduct) REFERENCES product(idProduct),
    CONSTRAINT fk_storage_location_storage FOREIGN KEY (idLstorage) REFERENCES productStorage(idProdStorage)
);

12. **Tabela productSupplier (Produto-Fornecedor)**
```sql

CREATE TABLE productSupplier (
    idPsSupplier INT,
    idPsProduct INT,
    quantity INT NOT NULL,
    PRIMARY KEY (idPsSupplier, idPsProduct),
    CONSTRAINT fk_product_supplier_supplier FOREIGN KEY (idPsSupplier) REFERENCES supplier(idSupplier),
    CONSTRAINT fk_product_supplier_product FOREIGN KEY (idPsProduct) REFERENCES product(idProduct)
);

Inserção de Dados

**Clientes Pessoa Física**
```sql
INSERT INTO clientPF (Fname, Minit, Lname, CPF, address) VALUES
('Alice', 'A', 'Silva', '12345678901', 'Rua A'),
('Bob', 'B', 'Santos', '23456789012', 'Rua B');

**Clientes Pessoa Jurídica**
```sql
INSERT INTO clientPJ (socialName, CNPJ, address, contact) VALUES
('Empresa A', '12345678000195', 'Av. Central', '98765432101'),
('Empresa B', '23456789000185', 'Av. Norte', '99887766554');

**Produtos**
```sql
INSERT INTO product (Pname, classification_kis, category, evaluation, size) VALUES
('Produto X', FALSE, 'Eletrônico', 4.5, 'M'),
('Produto Y', TRUE, 'Brinquedos', 3.8, 'L');

**Pagamentos**
```sql
INSERT INTO payments (idClient, typePayment, limitAvailable) VALUES
(1, 'Cartão', 1000.00),
(2, 'Boleto', 500.00);

**Pedidos**
```sql
INSERT INTO orders (idOrderClient, OrderStatus, orderDescription, orderFreigth, idPaymentCash, trackingCode, deliveryStatus) VALUES
(1, 'Confirmado', 'Descrição do Pedido 1', 15.00, FALSE, 'TRACK123', 'Enviado'),
(2, 'Em processamento', 'Descrição do Pedido 2', 20.00, TRUE, 'TRACK456', 'Em Trânsito');

**Estoque de Produtos**
```sql
INSERT INTO productStorage (storageLocation, quantidade) VALUES
('Armazém 1', 100),
('Armazém 2', 200);

**Fornecedores**
```sql
INSERT INTO supplier (socialName, CNPJ, contact) VALUES
('Fornecedor A', '34567890000174', '11223344556'),
('Fornecedor B', '45678901000163', '22334455667');

**Vendedores**
```sql
INSERT INTO seller (socialName, abstName, CNPJ, CPF, location, contact) VALUES
('Vendedor A', 'Abst A', '56789012000152', NULL, 'Centro', '33445566778'),
('Vendedor B', 'Abst B', NULL, '56789012345', 'Zona Norte', '44556677889');

**Produto-Vendedor**
```sql
INSERT INTO productSeller (idPseller, idPproduct, prodQuantity) VALUES
(1, 1, 50),
(2, 2, 30);

**Produto-Pedido**
```sql
INSERT INTO productOrder (idPOproduct, idPOorder, poQuantity, poStatus) VALUES
(1, 1, 2, 'Disponível'),
(2, 2, 1, 'Sem estoque');

**Localização do Estoque**
```sql
INSERT INTO storageLocation (idLproduct, idLstorage, location) VALUES
(1, 1, 'Prateleira A'),
(2, 2, 'Prateleira B');

**Produto-Fornecedor**
```sql
INSERT INTO productSupplier (idPsSupplier, 

