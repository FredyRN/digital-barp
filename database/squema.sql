'
    Database created by: Fredy Rodriguez
    Nickname: F3deR1c0
    Description: 
    Licence: Creative Commons - CC
'
CREATE DATABASE ubarp;
USE ubarp;

'
    USER DEFINITION
'
CREATE TABLE user (
    user_id uuid PRIMARY KEY UNIQUE NOT NULL DEFAULT uuid_generate_v4 (),
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT now()
    last_login TIMESTAMP
)

CREATE TABLE country (
    country_id uuid UNIQUE NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
    country VARCHAR(50)
)

CREATE TABLE deparment (
    dpt_id uuid UNIQUE NOT NULL PRIMARY KEY uuid_generate_v4(),
    department VARCHAR(50)
    country uuid REFERENCES country
)

CREATE TABLE municipality (
    municipality_id uuid UNIQUE NOT NULL PRIMARY KEY uuid_generate_v4(),
    municipality VARCHAR(50) NOT NULL,
    deparment uuid REFERENCES deparment
)

CREATE TABLE address (
    address_id uuid UNIQUE NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
    municipality uuid NOT NULL REFERENCES municipality
    street_type VARCHAR(10) NOT NULL,
    street_name VARCHAR(10) NOT NULL,
    house_name VARCHAR(10),
    advice VARCHAR(255),
    created_at TIMESTAMP DEFAULT now()
)

CREATE TABLE userInfo (
    user_id uuid PRIMARY KEY REFERENCES user,
    first_name VARCHAR(25) NOT NULL,
    last_name VARCHAR(25) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL UNIQUE,
    phone VARCHAR(10),
    birth_date DATE NOT NULL,
    document_type VARCHAR(3),
    identification UNIQUE VARCHAR(10)
    user_address uuid REFERENCES address
)

CREATE TABLE roles (
    role_id uuid UNIQUE NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
    role_name VARCHAR(50) UNIQUE NOT NULL
)

CREATE TABLE user_roles (
    user_id uuid PRIMARY KEY REFERENCES user,
    role_id uuid REFERENCES roles,
    grant_date TIMESTAMP DEFAULT now()
)

CREATE TABLE permission (
     permission_id uuid UNIQUE NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
     permission VARCHAR(255) NOT NULL,
     permission_text TEXT NOT NULL,
     created_at TIMESTAMP DEFAULT now()
)

CREATE TABLE user_permission (
    user_id uuid PRIMARY KEY REFERENCES user,
    permission_id uuid REFERENCES permission
    grant_date TIMESTAMP DEFAULT now()
)

CREATE TABLE role_permission (
    role_id uuid PRIMARY KEY REFERENCES roles,
    permission_id uuid REFERENCES permission,
    grant_date TIMESTAMP DEFAULT now()
)

'
    INVENTORY DEFINITION
'

CREATE TABLE supplier (
    supplier_id uuid UNIQUE NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
    supplier_name VARCHAR(70) NOT NULL,
    supplier_email VARCHAR(255),
    supplier_phone VARCHAR(10)
)

CREATE TABLE category (
    category_id uuid UNIQUE NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
    category_name VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT now()
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
    product_supplier_id uuid REFERENCES supplier,
    product_category uuid REFERENCES category
    product_status BOOLEAN, 'Is the product Active'
)

'
    SALES DEFINITION
'

CREATE TABLE payment_method (
    payment_id uuid UNIQUE NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
    payment_method VARCHAR(50),
    payment_method_description VARCHAR(255)  'Cash/Card/BankAccount/Credit/...'
)

CREATE TABLE order (
    order_id uuid UNIQUE NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_seller uuid REFERENCES user,
    order_custumer uuid REFERENCES user,
    order_created_at TIMESTAMP DEFAULT now(),
    order_payment_method uuid REFERENCES payment_method,
    order_status BOOLEAN NOT NULL 'Order is not paid'
)

CREATE TABLE order_detail (
    order_id uuid PRIMARY KEY REFERENCES order,
    product uuid REFERENCES product,
    quantity SMALLINT,
    unit_price NUMERIC(15,5)
)

CREATE TABLE payment (
    payment_id uuid UNIQUE NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
    order uuid REFERENCES order
    custumer uuid REFERENCES user,
    payment_date TIMESTAMP DEFAULT now(),
)

'Only for restaurants/bars/coffe shop/'
CREATE TABLE custumer_table (
    table_id uuid UNIQUE NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
    table_number SMALLINT,
    table_chair SMALLINT,
    table_description VARCHAR(255)
)

CREATE TABLE order_table (
    order_id uuid REFERENCES order,
    order_table uuid REFERENCES custumer_table
)

CREATE TABLE reservation (
    reservation_id uuid UNIQUE NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
    reservation_custumer uuid REFERENCES user NOT NULL,
    reservation_table uuid REFERENCES custumer_table,
    reservation_date DATE NOT NULL,
    reservation_hour TIME NOT NULL
)
