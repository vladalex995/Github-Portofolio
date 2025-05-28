-- Creating Production Schema
CREATE SCHEMA IF NOT EXISTS production;

-- Creating Sales Schema
CREATE SCHEMA IF NOT EXISTS sales;

-- Creating Categories Table
CREATE TABLE production.categories (
	category_id SERIAL PRIMARY KEY,
	category_name VARCHAR(255) NOT NULL
);

-- Creating Brands Table
CREATE TABLE production.brands (
	brand_id SERIAL PRIMARY KEY,
	brand_name VARCHAR(255) NOT NULL
);

-- Creating Products Table
CREATE TABLE production.products (
	product_id SERIAL PRIMARY KEY,
	product_name VARCHAR(255) NOT NULL,
	brand_id INT NOT NULL,
	category_id INT NOT NULL,
	model_year SMALLINT NOT NULL CHECK (model_year >= 2000), -- Ensuring a valid year
	list_price DECIMAL(10,2) NOT NULL CHECK (list_price >= 0),
	FOREIGN KEY (category_id) REFERENCES production.categories (category_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (brand_id) REFERENCES production.brands (brand_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Creating Customers Table
CREATE TABLE sales.customers (
	customer_id SERIAL PRIMARY KEY,
	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
	phone VARCHAR(25),
	email VARCHAR(255) NOT NULL UNIQUE,
	street VARCHAR(255),
	city VARCHAR(50),
	state VARCHAR(25),
	zip_code VARCHAR(10)
);

-- Creating Stores Table
CREATE TABLE sales.stores (
	store_id SERIAL PRIMARY KEY,
	store_name VARCHAR(255) NOT NULL,
	phone VARCHAR(25),
	email VARCHAR(255),
	street VARCHAR(255),
	city VARCHAR(255),
	state VARCHAR(10),
	zip_code VARCHAR(10)
);

-- Creating Staffs Table
CREATE TABLE sales.staffs (
	staff_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	email VARCHAR(255) NOT NULL UNIQUE,
	phone VARCHAR(25),
	active SMALLINT NOT NULL CHECK (active IN (0,1)), -- Enforcing binary status (0 = Inactive, 1 = Active)
	store_id INT NOT NULL,
	manager_id INT,
	FOREIGN KEY (store_id) REFERENCES sales.stores (store_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (manager_id) REFERENCES sales.staffs (staff_id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Creating Orders Table
CREATE TABLE sales.orders (
	order_id SERIAL PRIMARY KEY,
	customer_id INT REFERENCES sales.customers (customer_id) ON DELETE CASCADE ON UPDATE CASCADE,
	order_status SMALLINT NOT NULL CHECK (order_status BETWEEN 1 AND 4),
	-- Order status: 1 = Pending, 2 = Processing, 3 = Rejected, 4 = Completed
	order_date DATE NOT NULL,
	required_date DATE NOT NULL,
	shipped_date DATE,
	store_id INT NOT NULL REFERENCES sales.stores (store_id) ON DELETE CASCADE ON UPDATE CASCADE,
	staff_id INT NOT NULL REFERENCES sales.staffs (staff_id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Creating Order Items Table
CREATE TABLE sales.order_items (
	order_id INT NOT NULL REFERENCES sales.orders (order_id) ON DELETE CASCADE ON UPDATE CASCADE,
	item_id SERIAL NOT NULL,
	product_id INT NOT NULL REFERENCES production.products (product_id) ON DELETE CASCADE ON UPDATE CASCADE,
	quantity INT NOT NULL CHECK (quantity > 0),
	list_price DECIMAL(10,2) NOT NULL CHECK (list_price >= 0),
	discount DECIMAL(4,2) DEFAULT 0 NOT NULL CHECK (discount BETWEEN 0 AND 1),
	PRIMARY KEY (order_id, item_id)
);

-- Creating Stocks Table
CREATE TABLE production.stocks (
	store_id INT NOT NULL REFERENCES sales.stores (store_id) ON DELETE CASCADE ON UPDATE CASCADE,
	product_id INT NOT NULL REFERENCES production.products (product_id) ON DELETE CASCADE ON UPDATE CASCADE,
	quantity INT CHECK (quantity >= 0),
	PRIMARY KEY (store_id, product_id)
);
