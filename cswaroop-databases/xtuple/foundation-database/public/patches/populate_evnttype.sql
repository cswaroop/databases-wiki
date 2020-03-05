INSERT INTO evnttype (evnttype_name, evnttype_descrip, evnttype_module)
       SELECT 'QuoteConvertedToSO', 'Converted a Quote to a Sales Order', 'S/O'
       WHERE NOT EXISTS (SELECT 1 FROM evnttype WHERE evnttype_name = 'QuoteConvertedToSO');

INSERT INTO evnttype (evnttype_name, evnttype_descrip, evnttype_module)
       SELECT 'QuoteConvertedToInvoice', 'Converted a Quote to an Invoice', 'S/O'
       WHERE NOT EXISTS (SELECT 1 FROM evnttype WHERE evnttype_name = 'QuoteConvertedToInvoice');
