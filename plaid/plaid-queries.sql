insert into plaid values (default, 'sample',
$$

$$
);

insert into plaid values (default, 'webhook_response',
$$
{
  "webhook_type": "ITEM",
  "webhook_code": "WEBHOOK_UPDATE_ACKNOWLEDGED",
  "item_id": "wz666MBjYWTp2PDzzggYhM6oWWmBb",
  "error": null,
  "new_webhook_url": "https://plaid.com/example/webhook"
}
$$
);

insert into plaid values (default, 'item_error_webhook',
$$
{
  "webhook_type": "ITEM",
  "webhook_code": "ERROR",
  "item_id": "wz666MBjYWTp2PDzzggYhM6oWWmBb",
  "error": {
    "display_message": "The provided credentials were not correct. Please try again.",
    "error_code": "ITEM_LOGIN_REQUIRED",
    "error_message": "the provided credentials were not correct",
    "error_type": "ITEM_ERROR",
    "status": 400
  }
}
$$
);


insert into plaid values (default, 'income_ready_webhook',
$$
{
  "webhook_type": "INCOME",
  "webhook_code": "PRODUCT_READY",
  "item_id": "wz666MBjYWTp2PDzzggYhM6oWWmBb",
  "error": null
}
$$
);

insert into plaid values (default, 'income_ready_webhook',
$$
{
  "webhook_type": "INCOME",
  "webhook_code": "PRODUCT_READY",
  "item_id": "wz666MBjYWTp2PDzzggYhM6oWWmBb",
  "error": null
}
$$
);


insert into plaid values (default, 'auth_response',
$$
{
  "accounts": [{
    "account_id": "vzeNDwK7KQIm4yEog683uElbp9GRLEFXGK98D",
    "balances": {
      "available": 100,
      "current": 110,
      "limit": null,
      "iso_currency_code": "USD",
      "unofficial_currency_code": null
    },
    "mask": "9606",
    "name": "Plaid Checking",
    "official_name": "Plaid Gold Checking",
    "subtype": "checking",
    "type": "depository"
  }],
  "numbers": {
    "ach": [{
      "account": "9900009606",
      "account_id": "vzeNDwK7KQIm4yEog683uElbp9GRLEFXGK98D",
      "routing": "011401533",
      "wire_routing": "021000021"
    }],
    "eft":[{
      "account": "111122223333",
      "account_id": "vzeNDwK7KQIm4yEog683uElbp9GRLEFXGK98D",
      "institution": "021",
      "branch": "01140"
    }],
    "international":[{
      "account_id": "vzeNDwK7KQIm4yEog683uElbp9GRLEFXGK98D",
      "bic": "NWBKGB21",
      "iban": "GB29NWBK60161331926819"
    }],
    "bacs":[{
      "account": "31926819",
      "account_id": "vzeNDwK7KQIm4yEog683uElbp9GRLEFXGK98D",
      "sort_code": "601613"
    }]
  },
  "item": {},
  "request_id": "m8MDnv9okwxFNBV"
}
$$
);


insert into plaid values (default, 'transaction_response',
$$
{
 "accounts": [{}],
 "transactions": [{
    "account_id": "vokyE5Rn6vHKqDLRXEn5fne7LwbKPLIXGK98d",
    "amount": 2307.21,
    "iso_currency_code": "USD",
    "unofficial_currency_code": null,
    "category": [
      "Shops",
      "Computers and Electronics"
    ],
    "category_id": "19013000",
    "date": "2017-01-29",
    "authorized_date": "2017-01-27",
    "location": {
     "address": "300 Post St",
     "city": "San Francisco",
     "region": "CA",
     "postal_code": "94108",
     "country": "US",
     "lat": null,
     "lon": null,
     "store_number": "1235"
    },
    "name": "Apple Store",
    "payment_meta": {},
    "payment_channel": "in store",
    "pending": false,
    "pending_transaction_id": null,
    "account_owner": null,
    "transaction_id": "lPNjeW1nR6CDn5okmGQ6hEpMo4lLNoSrzqDje",
    "transaction_type": "place"
   }, {
    "account_id": "XA96y1wW3xS7wKyEdbRzFkpZov6x1ohxMXwep",
    "amount": 78.5,
    "iso_currency_code": "USD",
    "unofficial_currency_code": null,
    "category": [
      "Food and Drink",
      "Restaurants"
    ],
    "category_id": "13005000",
    "date": "2017-01-29",
    "authorized_date": "2017-01-28",
    "location": {
      "address": "262 W 15th St",
      "city": "New York",
      "region": "NY",
      "postal_code": "10011",
      "country": "US",
      "lat": 40.740352,
      "lon": -74.001761,
      "store_number": "455"
    },
    "name": "Golden Crepes",
    "payment_meta": {},
    "payment_channel": "in store",
    "pending": false,
    "pending_transaction_id": null,
    "account_owner": null,
    "transaction_id": "4WPD9vV5A1cogJwyQ5kVFB3vPEmpXPS3qvjXQ",
    "transaction_type": "place"
  }],
  "item": {},
  "total_transactions": 3,
  "request_id": "45QSn"
}

$$
);


insert into plaid values (default, 'balance_response',
$$
{
  "accounts": [{
     "account_id": "QKKzevvp33HxPWpoqn6rI13BxW4awNSjnw4xv",
     "balances": {
       "available": 100,
       "current": 110,
       "limit": null,
       "iso_currency_code": "USD",
       "unofficial_currency_code": null
     },
     "mask": "0000",
     "name": "Plaid Checking",
     "official_name": "Plaid Gold Checking",
     "subtype": "checking",
     "type": "depository"
  }],
  "item": {},
  "request_id": "m8MDnv9okwxFNBV"
}
$$
);


insert into plaid values (default, 'identity_response',
$$
{
  "accounts": [
    {
      "owners": [
        {
          "addresses": [
            {
              "data": {
                "city": "Malakoff",
                "region": "NY",
                "street": "2992 Cameron Road",
                "postal_code": "14236",
                "country": "US"
              },
              "primary": true
            },
            {
              "data": {
                "city": "San Matias",
                "region": "CA",
                "street": "2493 Leisure Lane",
                "postal_code": "93405-2255",
                "country": "US"
              },
              "primary": false
            }
          ],
          "emails": [
            {
              "data": "accountholder0@example.com",
              "primary": true,
              "type": "primary"
            }
          ],
          "names": [
            "Alberta Bobbeth Charleson"
          ],
          "phone_numbers": [{
            "primary": true,
            "type": "home",
            "data": "4673956022"
          }]
        }
      ]
    }
  ],
  "item": {},
  "request_id": "m8MDnv9okwxFNBV"
}
$$
);

insert into plaid values (default, 'income_response',
$$
{
  "item": {},
  "income": {
    "income_streams": [
      {
        "confidence": 1,
        "days": 518,
        "monthly_income": 1601,
        "name": "PLAID"
      },
      {
        "confidence": 0.95,
        "days": 415,
        "monthly_income": 1530,
        "name": "BAGUETTES INC"
      }
    ],
    "last_year_income": 28072,
    "last_year_income_before_tax": 38681,
    "projected_yearly_income": 19444,
    "projected_yearly_income_before_tax": 26291,
    "max_number_of_overlapping_income_streams": 2,
    "number_of_income_streams": 2
  },
  "request_id": "m8MDnv9okwxFNBV"
}
$$
);

/*
$$
{
  client_report_id: '123',
  webhook: 'https://www.example.com',
  user: {
    client_user_id: '789',
    first_name: 'Jane',
    middle_name: 'Leah',
    last_name: 'Doe',
    ssn: '123-45-6789',
    phone_number: '(555) 123-4567',
    email: 'jane.doe@example.com',
  },
}
$$
*/


insert into plaid values (default, 'assetreport_response',
$$
{
  "report": {
    "asset_report_id": "c5b638f9-02b8-45c6-9093-552195149b0c",
    "client_report_id": "123456",
    "date_generated": "2018-04-12T03:32:11Z",
    "days_requested": 730,
    "items": [
      {
        "accounts": [
          {
            "account_id": "jW4r4QvdeXcAZNj8J3Dni68DqxQ3laHZwGyBD",
            "balances": {
              "available": 100,
              "current": 110
            },
            "days_available": 730,
            "historical_balances": [
              {
                "current": 110,
                "date": "2018-04-12",
                "iso_currency_code": "USD",
                "unofficial_currency_code": null
              },
              {
                "current": 110,
                "date": "2018-04-11",
                "iso_currency_code": "USD",
                "unofficial_currency_code": null
              },
              {
                "current": 110,
                "date": "2018-04-10",
                "iso_currency_code": "USD",
                "unofficial_currency_code": null
              }
            ],
            "mask": "0000",
            "name": "Plaid Checking",
            "official_name": "Plaid Gold Standard 0% Interest Checking",
            "owners": [
              {
                "addresses": [
                  {
                    "data": {
                      "city": "Malakoff",
                      "region": "NY",
                      "street": "2992 Cameron Road",
                      "postal_code": "14236",
                      "country": "US"
                    },
                    "primary": true
                  },
                  {
                    "data": {
                      "city": "San Matias",
                      "region": "CA",
                      "street": "2493 Leisure Lane",
                      "postal_code": "93405-2255",
                      "country": "US"
                    },
                    "primary": false
                  }
                ],
                "emails": [
                  {
                    "data": "accountholder0@example.com",
                    "primary": true,
                    "type": "primary"
                  },
                  {
                    "data": "accountholder1@example.com",
                    "primary": false,
                    "type": "secondary"
                  },
                  {
                    "data": "extraordinarily.long.email.username.123456@reallylonghostname.com",
                    "primary": false,
                    "type": "other"
                  }
                ],
                "names": [
                  "Alberta Bobbeth Charleson"
                ],
                "phone_numbers": [
                  {
                    "data": "1112223333",
                    "primary": false,
                    "type": "home"
                  },
                  {
                    "data": "1112224444",
                    "primary": false,
                    "type": "work"
                  },
                  {
                    "data": "1112225555",
                    "primary": false,
                    "type": "mobile1"
                  }
                ]
              }
            ],
            "subtype": "checking",
            "transactions": [
              {
                "account_id": "jW4r4QvdeXcAZNj8J3Dni68DqxQ3laHZwGyBD",
                "amount": -500,
                "date": "2018-03-25",
                "original_description": "United Airlines  REFUND ",
                "pending": false,
                "transaction_id": "wPkQknvpz9HV8bPK465rC6GnyrnlrXCMr9vgm",
                "iso_currency_code": "USD",
                "unofficial_currency_code": null
              },
              {
                "account_id": "jW4r4QvdeXcAZNj8J3Dni68DqxQ3laHZwGyBD",
                "amount": 5.4,
                "date": "2018-03-27",
                "original_description": "Uber 063015 SFPOOL",
                "pending": false,
                "transaction_id": "GM4K4LJqGBu5g8yqjkQJuVnry6rz6zh8Qwkv9",
                "iso_currency_code": "USD",
                "unofficial_currency_code": null
              },
              {
                "account_id": "jW4r4QvdeXcAZNj8J3Dni68DqxQ3laHZwGyBD",
                "amount": 6.33,
                "date": "2018-04-09",
                "original_description": "Uber 072515 SFPOOL",
                "pending": false,
                "transaction_id": "DekykZJWrjf5g7kjRaLvceLZb4avg5CVBDGz5x",
                "iso_currency_code": "USD",
                "unofficial_currency_code": null
              }
            ],
            "type": "depository"
          },
          {
            "account_id": "V3EkERBQXGF5z6Jb9NDkupNeoy1b81cjpWVDe",
            "balances": {
              "available": 200,
              "current": 210
            },
            "days_available": 730,
            "historical_balances": [
              {
                "current": 210,
                "date": "2018-04-12",
                "iso_currency_code": "USD",
                "unofficial_currency_code": null
              },
              {
                "current": 210,
                "date": "2018-04-11",
                "iso_currency_code": "USD",
                "unofficial_currency_code": null
              },
              {
                "current": 210,
                "date": "2018-04-10",
                "iso_currency_code": "USD",
                "unofficial_currency_code": null
              }
             
            ],
            "mask": "1111",
            "name": "Plaid Saving",
            "official_name": "Plaid Silver Standard 0.1% Interest Saving",
            "owners": [
              {
                "addresses": [
                  {
                    "data": {
                      "city": "Malakoff",
                      "region": "NY",
                      "street": "2992 Cameron Road",
                      "postal_code": "14236",
                      "country": "US"
                    },
                    "primary": true
                  },
                  {
                    "data": {
                      "city": "San Matias",
                      "region": "CA",
                      "street": "2493 Leisure Lane",
                      "postal_code": "93405-2255",
                      "country": "US"
                    },
                    "primary": false
                  }
                ],
                "emails": [
                  {
                    "data": "accountholder0@example.com",
                    "primary": true,
                    "type": "primary"
                  },
                  {
                    "data": "accountholder1@example.com",
                    "primary": false,
                    "type": "secondary"
                  },
                  {
                    "data": "extraordinarily.long.email.username.123456@reallylonghostname.com",
                    "primary": false,
                    "type": "other"
                  }
                ],
                "names": [
                  "Alberta Bobbeth Charleson"
                ],
                "phone_numbers": [
                  {
                    "data": "1112223333",
                    "primary": false,
                    "type": "home"
                  },
                  {
                    "data": "1112224444",
                    "primary": false,
                    "type": "work"
                  },
                  {
                    "data": "1112225555",
                    "primary": false,
                    "type": "mobile1"
                  }
                ]
              }
            ],
            "subtype": "savings",
            "transactions": [
             
              {
                "account_id": "V3EkERBQXGF5z6Jb9NDkupNeoy1b81cjpWVDe",
                "amount": 25,
                "date": "2018-02-25",
                "original_description": "CREDIT CARD 3333 PAYMENT //",
                "pending": false,
                "transaction_id": "LkexeEJ3Ryf5Vw3evRMMIXlLjkRkawIdzm6Ak",
                "iso_currency_code": "USD",
                "unofficial_currency_code": null
              },
              {
                "account_id": "V3EkERBQXGF5z6Jb9NDkupNeoy1b81cjpWVDe",
                "amount": -4.22,
                "date": "2018-03-22",
                "original_description": "INTRST PYMNT",
                "pending": false,
                "transaction_id": "y7EJEmwgazsjJDVdMZ3QSQBKpaKnQzSjElP71M",
                "iso_currency_code": "USD",
                "unofficial_currency_code": null
              },
              {
                "account_id": "V3EkERBQXGF5z6Jb9NDkupNeoy1b81cjpWVDe",
                "amount": 25,
                "date": "2018-03-27",
                "original_description": "CREDIT CARD 3333 PAYMENT //",
                "pending": false,
                "transaction_id": "dLz7z41KlaSWLbmJqpxXiaqPgJPbn5IgMwymJ",
                "iso_currency_code": "USD",
                "unofficial_currency_code": null
              }
            ],
            "type": "depository"
          },
          {
            "account_id": "4RWyWq143jIEm7BaqJNKCQyG9Ndnv5iJaENyV",
            "balances": {
              "available": null,
              "current": 5000
            },
            "days_available": 730,
            "historical_balances": [
              {
                "current": 5000,
                "date": "2018-04-12",
                "iso_currency_code": "USD",
                "unofficial_currency_code": null
              },
              {
                "current": 1000,
                "date": "2018-04-11",
                "iso_currency_code": "USD",
                "unofficial_currency_code": null
              },
              {
                "current": 1000,
                "date": "2018-04-10",
                "iso_currency_code": "USD",
                "unofficial_currency_code": null
              }
              
            ],
            "mask": "2222",
            "name": "Plaid CD",
            "official_name": "Plaid Bronze Standard 0.2% Interest CD",
            "owners": [
              {
                "addresses": [
                  {
                    "data": {
                      "city": "Malakoff",
                      "region": "NY",
                      "street": "2992 Cameron Road",
                      "postal_code": "14236",
                      "country": "US"
                    },
                    "primary": true
                  },
                  {
                    "data": {
                      "city": "San Matias",
                      "region": "CA",
                      "street": "2493 Leisure Lane",
                      "postal_code": "93405-2255",
                      "country": "US"
                    },
                    "primary": false
                  }
                ],
                "emails": [
                  {
                    "data": "accountholder0@example.com",
                    "primary": true,
                    "type": "primary"
                  },
                  {
                    "data": "accountholder1@example.com",
                    "primary": false,
                    "type": "secondary"
                  },
                  {
                    "data": "extraordinarily.long.email.username.123456@reallylonghostname.com",
                    "primary": false,
                    "type": "other"
                  }
                ],
                "names": [
                  "Alberta Bobbeth Charleson"
                ],
                "phone_numbers": [
                  {
                    "data": "1112223333",
                    "primary": false,
                    "type": "home"
                  },
                  {
                    "data": "1112224444",
                    "primary": false,
                    "type": "work"
                  },
                  {
                    "data": "1112225555",
                    "primary": false,
                    "type": "mobile1"
                  }
                ]
              }
            ],
            "subtype": "cd",
            "transactions": [
              
              {
                "account_id": "4RWyWq143jIEm7BaqJNKCQyG9Ndnv5iJaENyV",
                "amount": 1000,
                "date": "2018-01-25",
                "original_description": "CD DEPOSIT .INITIAL.",
                "pending": false,
                "transaction_id": "M8QdQWJx1GS51ZymxjNNILQ7GwjwG1I3qr3RwX",
                "iso_currency_code": "USD",
                "unofficial_currency_code": null
              },
              {
                "account_id": "4RWyWq143jIEm7BaqJNKCQyG9Ndnv5iJaENyV",
                "amount": 1000,
                "date": "2018-02-24",
                "original_description": "CD DEPOSIT .INITIAL.",
                "pending": false,
                "transaction_id": "q3Z4ZgvempFnljLVzqxxhPQ3we7eW9sdJy5jP",
                "iso_currency_code": "USD",
                "unofficial_currency_code": null
              },
              {
                "account_id": "4RWyWq143jIEm7BaqJNKCQyG9Ndnv5iJaENyV",
                "amount": 1000,
                "date": "2018-03-26",
                "original_description": "CD DEPOSIT .INITIAL.",
                "pending": false,
                "transaction_id": "aZqNqxQAEyHvboB8jazrsbPWNwW6WxU8zRj5kw",
                "iso_currency_code": "USD",
                "unofficial_currency_code": null
              }
            ],
            "type": "depository"
          }
        ],
        "date_last_updated": "2018-04-12T03:32:10Z",
        "institution_id": "ins_109511",
        "institution_name": "Tartan Bank",
        "item_id": "zeWoWyv84xfkGg1w4ox5iQy5k6j75xu8QXMEm"
      }
    ],
    "user": {
      "client_user_id": "123456789",
      "email": "accountholder0@example.com",
      "first_name": "Alberta",
      "last_name": "Charleson",
      "middle_name": "Bobbeth",
      "phone_number": "111-222-3333",
      "ssn": "123-45-6789"
    }
  },
  "request_id": "pdwYD",
  "warnings": []
}
$$
);


insert into plaid values (default, 'investment_response',
$$

{
  "item": {},
  "request_id": "",
  "accounts": [],
  "securities": [{
    "security_id": "8jJwoCrH3nXNsk5OMSGLAf3hjoAv7fkSAXb5K",
    "isin": "US31617H1023",
    "sedol": null,
    "cusip": "31617H102",
    "ticker_symbol": "SPAXX",
    "name": "Fidelity Government Money Market Fund",
    "is_cash_equivalent": true,
    "type": "money market",
    "close_price": 1.00,
    "close_price_as_of": "2018-12-20",
    "iso_currency_code": "USD",
    "unofficial_currency_code": null
  },
  {
    "security_id": "pvVE25eHesoPtl46qGk0T98dodkAd6jNuAmeO",
    "isin": "US17275R1023",
    "sedol": null,
    "cusip": "17275R102",
    "ticker_symbol": "CSCO",
    "name": "CISCO SYSTEMS INC",
    "is_cash_equivalent": false,
    "type": "equity",
    "close_price": 42.438,
    "close_price_as_of": "2018-12-20",
    "iso_currency_code": "USD",
    "unofficial_currency_code": null
  },{
    "security_id": "WuQDPY287v21GuokVScQTffuAEM2ppXiq4VwI",
    "isin": null,
    "sedol": null,
    "cusip": null,
    "institution_security_id": "bitcoin",
    "institution_id": "ins_18014",
    "ticker_symbol": "BTC",
    "name": "Bitcoin",
    "is_cash_equivalent": false,
    "type": "equity",
    "close_price": 6485.39,
    "close_price_as_of": "2018-12-20",
    "iso_currency_code": "USD",
    "unofficial_currency_code": null
  },{
    "security_id": "xeAuh4GUzAYuGaqwhZE3Fspih2K4AMOvtHQve",
    "isin": "US46625H1005",
    "sedol": null,
    "cusip": "46625H100",
    "ticker_symbol": "JPM",
    "name": "JPMorgan Chase & Co",
    "is_cash_equivalent": false,
    "type": "equity",
    "close_price": 96.450,
    "close_price_as_of": "2018-12-20",
    "iso_currency_code": "USD",
    "unofficial_currency_code": null
  }],
  "holdings": [{
    "account_id": "vzeNDwK7KQIm4yEog683uElbp9GRLEFXGK98D",
    "security_id": "8jJwoCrH3nXNsk5OMSGLAf3hjoAv7fkSAXb5K",
    "institution_price": 1.00,
    "institution_price_as_of": "2018-12-20",
    "institution_value": 2107.07,
    "cost_basis": 2107.07,
    "quantity": 2107.07,
    "iso_currency_code": "USD",
    "unofficial_currency_code": null
  },{
    "account_id": "vzeNDwK7KQIm4yEog683uElbp9GRLEFXGK98D",
    "security_id": "pvVE25eHesoPtl46qGk0T98dodkAd6jNuAmeO",
    "institution_price": 42.490,
    "institution_price_as_of": "2018-12-20",
    "institution_value": 6373.50,
    "cost_basis": 6247.73,
    "quantity": 150.00,
    "iso_currency_code": "USD",
    "unofficial_currency_code": null
  },{
    "account_id": "vzeNDwK7KQIm4yEog683uElbp9GRLEFXGK98D",
    "security_id": "xeAuh4GUzAYuGaqwhZE3Fspih2K4AMOvtHQve",
    "institution_price": 96.450,
    "institution_price_as_of": "2018-12-20",
    "institution_value": 5015.40,
    "cost_basis": 3680.14,
    "quantity": 52.00,
    "iso_currency_code": "USD",
    "unofficial_currency_code": null
  },{
    "account_id": "QPO8Jo8vdDHMepg41PBwckXm4KdK1yUdmXOwK",
    "security_id": "WuQDPY287v21GuokVScQTffuAEM2ppXiq4VwI",
    "institution_price": 4005.38,
    "institution_price_as_of": "2018-12-20",
    "institution_value": 6481.51,
    "cost_basis": 6112.09,
    "quantity": 1.6182,
    "iso_currency_code": "USD",
    "unofficial_currency_code": null
  }
  ]
}
$$
);

insert into plaid values (default, 'studentloan_response',
$$

{
  "accounts": [],
  "item": {},
  "liabilities": {
    "student": [
      {
        "account_id": "vokyE5Rn6vHKqDLRXEn5fne7LwbKPLIXGK98d",
        "account_number": "3735928559",
        "disbursement_dates": [
          "2017-05-20",
          "2017-06-20"
        ],
        "expected_payoff_date": "2030-04-21",
        "guarantor": "Gingham Guarantor",
        "interest_rate_percentage": 18.25,
        "is_overdue": false,
        "last_payment_amount": 420.10,
        "last_payment_date": "2019-03-15",
        "last_statement_balance": 2345.6,
        "last_statement_issue_date": "2019-03-01",
        "loan_name": "Direct Subsidized Stafford",
        "loan_status": {
          "end_date": "2019-09-24",
          "type": "repayment"
        },
        "minimum_payment_amount": 123.99,
        "next_payment_due_date": "2019-04-01",
        "origination_date": "2017-04-21",
        "origination_principal_amount": 12345.6,
        "outstanding_interest_amount": 1234.5,
        "payment_reference_number": "4277009102",
        "pslf_status": {
          "estimated_eligibility_date": "2021-01-01",
          "payments_made": 42,
          "payments_remaining": 78
        },
        "repayment_plan": {
          "description": "STANDARD REPAYMENT",
          "type": "standard"
        },
        "sequence_number": "1",
        "servicer_address": {
          "city": "San Matias",
          "country": "US",
          "postal_code": "93405-2255",
          "region": "CA",
          "street": "2493 Leisure Lane"
        },
        "ytd_interest_paid": 123.4,
        "ytd_principal_paid": 1234.5
      }
    ],
    "request_id": "9GMVig"
  }
}
$$
);


insert into plaid values (default, 'creditcard_response',
$$

{
  "accounts": [],
  "item": {},
  "liabilities": {
    "credit": [
      {
        "account_id": "LgDOJbZz7pFKpaPNgRpZU57zY395q1I0Lxpew",
        "aprs": [
          {
            "apr_percentage": 23.99,
            "apr_type": "purchase_apr",
            "balance_subject_to_apr": 2345.6,
            "interest_charge_amount": 27.01
          }
        ],
        "is_overdue": false,
        "last_payment_amount": 420,
        "last_payment_date": "2019-03-15",
        "last_statement_balance": 2345.6,
        "last_statement_issue_date": "2019-03-01",
        "minimum_payment_amount": 123,
        "next_payment_due_date": "2019-04-01"
      }
    ],
    "request_id": "9GMVig"
  }
}
$$
);

insert into plaid values (default, 'account_response',
$$

{
  "accounts": [{
    "account_id": "vzeNDwK7KQIm4yEog683uElbp9GRLEFXGK98D",
    "balances": {
      "available": 100,
      "current": 110,
      "limit": null,
      "iso_currency_code": "USD",
      "unofficial_currency_code": null
    },
    "mask": "0000",
    "name": "Plaid Checking",
    "official_name": "Plaid Gold Checking",
    "subtype": "checking",
    "type": "depository",
    "verification_status": null
  }, {
    "account_id": "6Myq63K1KDSe3lBwp7K1fnEbNGLV4nSxalVdW",
    "balances": {
      "available": null,
      "current": 410,
      "limit": 2000,
      "iso_currency_code": "USD",
      "unofficial_currency_code": null
    },
    "mask": "3333",
    "name": "Plaid Credit Card",
    "official_name": "Plaid Diamond Credit Card",
    "subtype": "credit card",
    "type": "credit"
  }],
  "item": {},
  "request_id": "m8MDnv9okwxFNBV"
}
$$
);

insert into plaid values (default, 'item_response',
$$
{
  "item": {
    "available_products": [
      "balance",
      "auth"
    ],
    "billed_products": [
      "identity",
      "transactions"
    ],
    "error": null,
    "institution_id": "ins_109508",
    "item_id": "Ed6bjNrDLJfGvZWwnkQlfxwoNz54B5C97ejBr",
    "webhook": "https://plaid.com/example/hook",
    "consent_expiration_time": null
  },
  "status": {
    "transactions": {
      "last_successful_update": "2019-02-15T15:10:00",
      "last_failed_update": "2019-01-22T04:32:00"
    },
    "last_webhook": {
      "sent_at": "2019-02-15T15:53:00",
      "code_sent": "DEFAULT_UPDATE"
    }
  },
  "request_id": "m8MDnv9okwxFNBV"
}
$$
);



insert into plaid values (default, 'item_response',
$$

{
  "institutions": [
    {
      "country_codes": ["US"],
      "credentials": [{
        "label": "User ID",
        "name": "username",
        "type": "text"
       }, {
        "label": "Password",
        "name": "password",
        "type": "password"
      }],
      "has_mfa": true,
      "institution_id": "ins_109508",
      "mfa": [
        "code",
        "list",
        "questions",
        "selections"
      ],
      "name": "First Platypus Bank",
      "products": [
        "assets",
        "auth",
        "balance",
        "transactions",
        "credit_details",
        "income",
        "identity",
        "investments",
        "liabilities"
      ],
      "routing_numbers": ["110000000"],
      "primary_color": "#1f1f1f",
      "url": "https://plaid.com",
      "logo": null
    }
  ],
  "request_id": "m8MDnv9okwxFNBV",
  "total": 1
}
$$
);


DO
$code$
DECLARE
	i int; -- initial value is NULL
	t text DEFAULT 'Hello World!';
	d date DEFAULT CURRENT_DATE;
BEGIN
	RAISE INFO 'Variables are: d = [%], t = [%], i = [%]', d, t, i;
END
$code$;

