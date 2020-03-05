SELECT dropIfExists('VIEW', 'cashreceiptapply', 'api');
CREATE OR REPLACE VIEW api.cashreceiptapply AS
  SELECT
    cust_number::VARCHAR AS customer_number,
    getFundsTypeName(cashrcpt_fundstype)::VARCHAR AS funds_type,
    cashrcpt_docnumber::VARCHAR AS check_document_number,
    aropen_doctype::VARCHAR AS doc_type,
    aropen_docnumber::VARCHAR AS doc_number,
    cust_name AS customer_name,
    addr_line1 AS customer_address,
    formatDate(aropen_docdate) AS doc_date,
    formatDate(aropen_duedate) AS due_date,
    curr_abbr AS currency,
    aropen_amount AS open_amount,
    cashrcptitem_amount AS amount_to_apply,
    cashrcptitem_discount
  FROM cashrcptitem
    LEFT OUTER JOIN cashrcpt ON (cashrcpt_id=cashrcptitem_cashrcpt_id)
    LEFT OUTER JOIN custinfo ON (cust_id=cashrcpt_cust_id)
    LEFT OUTER JOIN cntct mc ON (custinfo.cust_cntct_id = mc.cntct_id)
    LEFT OUTER JOIN addr m ON (mc.cntct_addr_id = m.addr_id)
    LEFT OUTER JOIN curr_symbol ON (curr_id=cashrcpt_curr_id)
    LEFT OUTER JOIN aropen ON (aropen_id=cashrcptitem_aropen_id);

GRANT ALL ON TABLE api.cashreceiptapply TO xtrole;
COMMENT ON VIEW api.cashreceiptapply IS '
This view can be used as an interface to import Cash Receipt Application data directly
into the system.  Required fields will be checked and default values will be
populated';

--Rules

CREATE OR REPLACE RULE "_INSERT" AS
  ON INSERT TO api.cashreceiptapply DO INSTEAD

  INSERT INTO cashrcptitem (
    cashrcptitem_cashrcpt_id,
    cashrcptitem_aropen_id,
    cashrcptitem_amount,
    cashrcptitem_discount
    )
  VALUES (
    getCashrcptId(NEW.customer_number,
                  CASE
                    WHEN NEW.funds_type='Check' THEN 'C'
                    WHEN NEW.funds_type='Certified Check' THEN 'T'
                    WHEN NEW.funds_type='Master Card' THEN 'M'
                    WHEN NEW.funds_type='Visa' THEN 'V'
                    WHEN NEW.funds_type='American Express' THEN 'A'
                    WHEN NEW.funds_type='Discover Card' THEN 'D'
                    WHEN NEW.funds_type='Other Credit Card' THEN 'R'
                    WHEN NEW.funds_type='Cash' THEN 'K'
                    WHEN NEW.funds_type='Wire Transfer' THEN 'W'
                    ELSE 'O'
                  END,
                  NEW.check_document_number),
    getAropenId(NEW.customer_number,
                NEW.doc_type,
                NEW.doc_number),
    COALESCE(NEW.amount_to_apply, 0),
    COALESCE(NEW.cashrcptitem_discount, 0)
    );

CREATE OR REPLACE RULE "_UPDATE" AS
  ON UPDATE TO api.cashreceiptapply DO INSTEAD

  UPDATE cashrcptitem SET
    cashrcptitem_amount=NEW.amount_to_apply,
    cashrcptitem_discount=NEW.cashrcptitem_discount
    WHERE ( (cashrcptitem_cashrcpt_id=getCashrcptId(
                       OLD.customer_number,
                       CASE
                         WHEN OLD.funds_type='Check' THEN 'C'
                         WHEN OLD.funds_type='Certified Check' THEN 'T'
                         WHEN OLD.funds_type='Master Card' THEN 'M'
                         WHEN OLD.funds_type='Visa' THEN 'V'
                         WHEN OLD.funds_type='American Express' THEN 'A'
                         WHEN OLD.funds_type='Discover Card' THEN 'D'
                         WHEN OLD.funds_type='Other Credit Card' THEN 'R'
                         WHEN OLD.funds_type='Cash' THEN 'K'
                         WHEN OLD.funds_type='Wire Transfer' THEN 'W'
                         ELSE 'O'
                       END,
                       OLD.check_document_number))
      AND   (cashrcptitem_aropen_id=getAropenId(
                       OLD.customer_number,
                       OLD.doc_type,
                       OLD.doc_number)) );

CREATE OR REPLACE RULE "_DELETE" AS
  ON DELETE TO api.cashreceiptapply DO INSTEAD

    DELETE FROM cashrcptitem
    WHERE ( (cashrcptitem_cashrcpt_id=getCashrcptId(
                       OLD.customer_number,
                       CASE
                         WHEN OLD.funds_type='Check' THEN 'C'
                         WHEN OLD.funds_type='Certified Check' THEN 'T'
                         WHEN OLD.funds_type='Master Card' THEN 'M'
                         WHEN OLD.funds_type='Visa' THEN 'V'
                         WHEN OLD.funds_type='American Express' THEN 'A'
                         WHEN OLD.funds_type='Discover Card' THEN 'D'
                         WHEN OLD.funds_type='Other Credit Card' THEN 'R'
                         WHEN OLD.funds_type='Cash' THEN 'K'
                         WHEN OLD.funds_type='Wire Transfer' THEN 'W'
                         ELSE 'O'
                       END,
                       OLD.check_document_number))
      AND   (cashrcptitem_aropen_id=getAropenId(
                       OLD.customer_number,
                       OLD.doc_type,
                       OLD.doc_number)) );
