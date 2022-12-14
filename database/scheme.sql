'
    Database created by: Fredy Rodriguez
    Description: 
    Licence: Creative Commons - CC
'
CREATE DATABASE ubarp;
USE ubarp;

'
    USER DEFINITION
'
CREATE TABLE user (
    user_id uuid UNIQUE NOT NULL DEFAULT uuid_generate_v4 (),
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    last_login TIMESTAMP,
    PRIMARY KEY (user_id)
)

CREATE TABLE country (
    country_id uuid UNIQUE NOT NULL DEFAULT uuid_generate_v4(),
    country VARCHAR(50),
    PRIMARY KEY (country_id)
)

CREATE TABLE department (
    department_id uuid UNIQUE NOT NULL PRIMARY KEY uuid_generate_v4(),
    department VARCHAR(50),
    country uuid NOT NULL,
    PRIMARY KEY (department_id),
    FOREIGN KEY (country) REFERENCES country(country_id)
)

CREATE TABLE municipality (
    municipality_id uuid UNIQUE NOT NULL DEFAULT uuid_generate_v4(),
    municipality VARCHAR(50) NOT NULL,
    department uuid NOT NULL,
    PRIMARY KEY (municipality_id),
    FOREIGN KEY (department) REFERENCES department(department_id)
)

CREATE TABLE uaddress (
    address_id uuid UNIQUE NOT NULL DEFAULT uuid_generate_v4(),
    municipality uuid NOT NULL,
    street_type VARCHAR(10) NOT NULL,
    street_name VARCHAR(10) NOT NULL,
    house_name VARCHAR(10),
    advice VARCHAR(255),
    created_at TIMESTAMP DEFAULT now(),
    PRIMARY KEY (address_id),
    FOREIGN KEY (municipality) REFERENCES municipality(municipality_id)
)

CREATE TABLE userInfo (
    user_id uuid NOT NULL,
    first_name VARCHAR(25) NOT NULL,
    last_name VARCHAR(25) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(10),
    birth_date DATE, 'Only for staff'
    document_type VARCHAR(3),
    identification UNIQUE VARCHAR(10),
    user_address uuid NOT NULL,
    PRIMARY KEY (user_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (user_address) REFERENCES uaddress(address_id)
)

CREATE TABLE roles (
    role_id uuid UNIQUE NOT NULL DEFAULT uuid_generate_v4(),
    role_name VARCHAR(50) UNIQUE NOT NULL,
    PRIMARY KEY (role_id)
)

CREATE TABLE user_roles (
    user_id uuid NOT NULL,
    role_id uuid REFERENCES roles,
    grant_date TIMESTAMP DEFAULT now(),
    PRIMARY KEY (user_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id)
)

CREATE TABLE permission (
     permission_id uuid UNIQUE NOT NULL DEFAULT uuid_generate_v4(),
     permission VARCHAR(255) NOT NULL,
     permission_description TEXT NOT NULL,
     created_at TIMESTAMP DEFAULT now(),
     PRIMARY KEY (permission_id)
)

CREATE TABLE user_permission (
    user_id uuid NOT NULL,
    permission_id uuid NOT NULL,
    grant_date TIMESTAMP DEFAULT now(),
    PRIMARY KEY (user_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (permission_id) REFERENCES permission(permission_id)
)

CREATE TABLE role_permission (
    role_id uuid NOT NULL UNIQUE,
    permission_id uuid NOT NULL,
    grant_date TIMESTAMP DEFAULT now(),
    PRIMARY KEY (role_id),
    FOREIGN KEY (role_id) REFERENCES roles(role_id),
    FOREIGN KEY (permission_id) REFERENCES permission(permission_id)
)

'
    INVENTORY DEFINITION
'

CREATE TABLE supplier (
    supplier_id uuid UNIQUE NOT NULL DEFAULT uuid_generate_v4(),
    supplier_name VARCHAR(70) NOT NULL,
    supplier_email VARCHAR(255),
    supplier_phone VARCHAR(10),
    PRIMARY KEY (supplier_id)
)

CREATE TABLE category (
    category_id uuid UNIQUE NOT NULL DEFAULT uuid_generate_v4(),
    category_name VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT now(),
    PRIMARY KEY (category_id)
)

CREATE TABLE product (
    product_id uuid UNIQUE NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_code VARCHAR(100) NOT NULL, 'Bar code'
    product_name VARCHAR(50) NOT NULL,
    product_description VARCHAR(255),
    product_stock SMALLINT NOT NULL, 'Quantity on stock'
    product_price NUMERIC(15,5), 'Purchase price'
    product_selling_price NUMERIC(15,5), 'Selling price'
    product_size VARCHAR(75),
    product_weight NUMERIC(7,3), 'Food'
    product_color VARCHAR(50), 'For clothing'
    product_detail VARCHAR(30),
    product_image VARCHAR(255), 'Image path'
    product_supplier_id uuid NOT NULL,
    product_category uuid NOT NULL,
    product_status BOOLEAN, 'Is the product Active'
    product_added_at TIMESTAMP DEFAULT now(),
    PRIMARY KEY (product_id),
    FOREIGN KEY (product_supplier_id) REFERENCES supplier(supplier_id),
    FOREIGN KEY (product_category) REFERENCES category(category_id)
)

'
    SALES DEFINITION
'

CREATE TABLE payment_method (
    payment_method_id uuid UNIQUE NOT NULL DEFAULT uuid_generate_v4(),
    payment_method VARCHAR(50),
    payment_method_description VARCHAR(255),  'Cash/Card/BankAccount/Credit/...'
    PRIMARY KEY (payment_id)

CREATE TABLE order (
    order_id uuid UNIQUE NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_number SMALLINT,
    order_seller uuid NOT NULL,
    order_customer uuid NOT NULL,
    order_created_at TIMESTAMP DEFAULT now(),    
    order_status BOOLEAN NOT NULL, 'Order is not paid'
    PRIMARY KEY (order_id),
    FOREIGN KEY (order_seller) REFERENCES user(user_id),
    FOREIGN KEY (order_customer) REFERENCES user(user_id)    
)

CREATE TABLE order_detail (
    order_id uuid NOT NULL,
    product uuid NOT NULL,
    quantity SMALLINT,
    unit_price NUMERIC(15,5), 'Selling price - Product/product_selling_price'
    PRIMARY KEY (order_id),
    FOREIGN KEY (order_id) REFERENCES order(order_id),
    FOREIGN KEY (product) REFERENCES product(product_id)
)

CREATE TABLE payment (
    payment_id uuid UNIQUE NOT NULL DEFAULT uuid_generate_v4(),
    order uuid NOT NULL,
    customer uuid NOT NULL,
    order_payment_method uuid NOT NULL,
    payment_date TIMESTAMP DEFAULT now(),
    PRIMARY KEY (payment_id),
    FOREIGN KEY (order) REFERENCES order(order_id),
    FOREIGN KEY (customer) REFERENCES user(user_id),
    FOREIGN KEY (order_payment_method) REFERENCES payment_method(payment_method_id)
)

'Only for restaurants/bars/coffe shop/'
CREATE TABLE customer_table (
    table_id uuid UNIQUE NOT NULL DEFAULT uuid_generate_v4(),
    table_number SMALLINT,
    table_chair SMALLINT,
    table_description VARCHAR(255),
    PRIMARY KEY (table_id)
)

CREATE TABLE order_table (
    order_table_id uuid NOT NULL,
    order_table uuid NOT NULL,
    order_table_time TIMESTAMP,
    PRIMARY KEY (order_table_id),
    FOREIGN KEY (order_table_id) REFERENCES order(order_id),
    FOREIGN KEY (order_table) REFERENCES customer_table(table_id)
)

CREATE TABLE reservation (
    reservation_id uuid UNIQUE NOT NULL DEFAULT uuid_generate_v4(),
    reservation_customer uuid NOT NULL,
    reservation_table uuid NOT NULL,
    reservation_date DATE NOT NULL,
    reservation_hour TIME NOT NULL,
    PRIMARY KEY (reservation_id),
    FOREIGN KEY (reservation_customer) REFERENCES user(user_id),
    FOREIGN KEY (reservation_table) REFERENCES customer_table(table_id)
)
