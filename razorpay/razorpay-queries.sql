CREATE TABLE razorpay (id SERIAL PRIMARY KEY, doc_type text, doc jsonb);

INSERT INTO razorpay VALUES (DEFAULT, 'order_payment',
$$
{  "id":"order_DaaS6LOUAASb7Y",  "entity":"order",  "amount":2200,  "amount_paid":0,  "amount_due":2200,  "currency":"INR",  "receipt":"Receipt #211",  "offer_id":null,  "status":"attempted",  "attempts":1,  "notes":{    "key1":"value3",    "key2":"value2"  },  "created_at":1572505143}

$$);

INSERT INTO razorpay VALUES (DEFAULT, 'customer',
$$
{  "id" : "cust_0000000001",  "entity": "customer",  "name" : "Cornelius",  "email" : "cornelius1990@gmail.com",  "contact" : "9000000000",  "notes" : {},  "created_at ": 1234567890}
$$);

INSERT INTO razorpay VALUES (DEFAULT, 'order',
$$
{  "id":"order_DaZlswtdcn9UNV",  "entity":"order",  "amount":50000,  "amount_paid":0,  "amount_due":50000,  "currency":"INR",  "receipt":"Receipt #20",  "status":"created",  "attempts":0,  "notes":[],  "created_at":1572502745}
$$);

INSERT INTO razorpay VALUES (DEFAULT, 'payment',
$$
{  "id": "pay_29QQoUBi66xm2f",  "entity": "payment",  "amount": 5000,  "currency": "INR",  "status": "captured",  "method": "card",  "order_id": "order_CjCr5oKh4AVC51",  "description": "Payment for Adidas shoes",  "amount_refunded": 0,  "refund_status": null,  "email": "gaurav.kumar@example.com",  "contact": "9364591752",  "notes": [],  "fee": 1145,  "tax": 145,  "error_code": null,  "error_description": null,  "created_at": 1400826750}
$$);

INSERT INTO razorpay VALUES (DEFAULT, 'settlement',
$$
{  "id": "pay_29QQoUBi66xm2f",  "entity": "payment",  "amount": 5000,  "currency": "INR",  "status": "captured",  "method": "card",  "order_id": "order_CjCr5oKh4AVC51",  "description": "Payment for Adidas shoes",  "amount_refunded": 0,  "refund_status": null,  "email": "gaurav.kumar@example.com",  "contact": "9364591752",  "notes": [],  "fee": 1145,  "tax": 145,  "error_code": null,  "error_description": null,  "created_at": 1400826750}

$$);

INSERT INTO razorpay VALUES (DEFAULT, 'settlement_recon',
$$
{  "entity": "collection",  "count": 2,  "items": [    {      "entity_id": "pay_9rvIMJo4sJkwB7",      "type": "payment",      "debit": 0,      "credit": 48750,      "amount": 59900,      "currency": "INR",      "fee": 1250,      "tax": 0,      "on_hold": false,      "settled": true,      "created_at": 1478067659,      "settled_at": 1478075346,      "settlement_id": "setl_9uGt8OcMCeAEiR",      "description": "Settlement based on the invoice no. #inv_9rvHBJrv2Oluwh",      "notes": "{}",      "payment_id": "pay_9rvIMJo4sJkwB7",      "settlement_utr": "KKBKH14156891582",      "order_id": "order_9rvHBMFeGlrEp4",      "order_receipt": "BILL13375649",      "method": "card",      "card_network": "Visa",      "card_issuer": "YESB",      "card_type": "credit",      "dispute_id": null    },    {      "entity_id": "pay_9ruIfMiMmbZ6fx",      "type": "payment",      "debit": 0,      "credit": 97,      "amount": 19900,      "currency": "INR",      "fee": 3,      "tax": 0,      "on_hold": false,      "settled": true,      "created_at": 1478067659,      "settled_at": 1478075346,      "settlement_id": "setl_9uGt8OcMCeAEiR",      "description": "Invoice #inv_9ruFmsK63rBrG7",      "notes": "{}",      "payment_id": "pay_9ruIfMiMmbZ6fx",      "settlement_utr": "KKBKH14156891582",      "order_id": "order_9ruGFg9yNKWjfS",      "order_receipt": "BILL13375640",      "method": "card",      "card_network": "Visa",      "card_issuer": "YESB",      "card_type": "credit",      "dispute_id": null    }  ]}

$$);

INSERT INTO razorpay VALUES (DEFAULT, 'payment_refunds',
$$

{  "count": 2,  "entity": "collection",  "items": [    {      "id": "rfnd_AABBdHIieexn5c",      "entity": "refund",      "amount": 100,      "currency": "INR",      "payment_id": "pay_29QQoUBi66xm2f",      "notes": [],      "receipt": null,      "acquirer_data": {          "rrn": "931912812404"  },      "created_at": 1500826750    },    {      "id": "rfnd_19btGlBig6xZ2f",      "entity": "refund",      "amount": 100,      "currency": "INR",      "payment_id": "pay_29QQoUBi66xm2f",      "notes": [],      "receipt": null,      "acquirer_data": {          "rrn": "931912812404"  },      "created_at": 1500826750    }  ]}
$$);

INSERT INTO razorpay VALUES (DEFAULT, 'invoice',
$$
{
    "id": "inv_gHQwerty123ggd",
    "entity": "invoice",
    "receipt": null,
    "customer_id": "cust_gHQwerty123ggd",
    "customer_details": {
        "name": "Gaurav Kumar",
        "email": "gaurav.kumar@example.com",
        "contact": "9123456789",
        "billing_address": {
            "line1": "318 C-Wing, Suyog Co. Housing Society Ltd., T.P.S Road, Vazira, Borivali",
            "city": "West Mumbai",
            "state": "Maharashtra",
            "zipcode": "400092",
            "country": "India"},

        "customer_name": null,
        "customer_email": "gaurav.kumar@example.com",
        "customer_contact": "9123456789"
    },
    "order_id": "order_gHQwerty123ggd",
    "line_items": [
        {
            "id": "li_gHQwerty123ggd",
            "item_id": "item_gHQwerty123gg1",
            "name": "Book / English August",
            "description": "Funny story of an IAS officer wanting to be aything other than an IAS.",
            "amount": 20000,
            "unit_amount": 20000,
            "gross_amount": 20000,
            "tax_amount": 0,
            "net_amount": 20000,
            "currency": "INR",
            "type": "invoice",
            "tax_inclusive": false,
            "unit": null,
            "quantity": 1,
            "taxes": []
        },
        {
            "id": "li_gHQwerty123ggg",
            "item_id": "item_gHQwerty123gg2",
            "name": "Book / A Wild Sheep Chase",
            "description": "A Wild Sheep Chase is the third novel by Japanese author Haruki Murakami.",
            "amount": 20000,
            "unit_amount": 20000,
            "gross_amount": 20000,
            "tax_amount": 0,
            "net_amount": 20000,
            "currency": "INR",
            "type": "invoice",
            "tax_inclusive": false,
            "unit": null,
            "quantity": 1,
            "taxes": []
        }
    ],
    "payment_id": null,
    "status": "issued",
    "expire_by": null,
    "issued_at": 1488446398,
    "paid_at": null,
    "cancelled_at": null,
    "expired_at": null,
    "sms_status": "pending",
    "email_status": "pending",
    "date": 1505937098,
    "terms": null,
    "partial_payment": false,
    "gross_amount": 20000,
    "tax_amount": 0,
    "amount": 20000,
    "amount_paid": 0,
    "amount_due": 20000,
    "currency": "INR",
    "description": null,
    "notes": [],
    "comment": null,
    "short_url": "http://rzp.io/w4ahvtz",
    "view_less": true,
    "billing_start": null,
    "billing_end": null,
    "type": "invoice",
    "group_taxes_discounts": false,
    "user_id": null,
    "created_at": 1505935715
}
$$);

INSERT INTO razorpay VALUES (DEFAULT, 'subscription_plan',
$$
{  "id": "plan_00000000000001",  "entity": "plan",  "interval": 1,  "period": "weekly",  "item": {    "active": true,    "name": "Test Weekly 1 plan",    "description": "Description for the weekly 1 plan",    "amount": 600,    "currency": "INR",    "type": "plan"  },  "notes": {    "notes_key": "Beam me up Scotty"  },  "created_at": 1495995837}

$$);

INSERT INTO razorpay VALUES (DEFAULT, 'subscriptions',
$$
{  "id": "sub_00000000000001",  "entity": "subscription",  "plan_id": "plan_00000000000001",  "customer_id": "cust_D00000000000001",  "status": "active",  "current_start": 1577355871,  "current_end": 1582655400,  "ended_at": null,  "quantity": 1,  "notes":{    "notes_key": "Beam me up Scotty"  },  "charge_at": 1577385991,  "start_at": 1577385991,  "end_at": 1603737000,  "auth_attempts": 0,  "total_count": 6,  "paid_count": 1,  "customer_notify": true,  "created_at": 1577356081,  "expire_by": 1577485991,  "short_url": "https://rzp.io/i/z3b1R61A9",  "has_scheduled_changes": false,  "change_scheduled_at": null,  "remaining_count": 5}
$$);

INSERT INTO razorpay VALUES (DEFAULT, 'addon',
$$

{  "id": "ao_00000000000001",  "entity": "addon",  "item": {    "id": "item_00000000000001",    "active": true,    "name": "Extra Chair",    "description": null,    "amount": 30000,    "unit_amount": 30000,    "currency": "INR",    "type": "addon",    "unit": null,    "tax_inclusive": false,    "tax_id": null,    "tax_group_id": null,    "created_at": 1507733751,    "updated_at": 1507733751  },  "quantity": 2,  "created_at": 1507733751,  "subscription_id": "sub_00000000000001",  "invoice_id": null}

$$);

INSERT INTO razorpay VALUES (DEFAULT, 'payment_links',
$$

{    "id": "inv_8fZLnkhkbr74PA",    "entity": "invoice",    "receipt": null,    "customer_id": "cust_8fX1NZkgHRziE0",    "customer_details": {        "name": null,        "email": "gaurav.kumar@example.com",        "contact": "9888888888",        "billing_address": null    },    "order_id": "order_8fZLnnY8WCti5v",    "line_items": [],    "payment_id": null,    "status": "issued",    "expire_by": null,    "issued_at": 1505907531,    "paid_at": null,    "cancelled_at": null,    "expired_at": null,    "sms_status": "pending",    "email_status": "pending",    "date": 1505907531,    "partial_payment": false,    "terms":"Terms and condition of the service",    "gross_amount": 1000,    "tax_amount": 0,    "amount": 1000,    "amount_paid": 0,    "amount_due": 1000,    "currency": "INR",    "description": "Cloud computing course fees",    "notes": [],    "comment": null,    "short_url": "https://rzp.io/i/ltnGtvf",    "view_less": true,    "type": "link",    "user_id": null,    "created_at": 1505907531}

$$);

INSERT INTO razorpay VALUES (DEFAULT, 'smart_collect',
$$
 { "id": "va_4xbQrmEoA5WJ0G",  "entity": "virtual_account",  "description": "First Virtual Account",  "customer_id": "cust_805c8oBQdBGPwS",  "status": "active",  "amount_paid": 0,  "notes": {    "reference_key": "reference_value"  },  "receivers": [    {      "id": "ba_4lsdkfldlteskf",      "entity": "bank_account",      "name": "Merchant Billing Label",      "account_number": "123321987789",      "ifsc": "RZPB0000001"    }  ],  "created_at": 1455696638}

$$);


INSERT INTO razorpay VALUES (DEFAULT, 'routes',
$$

{  "entity": "collection",  "count": 2,  "items": [    {      "id": "trf_6ydVYyzaICeIw5",      "entity": "transfer",      "source": "pay_6ydSup2U7aFMsA",      "recipient": "acc_a1b2c3d4e5f6g7",      "amount": 10000,      "currency": "INR",      "amount_reversed": 0,      "on_hold": false,      "created_at": 1482996461    },    {      "id": "trf_6ydVZ7a3z4q50q",      "entity": "transfer",      "source": "pay_6ydSup2U7aFMsA",      "recipient": "acc_21t2c3gafu4sa2",      "amount": 5000,      "currency": "INR",      "amount_reversed": 0,      "on_hold": false,      "created_at": 1482996461    }  ]}

$$);



INSERT INTO razorpay VALUES (DEFAULT, 'items',
$$
{  "id": "item_7Oxp4hmm6T4SCn",  "active": true,  "name": "Book / English August",  "description": "An indian story, Booker prize winner.",  "amount": 20000,  "currency": "INR"}

$$);


