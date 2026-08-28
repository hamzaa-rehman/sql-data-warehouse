# Naming Conventions

This document defines the naming conventions used for schemas, tables, views, columns, and stored procedures in the data warehouse.

---

## Table of Contents

1. [General Principles](#general-principles)
2. [Table Naming Conventions](#table-naming-conventions)

   * [Bronze Layer](#bronze-layer)
   * [Silver Layer](#silver-layer)
   * [Gold Layer](#gold-layer)
3. [Column Naming Conventions](#column-naming-conventions)

   * [Surrogate Keys](#surrogate-keys)
   * [Technical Columns](#technical-columns)
4. [Stored Procedure Naming Conventions](#stored-procedure-naming-conventions)

---

# General Principles

The following principles apply to all database objects:

* **Naming Style:** Use `snake_case` with lowercase letters and underscores (`_`) to separate words.
* **Language:** Use English for all object names.
* **Clarity:** Use descriptive and meaningful names that clearly communicate the purpose of the object.
* **Reserved Words:** Avoid using SQL reserved words as object names.
* **Consistency:** Apply the same naming pattern consistently across all layers of the data warehouse.

---

# Table Naming Conventions

## Bronze Layer

Bronze tables store raw data extracted from source systems. Table names should preserve the original source-system structure to make the origin of the data easy to identify.

### Naming Pattern

```text
<source_system>_<entity>
```

| Component         | Description                                           | Example                 |
| ----------------- | ----------------------------------------------------- | ----------------------- |
| `<source_system>` | Name of the source system.                            | `crm`, `erp`            |
| `<entity>`        | Original entity or table name from the source system. | `cust_info`, `prd_info` |

### Examples

| Table Name      | Description                                           |
| --------------- | ----------------------------------------------------- |
| `crm_cust_info` | Customer information originating from the CRM system. |
| `crm_prd_info`  | Product information originating from the CRM system.  |
| `erp_loc_a101`  | Location information originating from the ERP system. |

---

## Silver Layer

Silver tables contain cleaned, standardized, and transformed data. The table names continue to preserve the source-system identity and original entity naming.

### Naming Pattern

```text
<source_system>_<entity>
```

| Component         | Description                                           | Example                 |
| ----------------- | ----------------------------------------------------- | ----------------------- |
| `<source_system>` | Name of the source system.                            | `crm`, `erp`            |
| `<entity>`        | Original entity or table name from the source system. | `cust_info`, `prd_info` |

### Examples

| Table Name        | Description                                                                |
| ----------------- | -------------------------------------------------------------------------- |
| `crm_cust_info`   | Cleaned and standardized customer information from the CRM system.         |
| `crm_prd_info`    | Cleaned and standardized product information from the CRM system.          |
| `erp_px_cat_g1v2` | Cleaned and standardized product category information from the ERP system. |

---

## Gold Layer

Gold tables and views represent business-ready data designed for analytics, reporting, and decision-making.

Names should be meaningful, business-oriented, and begin with a prefix that identifies the type of object.

### Naming Pattern

```text
<category>_<entity>
```

| Component    | Description                                           | Examples                         |
| ------------ | ----------------------------------------------------- | -------------------------------- |
| `<category>` | Describes the role of the table or view.              | `dim`, `fact`, `report`          |
| `<entity>`   | Business entity or subject represented by the object. | `customers`, `products`, `sales` |

### Examples

| Object Name     | Description                                |
| --------------- | ------------------------------------------ |
| `dim_customers` | Dimension containing customer information. |
| `dim_products`  | Dimension containing product information.  |
| `fact_sales`    | Fact object containing sales transactions. |

### Category Prefix Glossary

| Prefix    | Meaning                                                   | Example                                    |
| --------- | --------------------------------------------------------- | ------------------------------------------ |
| `dim_`    | Dimension table or view.                                  | `dim_customers`, `dim_products`            |
| `fact_`   | Fact table or view containing measurable business events. | `fact_sales`                               |
| `report_` | Reporting or presentation object.                         | `report_customers`, `report_sales_monthly` |

---

# Column Naming Conventions

## Surrogate Keys

Surrogate keys in dimension tables must use the suffix `_key`.

### Naming Pattern

```text
<entity>_key
```

| Component  | Description                                         | Example               |
| ---------- | --------------------------------------------------- | --------------------- |
| `<entity>` | Name of the business entity represented by the key. | `customer`, `product` |
| `_key`     | Indicates a warehouse-generated surrogate key.      | `customer_key`        |

### Examples

| Column Name    | Description                                           |
| -------------- | ----------------------------------------------------- |
| `customer_key` | Surrogate key uniquely identifying a customer record. |
| `product_key`  | Surrogate key uniquely identifying a product record.  |

Foreign keys in fact tables should use the same name as the corresponding surrogate key in the dimension table.

For example:

```text
dim_customers.customer_key
            ▲
            │
fact_sales.customer_key
```

---

## Technical Columns

Technical and system-generated columns should use the prefix `dwh_`.

### Naming Pattern

```text
dwh_<column_name>
```

| Component       | Description                                           | Example     |
| --------------- | ----------------------------------------------------- | ----------- |
| `dwh_`          | Prefix identifying a data warehouse technical column. | `dwh_`      |
| `<column_name>` | Describes the technical purpose of the column.        | `load_date` |

### Examples

| Column Name       | Description                                                  |
| ----------------- | ------------------------------------------------------------ |
| `dwh_load_date`   | Date when the record was loaded into the data warehouse.     |
| `dwh_insert_date` | Date when the record was inserted into the data warehouse.   |
| `dwh_update_date` | Date when the record was last updated in the data warehouse. |

---

# Stored Procedure Naming Conventions

Stored procedures responsible for loading data into the data warehouse should follow a consistent naming pattern.

### Naming Pattern

```text
load_<layer>
```

| Component | Description                                                            | Example                    |
| --------- | ---------------------------------------------------------------------- | -------------------------- |
| `load_`   | Indicates that the stored procedure performs a data-loading operation. | `load_`                    |
| `<layer>` | Identifies the data warehouse layer being loaded.                      | `bronze`, `silver`, `gold` |

### Examples

| Stored Procedure | Description                                               |
| ---------------- | --------------------------------------------------------- |
| `load_bronze`    | Loads raw data into the Bronze layer.                     |
| `load_silver`    | Cleans, transforms, and loads data into the Silver layer. |
| `load_gold`      | Creates or loads business-ready data into the Gold layer. |

---

## Summary

| Object Type       | Naming Pattern             | Example                |
| ----------------- | -------------------------- | ---------------------- |
| Bronze Table      | `<source_system>_<entity>` | `crm_cust_info`        |
| Silver Table      | `<source_system>_<entity>` | `crm_cust_info`        |
| Gold Dimension    | `dim_<entity>`             | `dim_customers`        |
| Gold Fact         | `fact_<entity>`            | `fact_sales`           |
| Report Object     | `report_<entity>`          | `report_sales_monthly` |
| Surrogate Key     | `<entity>_key`             | `customer_key`         |
| Technical Column  | `dwh_<column_name>`        | `dwh_load_date`        |
| Loading Procedure | `load_<layer>`             | `load_bronze`          |
