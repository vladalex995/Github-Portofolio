-- Drop Tables (Ensure Correct Order to Avoid Foreign Key Issues)
DROP TABLE IF EXISTS sales.order_items CASCADE;
DROP TABLE IF EXISTS sales.orders CASCADE;
DROP TABLE IF EXISTS production.stocks CASCADE;
DROP TABLE IF EXISTS production.products CASCADE;
DROP TABLE IF EXISTS production.categories CASCADE;
DROP TABLE IF EXISTS production.brands CASCADE;
DROP TABLE IF EXISTS sales.customers CASCADE;
DROP TABLE IF EXISTS sales.staffs CASCADE;
DROP TABLE IF EXISTS sales.stores CASCADE;

-- Drop Schemas (Ensuring No Dependent Objects Exist)
DROP SCHEMA IF EXISTS sales CASCADE;
DROP SCHEMA IF EXISTS production CASCADE;
