# Data Catalog for Gold Layer

## Overview

The **Gold Layer** is the business-ready layer of the data warehouse. It contains clean, integrated, and analytics-ready data designed for reporting, dashboards, and business analysis.

The Gold Layer follows a **dimensional data model** consisting of:

* **Dimension tables** — Store descriptive information about business entities.
* **Fact tables** — Store measurable business transactions and metrics.

---

## `gold.dim_customers`

### Purpose

Stores customer information enriched with demographic and geographic attributes. This dimension supports the analysis of business metrics by customer characteristics.

### Columns

| Column Name       | Data Type    | Description                                                                        |
| ----------------- | ------------ | ---------------------------------------------------------------------------------- |
| `customer_key`    | INT          | Surrogate key that uniquely identifies each customer record in the data warehouse. |
| `customer_id`     | INT          | Original customer identifier from the source system.                               |
| `customer_number` | NVARCHAR(50) | Business identifier used to track and reference customers.                         |
| `first_name`      | NVARCHAR(50) | Customer's first name.                                                             |
| `last_name`       | NVARCHAR(50) | Customer's last name or family name.                                               |
| `country`         | NVARCHAR(50) | Customer's country of residence.                                                   |
| `marital_status`  | NVARCHAR(50) | Customer's marital status, such as Married or Single.                              |
| `gender`          | NVARCHAR(50) | Customer's gender, such as Male, Female, or n/a.                                   |
| `birthdate`       | DATE         | Customer's date of birth.                                                          |
| `create_date`     | DATE         | Date when the customer record was created in the source system.                    |

---

## `gold.dim_products`

### Purpose

Stores descriptive information about products, including categories, subcategories, costs, and product lines. This dimension supports the analysis of business metrics by product attributes.

### Columns

| Column Name            | Data Type    | Description                                                                       |
| ---------------------- | ------------ | --------------------------------------------------------------------------------- |
| `product_key`          | INT          | Surrogate key that uniquely identifies each product record in the data warehouse. |
| `product_id`           | INT          | Original product identifier from the source system.                               |
| `product_number`       | NVARCHAR(50) | Business identifier used to identify and reference products.                      |
| `product_name`         | NVARCHAR(50) | Descriptive name of the product.                                                  |
| `category_id`          | NVARCHAR(50) | Identifier representing the product category.                                     |
| `category`             | NVARCHAR(50) | High-level classification of the product.                                         |
| `subcategory`          | NVARCHAR(50) | Detailed classification of the product within its category.                       |
| `maintenance_required` | NVARCHAR(50) | Indicates whether the product requires maintenance.                               |
| `cost`                 | INT          | Cost of the product in monetary units.                                            |
| `product_line`         | NVARCHAR(50) | Product line or series to which the product belongs.                              |
| `start_date`           | DATE         | Date when the product became active or available in the system.                   |

---

## `gold.fact_sales`

### Purpose

Stores transactional sales data at the sales line-item level. It contains measurable business metrics and connects sales transactions with customer and product dimensions.

### Columns

| Column Name     | Data Type    | Description                                                     |
| --------------- | ------------ | --------------------------------------------------------------- |
| `order_number`  | NVARCHAR(50) | Unique identifier representing a sales order.                   |
| `product_key`   | INT          | Surrogate key linking the sales record to `gold.dim_products`.  |
| `customer_key`  | INT          | Surrogate key linking the sales record to `gold.dim_customers`. |
| `order_date`    | DATE         | Date when the customer placed the order.                        |
| `shipping_date` | DATE         | Date when the order was shipped.                                |
| `due_date`      | DATE         | Date when the order was due.                                    |
| `sales_amount`  | INT          | Total monetary value of the sales line item.                    |
| `quantity`      | INT          | Number of product units included in the sales line item.        |
| `price`         | INT          | Price per unit of the product.                                  |

---

## Relationships

The Gold Layer follows a star-schema structure:

```text id="w0olkm"
                gold.dim_customers
                ──────────────────
                 customer_key (PK)
                        │
                        │
                        ▼
                  gold.fact_sales
                  ───────────────
                  customer_key (FK)
                  product_key  (FK)
                        ▲
                        │
                        │
                 product_key (PK)
                ──────────────────
                 gold.dim_products
```

| Fact Table        | Foreign Key    | Dimension Table      | Referenced Key |
| ----------------- | -------------- | -------------------- | -------------- |
| `gold.fact_sales` | `customer_key` | `gold.dim_customers` | `customer_key` |
| `gold.fact_sales` | `product_key`  | `gold.dim_products`  | `product_key`  |
