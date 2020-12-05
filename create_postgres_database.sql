create table campaign_desc(
	campaign_id integer,
	start_day integer,
	end_day integer,
	PRIMARY KEY (campaign_id)
);

CREATE TABLE store(
	store_id integer,
	store_name varchar(100) UNIQUE NOT NULL,
	PRIMARY KEY(store_id)
);


CREATE TABLE age_description(
	age_id integer,
	age varchar(10),
	life_stage varchar(10),
	PRIMARY KEY (age_id)
);

CREATE TABLE marital_status_description(
	marital_status_id integer,
	marital_status varchar(10),
	marital_status_description varchar(10),
	PRIMARY KEY (marital_status_id)
);

CREATE TABLE income_description(
	income_status_id integer,
	income varchar(10),
	income_level varchar(10),
	PRIMARY KEY (income_status_id)
);

CREATE TABLE commodity(
	sub_commodity_id integer,
	sub_commodity varchar(100),
	PRIMARY KEY (sub_commodity_id)
);

CREATE TABLE manufacturer(
	manufacturer_id integer,
	manufacturer_name varchar(100),
	PRIMARY KEY (manufacturer_id)
);

CREATE TABLE household_info(
	household_id integer,
	age integer,
	marital_status_id integer,
	income_status_id integer,
	homeowner varchar(100),
	home_member varchar(50),
	size integer NOT NULL,
	kid_category varchar(10) NOT NULL,
	day integer NOT NULL,
	week_no integer NOT NULL,
	PRIMARY KEY (household_id),
	FOREIGN KEY (age) REFERENCES age_description (age_id),
	FOREIGN KEY (marital_status_id) REFERENCES marital_status_description(marital_status_id),
	FOREIGN KEY (income_status_id) REFERENCES income_description (income_status_id)
);

CREATE TABLE campaign(
	campaign_id integer,
	household_id integer,
	description char(5) CHECK(description in ('TypeA', 'TypeB', 'TypeC')),
	PRIMARY KEY (campaign_id, household_id),
	FOREIGN KEY (campaign_id) REFERENCES campaign_desc(campaign_id),
	FOREIGN KEY (household_id) REFERENCES household_info(household_id)
);

CREATE TABLE product(
	product_id integer,
	manufacturer_id integer,
	brand varchar(50),
	current_size varchar(50),
	sub_commodity_id integer,
	PRIMARY KEY (product_id),
	FOREIGN KEY (manufacturer_id) REFERENCES manufacturer (manufacturer_id),
	FOREIGN KEY (sub_commodity_id) REFERENCES commodity(sub_commodity_id)
);

CREATE TABLE causal_data(
	product_id integer,
	store_id integer,
	week_no integer,
	display integer,
	mailer char(1) CHECK(mailer in ('A', 'B', '0')),
	PRIMARY KEY (product_id, store_id),
	FOREIGN KEY (product_id) REFERENCES product(product_id),
	FOREIGN KEY (store_id) REFERENCES store(store_id)
);


CREATE TABLE coupon(
	coupon_upc integer,
	product_id integer,
	campaign_id integer,
	PRIMARY KEY (coupon_upc),
	FOREIGN KEY (product_id) REFERENCES product(product_id),
	FOREIGN KEY (campaign_id) REFERENCES campaign_desc(campaign_id)
);

CREATE TABLE coupon_redempt(
	household_id integer,
	day integer,
	coupon_upc integer,
	campaign_id integer,
	PRIMARY KEY (household_id, day, coupon_upc),
	FOREIGN KEY (household_id) REFERENCES household_info(household_id),
	FOREIGN KEY (coupon_upc) REFERENCES coupon(coupon_upc),
	FOREIGN KEY (campaign_id) REFERENCES campaign_desc(campaign_id)
);

CREATE TABLE transaction_info(
	trans_id integer,
	household_id integer,
	store_id integer,
	trans_time timestamp NOT NULL,
	day integer NOT NULL,
	week_no integer NOT NULL,
	PRIMARY KEY (trans_id),
	FOREIGN KEY (household_id) REFERENCES household_info (household_id),
	FOREIGN KEY (store_id) REFERENCES store (store_id)
);

CREATE TABLE transaction_product(
	trans_id integer,
	product_id integer,
	quantity integer,
	sale_value numeric(5,2) NOT NULL,
	retail_discount numeric(5,2) DEFAULT 0,
	coupon_disc numeric(5,2) DEFAULT 0,
	coupon_match_disc numeric(5,2) DEFAULT 0, 
	PRIMARY KEY (trans_id,product_id),
	FOREIGN KEY (trans_id) REFERENCES transaction_info (trans_id),
	FOREIGN KEY (product_id) REFERENCES product (product_id)
);
