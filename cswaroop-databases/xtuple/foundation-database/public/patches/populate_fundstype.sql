INSERT INTO fundstype (
  fundstype_code,
  fundstype_name,
  fundstype_descrip,
  fundstype_creditcard,
  fundstype_external,
  fundstype_prepay
)
SELECT
  'C',
  'Check',
  'Payment by Check',
  FALSE,
  FALSE,
  FALSE
WHERE NOT EXISTS (
  SELECT 1 FROM fundstype WHERE fundstype_code = 'C'
);

INSERT INTO fundstype (
  fundstype_code,
  fundstype_name,
  fundstype_descrip,
  fundstype_creditcard,
  fundstype_external,
  fundstype_prepay
)
SELECT
  'T',
  'Certified Check',
  'Payment by Certified Check',
  FALSE,
  FALSE,
  FALSE
WHERE NOT EXISTS (
  SELECT 1 FROM fundstype WHERE fundstype_code = 'T'
);

INSERT INTO fundstype (
  fundstype_code,
  fundstype_name,
  fundstype_descrip,
  fundstype_creditcard,
  fundstype_external,
  fundstype_prepay
)
SELECT
  'M',
  'Master Card',
  'Payment by Master Card credit card',
  TRUE,
  TRUE,
  TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM fundstype WHERE fundstype_code = 'M'
);

INSERT INTO fundstype (
  fundstype_code,
  fundstype_name,
  fundstype_descrip,
  fundstype_creditcard,
  fundstype_external,
  fundstype_prepay
)
SELECT
  'V',
  'Visa',
  'Payment by Visa credit card',
  TRUE,
  TRUE,
  TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM fundstype WHERE fundstype_code = 'V'
);

INSERT INTO fundstype (
  fundstype_code,
  fundstype_name,
  fundstype_descrip,
  fundstype_creditcard,
  fundstype_external,
  fundstype_prepay
)
SELECT
  'A',
  'American Express',
  'Payment by American Express credit card',
  TRUE,
  TRUE,
  TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM fundstype WHERE fundstype_code = 'A'
);

INSERT INTO fundstype (
  fundstype_code,
  fundstype_name,
  fundstype_descrip,
  fundstype_creditcard,
  fundstype_external,
  fundstype_prepay
)
SELECT
  'D',
  'Discover Card',
  'Payment by Discover Card credit card',
  TRUE,
  TRUE,
  TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM fundstype WHERE fundstype_code = 'D'
);

INSERT INTO fundstype (
  fundstype_code,
  fundstype_name,
  fundstype_descrip,
  fundstype_creditcard,
  fundstype_external,
  fundstype_prepay
)
SELECT
  'R',
  'Other Credit Card',
  'Payment by Other credit card',
  TRUE,
  FALSE,
  FALSE
WHERE NOT EXISTS (
  SELECT 1 FROM fundstype WHERE fundstype_code = 'R'
);

INSERT INTO fundstype (
  fundstype_code,
  fundstype_name,
  fundstype_descrip,
  fundstype_creditcard,
  fundstype_external,
  fundstype_prepay
)
SELECT
  'K',
  'Cash',
  'Payment by Cash',
  FALSE,
  FALSE,
  FALSE
WHERE NOT EXISTS (
  SELECT 1 FROM fundstype WHERE fundstype_code = 'K'
);

INSERT INTO fundstype (
  fundstype_code,
  fundstype_name,
  fundstype_descrip,
  fundstype_creditcard,
  fundstype_external,
  fundstype_prepay
)
SELECT
  'W',
  'Wire Transfer',
  'Payment by Wire Transfer',
  FALSE,
  FALSE,
  FALSE
WHERE NOT EXISTS (
  SELECT 1 FROM fundstype WHERE fundstype_code = 'W'
);

INSERT INTO fundstype (
  fundstype_code,
  fundstype_name,
  fundstype_descrip,
  fundstype_creditcard,
  fundstype_external,
  fundstype_prepay
)
SELECT
  'O',
  'Other',
  'Other Payment method',
  FALSE,
  FALSE,
  FALSE
WHERE NOT EXISTS (
  SELECT 1 FROM fundstype WHERE fundstype_code = 'O'
);
