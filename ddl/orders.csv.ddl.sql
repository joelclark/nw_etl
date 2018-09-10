DROP TABLE IF EXISTS unload.orders;

CREATE TABLE unload.orders (
  id numeric,
  employee_id numeric,
  customer_id numeric,
  order_date date,
  shipped_date date,
  shipper_id numeric,
  ship_name text,
  ship_address text,
  ship_city text,
  ship_state_province text,
  ship_zip_postal_code text,
  ship_country_region text,
  shipping_fee numeric,
  taxes numeric,
  payment_type text,
  paid_date date,
  notes text,
  tax_rate numeric,
  tax_status_id numeric,
  status_id numeric,
  status_name text
);
