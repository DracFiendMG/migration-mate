-- =============================================
-- MigrationMate Demo Schema (Idempotent)
-- Drops and recreates all tables with sample data.
-- =============================================

-- Drop tables in reverse dependency order
DROP TABLE IF EXISTS reviews CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS legacy_flags CASCADE;
DROP TABLE IF EXISTS profiles CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- =============================================
-- Create tables
-- =============================================

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  phone TEXT,
  email TEXT UNIQUE,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE profiles (
  user_id INT PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  phone TEXT,
  bio TEXT,
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  description TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  category_id INT REFERENCES categories(id) ON DELETE SET NULL,
  name TEXT NOT NULL,
  price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
  stock_quantity INT NOT NULL DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id) ON DELETE CASCADE,
  amount NUMERIC(10,2) NOT NULL,
  status TEXT DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE order_items (
  id SERIAL PRIMARY KEY,
  order_id INT REFERENCES orders(id) ON DELETE CASCADE,
  product_id INT REFERENCES products(id) ON DELETE SET NULL,
  quantity INT NOT NULL CHECK (quantity > 0),
  unit_price NUMERIC(10,2) NOT NULL,
  discount NUMERIC(5,2) DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE reviews (
  id SERIAL PRIMARY KEY,
  product_id INT REFERENCES products(id) ON DELETE CASCADE,
  user_id INT REFERENCES users(id) ON DELETE SET NULL,
  rating INT CHECK (rating BETWEEN 1 AND 5),
  comment TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE legacy_flags (
  id SERIAL PRIMARY KEY,
  flag_name TEXT,
  is_enabled BOOLEAN DEFAULT false
);

-- =============================================
-- Insert sample data
-- =============================================

INSERT INTO users (name, phone, email) VALUES
('Alice', '111-111', 'alice@example.com'),
('Bob', '222-222', 'bob@example.com'),
('Carol', '333-333', 'carol@example.com');

INSERT INTO profiles (user_id, phone, bio) VALUES
(1, '111-111', 'Alice bio'),
(2, '222-222', 'Bob bio'),
(3, NULL, 'Carol bio');

INSERT INTO categories (name, description) VALUES
('Electronics', 'Gadgets and devices'),
('Books', 'Physical and digital books'),
('Clothing', 'Apparel and accessories');

INSERT INTO products (category_id, name, price, stock_quantity) VALUES
(1, 'Smartphone X', 799.99, 100),
(1, 'Laptop Pro 15', 1999.00, 50),
(2, 'SQL Performance Explained', 29.99, 200),
(3, 'Cotton T-Shirt', 19.99, 500);

INSERT INTO orders (user_id, amount, status) VALUES
(1, 829.98, 'completed'),
(2, 2028.99, 'pending'),
(3, 19.99, 'completed');

INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount) VALUES
(1, 1, 1, 799.99, 0),
(1, 3, 1, 29.99, 0),
(2, 2, 1, 1999.00, 0),
(2, 3, 1, 29.99, 0),
(3, 4, 1, 19.99, 0);

INSERT INTO reviews (product_id, user_id, rating, comment) VALUES
(1, 1, 5, 'Excellent phone!'),
(2, 2, 4, 'Great laptop but heavy.'),
(4, 3, 5, 'Very comfortable.');

-- Optional: deliberately missing indexes to demonstrate migration
-- (no index on orders.created_at, etc.)

CREATE INDEX idx_orders_created_at ON orders(created_at);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_products_category_id ON products(category_id);