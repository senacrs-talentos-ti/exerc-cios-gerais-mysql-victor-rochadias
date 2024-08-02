create table clientes(
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR (50)not null,
    email varchar(100)not null
    );
    
   
    create table PRODUCTS(
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR (50)not null,
    price decimal(10,2)not null
    );



CREATE TABLE ORDERS (
    id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT,
    order_date DATE NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (client_id) REFERENCES clientes(id) 
);


CREATE TABLE ORDERS_items (
    order_id INT,
    product_id INT,
    quantity  int NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

INSERT INTO clientes (nome, email) VALUES
('nicolas', 'nicolas.p.valer@gmail.com'),
('cr7', 'cr7realmadri2025@gmail.com'),
('carlos', 'carlos@gmail.com');

insert into products (nome, price) values
('sofa', 699.99),
('Tv smart 24 pol' , 1800.90),
('mesa' , 500.90);

insert into orders (client_id, order_date, total) values
(1, '2024-05-22', 699.99 ),
(3, '2024-07-25', 500.99),
(2, '2023-12-16', 699.99);

insert into orders_items (order_id, product_id, quantity, price) values
(1, 1, 1 ,699.99),
(3, 3, 1 ,500.90),
(2, 1, 12 ,8399.88);

UPDATE PRODUCTS
SET price = CASE
    WHEN nome = 'sofa' THEN 749.99
    WHEN nome = 'Tv smart 24 pol' THEN 1899.99
    WHEN nome = 'mesa' THEN 749.99
END
WHERE nome IN ('sofa', 'Tv smart 24 pol', 'mesa');


UPDATE orders_items
SET price = CASE
    WHEN order_id = 1 THEN 749.99
    WHEN order_id = 2 THEN 8999.88
    WHEN order_id = 3 THEN 749.99
END
WHERE order_id IN (1, 2, 3);

DELETE FROM ORDERS_items WHERE order_id IN (SELECT id FROM ORDERS WHERE client_id = 1);
DELETE FROM ORDERS WHERE client_id = 1;
DELETE FROM clientes WHERE id = 1;

ALTER TABLE ORDERS
ADD COLUMN birthdate DATE;

select clientes.nome as Cliente, products.nome as Produto, orders.id as NroPedido
FROM clientes
inner join orders on clientes.id = orders.client_id
inner join orders_items on orders_items.order_id = orders.id
inner join products on orders_items.product_id = products.id;

SELECT 
    c.id AS ClienteID,
    c.nome AS NomeCliente,
    c.email AS EmailCliente,
    o.id AS PedidoID,
    o.order_date AS DataPedido,
    o.total AS TotalPedido,
    p.nome AS NomeProduto,
    oi.quantity AS Quantidade,
    oi.price AS PrecoUnitario
FROM clientes c
LEFT JOIN orders o ON c.id = o.client_id
LEFT JOIN orders_items oi ON o.id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.id
ORDER BY c.id, o.id;


SELECT 
    c.id AS ClienteID,
    c.nome AS NomeCliente,
    c.email AS EmailCliente,
    o.id AS PedidoID,
    o.order_date AS DataPedido,
    o.total AS TotalPedido,
    p.nome AS NomeProduto,
    oi.quantity AS Quantidade,
    oi.price AS PrecoUnitario
FROM clientes c
right JOIN orders o ON c.id = o.client_id
right JOIN orders_items oi ON o.id = oi.order_id
right JOIN products p ON oi.product_id = p.id
ORDER BY c.id, o.id;


SELECT 
    SUM(quantity ) AS total_vendas,
    SUM(quantity) AS quantity_total_itens
FROM orders_items;

SELECT 
    c.nome AS nome_cliente,
    COUNT(o.id) AS quantidade_pedidos
FROM 
    clientes c
LEFT JOIN 
    orders o ON c.id = o.client_id
GROUP BY 
    c.id, c.nome
ORDER BY 
    quantidade_pedidos DESC;
    
    SELECT 
    p.id AS produto_id,
    p.nome AS nome_produto,
    SUM(oi.quantity) AS quantidade_total
FROM 
    products p
INNER JOIN 
    orders_items oi ON p.id = oi.product_id
GROUP BY 
    p.id, p.nome
ORDER BY 
    quantidade_total DESC;
    
    SELECT 
    c.id AS cliente_id,
    c.nome AS nome_cliente,
    SUM(o.total) AS valor_total_gasto
FROM 
    clientes c
LEFT JOIN 
    orders o ON c.id = o.client_id
GROUP BY 
    c.id, c.nome
ORDER BY 
    valor_total_gasto DESC;
    
    SELECT 
    p.id AS produto_id,
    p.nome AS nome_produto,
    SUM(oi.quantity) AS quantidade_total,
    SUM(oi.quantity * oi.price) AS total_vendas
FROM 
    products p
INNER JOIN 
    orders_items oi ON p.id = oi.product_id
GROUP BY 
    p.id, p.nome
ORDER BY 
    quantidade_total DESC
LIMIT 3;

SELECT 
    c.id AS cliente_id,
    c.nome AS nome_cliente,
    AVG(pedido_produtos.quantidade_total) AS media_quantidade_produtos_por_pedido
FROM 
    clientes c
LEFT JOIN 
    (SELECT 
        o.client_id,
        o.id AS pedido_id,
        SUM(oi.quantity) AS quantidade_total
     FROM 
        orders o
     LEFT JOIN 
        orders_items oi ON o.id = oi.order_id
     GROUP BY 
        o.client_id, o.id
    ) pedido_produtos ON c.id = pedido_produtos.client_id
GROUP BY 
    c.id, c.nome
ORDER BY 
    media_quantidade_produtos_por_pedido DESC;



SELECT 
    YEAR(o.order_date) AS ano,
    MONTH(o.order_date) AS mes,
    COUNT(DISTINCT o.id) AS total_pedidos,
    COUNT(DISTINCT c.id) AS total_clientes
FROM 
    orders o
LEFT JOIN 
    clientes c ON o.client_id = c.id
GROUP BY 
    YEAR(o.order_date), MONTH(o.order_date)
ORDER BY 
    ano, mes;
    
    
    SELECT 
    p.id AS produto_id,
    p.nome AS nome_produto
FROM 
    products p
LEFT JOIN 
    orders_items oi ON p.id = oi.product_id
WHERE 
    oi.product_id IS NULL;
    
    
    
    SELECT 
    o.id AS pedido_id,
    COUNT(DISTINCT oi.product_id) AS numero_itens_diferentes
FROM 
    orders o
JOIN 
    orders_items oi ON o.id = oi.order_id
GROUP BY 
    o.id
HAVING 
    COUNT(DISTINCT oi.product_id) > 2;
    
    
    SELECT DISTINCT
    c.id AS cliente_id,
    c.nome AS nome_cliente,
    c.email AS email_cliente
FROM 
    clientes c
JOIN 
    orders o ON c.id = o.client_id
WHERE 
    o.order_date >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
    AND o.order_date < CURDATE();
    
    
    SELECT 
    c.id AS cliente_id,
    c.nome AS nome_cliente,
    AVG(o.total) AS valor_medio_por_pedido
FROM 
    clientes c
JOIN 
    orders o ON c.id = o.client_id
GROUP BY 
    c.id, c.nome
ORDER BY 
    valor_medio_por_pedido DESC;
