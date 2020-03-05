-- http://modern-sql.com/


-- LATERAL the for loop

SELECT c.*
FROM categories c
LEFT JOIN LATERAL
(
  SELECT * FROM products p WHERE p.category_id = c.id
) ON (true)

-- Top N per group


SELECT c.*
FROM categories c
LEFT JOIN LATERAL
(
  SELECT * FROM products p WHERE p.category_id = c.id
  ORDER BY price
  LIMIT 10
) ON (true)
;

-- GROUPING SETS

SELECT year
     , month
     , SUM(revenue)
FROM orders
GROUP BY
GROUPING SETS(
	 (year, month),
	 (year)
)
;


-- with ROLLUP and CUBE

-- ??


