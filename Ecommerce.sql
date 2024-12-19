-- Criação do Banco de Dados e Tabelas
-- Criação do Banco de Dados

-- drop database ecommerce;
create database ecommerce;
use ecommerce;
SHOW TABLES; 
show databases;

-- Tabela cliente PF
select * from clientPF;
create table clientPF (
    idClient int auto_increment primary key, 
    Fname varchar(10),
    Minit char(3),
    Lname varchar(20),
    CPF char(11) not null,
    address varchar(30),
    constraint unique_cpf_client unique (CPF)
);

-- Tabela cliente PJ
select * from clientPJ;
create table clientPJ (
    idClient int auto_increment primary key, 
    socialName varchar(255) not null,
    CNPJ char(15) not null,
    address varchar(30),
    contact char(11) not null,
    constraint unique_cnpj_client unique (CNPJ)
);

-- Tabela produto
select * from product;
-- delete from product where idProduct = 2;
-- drop table product;
create table product (
    idProduct int auto_increment primary key, 
    Pname varchar(10) not null,
    classification_kis bool default false,
    category enum('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis') not null,
    evaluation float default 0,
    size varchar(10)
);

-- Tabela pagamentos
select * from payments;
create table payments (
    idPayment int auto_increment primary key,
    idClient int,
    typePayment enum('Boleto', 'Cartão', 'Dois cartões'),
    limitAvailable float,
    constraint fk_payment_client foreign key (idClient) references clientPF(idClient)
);

-- Tabela pedidos
select * from orders;
create table orders (
    idOrder int auto_increment primary key,
    idOrderClient int,
    OrderStatus enum('Cancelado', 'Confirmado', 'Em processamento') default 'Em processamento',
    orderDescription varchar(255),
    orderFreigth float default 10,
    idPaymentCash boolean default false,
    trackingCode varchar(50),
    deliveryStatus enum('Enviado', 'Em Trânsito', 'Entregue', 'Cancelado') default 'Em Trânsito',
    constraint fk_orders_client foreign key (idOrderClient) references clientPF(idClient)
);

-- Tabela estoque
select * from productStorage;
create table productStorage (
    idProdStorage int auto_increment primary key,
    storageLocation varchar(255),
    quantidade int default 0
);

-- Tabela fornecedor
select * from supplier;
create table supplier (
    idSupplier int auto_increment primary key,
    socialName varchar(255) not null,
    CNPJ char(15) not null,
    contact char(11) not null,
    constraint unique_supplier unique (CNPJ)
);

-- Tabela vendedor
select * from seller;
create table seller (
    idSeller int auto_increment primary key,
    socialName varchar(255) not null,
    abstName varchar(255),
    CNPJ char(15),
    CPF char(11),
    location varchar(255),
    contact char(11) not null,
    constraint unique_cnpj_supplier unique (CNPJ),
    constraint unique_cpf_supplier unique (CPF)
);
-- ******
-- Tabela produto-vendedor
select * from productSeller;
create table productSeller (
    idPseller int,
    idPproduct int,
    prodQuantity int not null default 1,
    primary key (idPseller, idPproduct),
    constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
    constraint fk_product_product foreign key (idPproduct) references product(idProduct)
);

-- Tabela produto-pedido
select * from productOrder;
create table productOrder (
    idPOproduct int,
    idPOorder int,
    poQuantity int default 1,
    poStatus enum('Disponível', 'Sem estoque') default 'Disponível',
    primary key (idPOproduct, idPOorder),
    constraint fk_productorder_seller foreign key (idPOproduct) references product(idProduct),
    constraint fk_productorder_product foreign key (idPOorder) references orders(idOrder)
);

-- Tabela localização do estoque
select * from storageLocation;
create table storageLocation (
    idLproduct int,
    idLstorage int,
    location varchar(255) not null,
    primary key (idLproduct, idLstorage),
    constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct),
    constraint fk_storage_location_storage foreign key (idLstorage) references productStorage(idProdStorage)
);

-- Tabela produto-fornecedor
select * from productSupplier;
create table productSupplier (
    idPsSupplier int,
    idPsProduct int,
    quantity int not null,
    primary key (idPsSupplier, idPsProduct),
    constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(idSupplier),
    constraint fk_product_supplier_product foreign key (idPsProduct) references product(idProduct)
);

-- Inserção de Dados para Testes
-- Inserção de Dados de Exemplo:

-- Inserção de dados na tabela clientPF
select * from clientPF;
insert into clientPF (Fname, Minit, Lname, CPF, address)
values 
('João', 'A.', 'Silva', '12345678901', 'Rua A, 123'),
('Maria', 'B.', 'Oliveira', '23456789012', 'Rua B, 234');

-- Inserção de dados na tabela clientPJ
select * from clientPJ;
insert into clientPJ (socialName, CNPJ, address, contact)
values 
('Empresa X', '12345678000199', 'Avenida C, 456', '11987654321'),
('Empresa Y', '23456789000288', 'Avenida D, 567', '21987654321');

-- Inserção de dados na tabela product
select * from product;
insert into product (Pname, classification_kis, category, evaluation, size)
values 
('Smartphone', false, 'Eletrônico', 4.5, '10x5cm'),
('Camiseta', false, 'Vestimenta', 4.0, 'M'),
('Boneca', false, 'Brinquedos', 3.8, '30cm'),
('Biscoito', false, 'Alimentos', 4.2, '500g'),
('Cadeira', false, 'Móveis', 4.1, '60x60x80cm');

-- Inserção de dados na tabela payments
select * from payments;
insert into payments (idClient, typePayment, limitAvailable)
values 
(1, 'Cartão', 1000.00),
(2, 'Boleto', 500.00);

-- Inserção de dados na tabela orders
select * from orders;
insert into orders (idOrderClient, OrderStatus, orderDescription, orderFreigth, idPaymentCash, trackingCode, deliveryStatus)
values 
(1, 'Confirmado', 'Compra de Smartphone', 20.00, false, 'TR123456', 'Enviado'),
(2, 'Cancelado', 'Compra de Biscoito', 10.00, false, 'TR654321', 'Cancelado');

-- Inserção de dados na tabela productStorage
select * from productStorage;
insert into productStorage (storageLocation, quantidade)
values 
('Depósito A', 100),
('Depósito B', 200);

-- Inserção de dados na tabela supplier
select * from supplier;
insert into supplier (socialName, CNPJ, contact)
values 
('Fornecedor A', '34567890000177', '31987654321'),
('Fornecedor B', '45678901000266', '41987654321');

-- Inserção de dados na tabela seller
select * from seller;
insert into seller (socialName, abstName, CNPJ, CPF, location, contact)
values 
('Vendedor A', 'VA', '56789012000355', '34567890123', 'Rua E, 789', '51987654321'),
('Vendedor B', 'VB', '67890123000444', '45678901234', 'Rua F, 890', '61987654321');

-- Inserção de dados na tabela productSeller
select * from productSeller;
insert into productSeller (idPseller, idPproduct, prodQuantity)
values 
(1, 4, 50),
(2, 2, 30);

-- Parei aqui
-- Inserção de dados na tabela productOrder
select * from productOrder;
insert into productOrder (idPOproduct, idPOorder, poQuantity, poStatus)
values 
(1, 1, 1, 'Disponível'),
(2, 2, 1, 'Sem estoque');

-- Inserção de dados na tabela storageLocation
select * from storageLocation;
insert into storageLocation (idLproduct, idLstorage, location)
values 
(1, 1, 'Seção A'),
(2, 2, 'Seção B');

-- Inserção de dados na tabela productSupplier
select * from productSupplier;
insert into productSupplier (idPsSupplier, idPsProduct, quantity)
values 
(1, 1, 100),
(2, 2, 200);


-- Consultas SQL

-- Quantos pedidos foram feitos por cada cliente?
SELECT idOrderClient, COUNT(idOrder) AS numOrders 
FROM orders 
GROUP BY idOrderClient;

-- Algum vendedor também é fornecedor?
SELECT seller.socialName 
FROM seller 
JOIN supplier ON seller.CNPJ = supplier.CNPJ;

-- Relação de produtos, fornecedores e estoques:
SELECT product.Pname, supplier.socialName, productStorage.quantidade 
FROM product 
JOIN productSupplier ON product.idProduct = productSupplier.idPsProduct 
JOIN supplier ON productSupplier.idPsSupplier = supplier.idSupplier 
JOIN productStorage ON product.idProduct = productStorage.idProdStorage;

-- Relação de nomes dos fornecedores e nomes dos produtos:
SELECT supplier.socialName, product.Pname 
FROM supplier 
JOIN productSupplier ON supplier.idSupplier = productSupplier.idPsSupplier 
JOIN product ON productSupplier.idPsProduct = product.idProduct;

-- Recuperações simples com SELECT Statement
SELECT Fname, Minit, Lname, CPF FROM clientPF;

-- Filtros com WHERE Statement
SELECT Pname FROM product WHERE category = 'Eletrônico';

-- Criação de expressões para gerar atributos derivados
SELECT Pname, quantidade * 10 AS ValorEstoque 
FROM product 
JOIN productStorage ON product.idProduct = productStorage.idProdStorage;

-- Definição de ordenações dos dados com ORDER BY
SELECT Pname FROM product ORDER BY Pname;

-- Condições de filtros aos grupos – HAVING Statement
SELECT idOrderClient, COUNT(idOrder) AS TotalOrders 
FROM orders 
GROUP BY idOrderClient 
HAVING COUNT(idOrder) > 1;

-- Junções entre tabelas para fornecer uma perspectiva mais complexa dos dados
SELECT clientPF.Fname AS ClienteNome, seller.socialName AS VendedorNome 
FROM orders 
JOIN clientPF ON orders.idOrderClient = clientPF.idClient 
JOIN productOrder ON orders.idOrder = productOrder.idPOorder 
JOIN seller ON productOrder.idPOproduct = seller.idSeller;






