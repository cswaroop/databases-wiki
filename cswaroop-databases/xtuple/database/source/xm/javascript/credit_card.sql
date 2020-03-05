select xt.install_js('XM','CreditCard','xtuple', $$
/* Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
   See www.xtuple.com/CPAL for the full text of the software license. */

(function () {

  if (!XM.CreditCard) { XM.CreditCard = {}; }

  XM.CreditCard.isDispatchable = true;

  /**


   @param {Number} payment id
   @param {Number} documentNumber
   @param {String} document type
   @param {Number} amount
  */
  XM.CreditCard.postCashReceipt = function (paymentId, documentNumber, documentType, amount) {
    /* resolve natural keys to primary keys */
    /* TODO: this only works for sales order at the moment */
    var documentId = XT.Data.getId(XT.Orm.fetch('XM', 'SalesOrder'), documentNumber);
    var sql = "SELECT postCCcashReceipt($1, $2, $3, $4) AS cm_id;";

    plv8.execute(sql, [paymentId, documentId, documentType, amount]);
  };
  XM.CreditCard.postCashReceipt.description = "";
  XM.CreditCard.postCashReceipt.params = {
    paymentId: {type: "Number", description: "Payment ID"},
    documentId: {type: "Number", description: "Document Number"},
    documentType: {type: "String", description: "Document Type"},
    amount: {type: "Number", description: "Amount"}
  };

  XM.CreditCard.cardTypeMap = {
    A: "American Express",
    D: "Discover",
    M: "Master Card",
    V: "Visa",
  };

  XM.CreditCard.cardTypesString = function () {
    var types = [];
    for (key in XM.CreditCard.cardTypeMap) {
      types.push(key + " = " + XM.CreditCard.cardTypeMap[key]);
    }

    return types.join(", ");
  };

  /**
   Save a credit card to the database.
   Sample usage:
    select xt.post('{
      "nameSpace":"XM",
      "type":"CreditCard",
      "dispatch":{
        "functionName":"saveCard",
        "parameters":[
          {
            "customer": "TTOYS",
            "cardType": "V",
            "cardNumber": "4242424242424242",
            "cardName": "John Doe",
            "address1": "119 West York St",
            "address2": "2nd Floor",
            "city": "Norfolk",
            "state": "VA",
            "postalCode": "23510",
            "country": "US",
            "cardExpireMonth": 10,
            "cardExpireYear": 2018
          }
        ]
      },
      "username":"admin",
      "encryptionKey":"hm6gnf3xsov9rudi"
    }');

   @param {Object} creditCardData: The card data to save.
   @returns {Boolean}
  */
  XM.CreditCard.saveCard = function (creditCardData) {
    if (!XT.encryptionKey) {
      throw new handleError("Not Implemented", 501);
    }

    if (!creditCardData.customer || creditCardData.customer.length < 1 ||
        !creditCardData.cardType || creditCardData.cardType.length !== 1 ||
        !creditCardData.cardNumber || creditCardData.cardNumber.length < 13 || creditCardData.cardNumber.length > 17 ||
        !creditCardData.cardName || creditCardData.cardName.length < 3 ||
        !creditCardData.address1 || creditCardData.address1.length < 2 ||
        !creditCardData.city || creditCardData.city.length < 2 ||
        !creditCardData.state || creditCardData.state.length < 2 ||
        !creditCardData.postalCode || creditCardData.postalCode.length < 4 ||
        !creditCardData.country || creditCardData.country.length < 2 ||
        !creditCardData.cardExpireMonth || creditCardData.cardExpireMonth < 1 || creditCardData.cardExpireMonth > 12 ||
        !creditCardData.cardExpireYear || creditCardData.cardExpireYear < 2000 || creditCardData.cardExpireYear > 3000
       ) {
      throw new handleError("Bad Request", 400);
    }

    var insertCardSql = "SELECT insertccard(\n" +
                        "  $1::text,\n" + // pCustomer
                        "  true,\n" + // pActive
                        "  $2::text,\n" + // pType
                        "  $3::bytea,\n" + // pNumber
                        "  $4::bytea,\n" + // pName
                        "  $5::bytea,\n" + // pAddr1
                        "  COALESCE($6, '')::bytea,\n" + // pAddr2
                        "  $7::bytea,\n" + // pCity
                        "  $8::bytea,\n" + // pState
                        "  $9::bytea,\n" + // pPostal
                        "  $10::bytea,\n" + // pCountry
                        "  $11::bytea,\n" + // pMonth
                        "  $12::bytea,\n" + // pYear
                        "  $13::text\n" + // pKey
                        ") AS insertccard;";

    var result = plv8.execute(insertCardSql, [
      creditCardData.customer,
      XM.CreditCard.cardTypeMap[creditCardData.cardType] || "",
      creditCardData.cardNumber,
      creditCardData.cardName,
      creditCardData.address1,
      creditCardData.address2,
      creditCardData.city,
      creditCardData.state,
      creditCardData.postalCode,
      creditCardData.country,
      creditCardData.cardExpireMonth,
      creditCardData.cardExpireYear,
      XT.encryptionKey
    ]);

    if (result && result[0] && result[0].insertccard) {
      return result[0].insertccard;
    } else {
      return false;
    }
  };
  XM.CreditCard.saveCard.description = "Saves a credit card to the xTuple database.";
  XM.CreditCard.saveCard.request = {
    "$ref": "saveCreditCardRequest"
  };
  XM.CreditCard.saveCard.parameterOrder = ["saveCreditCardRequest"];
  // For JSON-Schema deff, see:
  // https://github.com/fge/json-schema-validator/issues/46#issuecomment-14681103
  XM.CreditCard.saveCard.schema = {
    saveCreditCardRequest: {
      properties: {
        attributes: {
          title: "XM.CreditCard.saveCard service request attributes",
          description: "An array of attributes needed to perform a XM.CreditCard.saveCard request.",
          type: "array",
          items: [
            {
              title: "Credit Card Data",
              type: "object",
              "$ref": "creditCardData"
            }
          ],
          "minItems": 1,
          "maxItems": 1,
          required: true
        }
      }
    },
    creditCardData: {
      properties: {
        customer: {
          title: "Customer Number",
          description: "The existing Customer the card is for.",
          type: "string",
          required: true
        },
        cardType: {
          title: "Card Type",
          description: "Single character card type. " +  XM.CreditCard.cardTypesString(),
          type: "string",
          required: true
        },
        cardNumber: {
          title: "Card Number",
          description: "The credit card number.",
          type: "string",
          required: true
        },
        cardName: {
          title: "Card Holder Name",
          description: "The full name on the credit card.",
          type: "integer",
          required: true
        },
        address1: {
          title: "Address Line 1",
          description: "The Address Line 1 the card uses for the Billing Address.",
          type: "string",
          required: true
        },
        address2: {
          title: "Address Line 2",
          description: "The optional Address Line 2 the card uses for the Billing Address.",
          type: "string"
        },
        city: {
          title: "Address City",
          description: "The Address City the card uses for the Billing Address.",
          type: "string",
          required: true
        },
        state: {
          title: "Address State",
          description: "The Address State the card uses for the Billing Address.",
          type: "string",
          required: true
        },
        postalCode: {
          title: "Address Postal Code",
          description: "The Address Postal Code the card uses for the Billing Address.",
          type: "string",
          required: true
        },
        country: {
          title: "Address Country",
          description: "The Address Country the card uses for the Billing Address.",
          type: "string",
          required: true
        },
        cardExpireMonth: {
          title: "Expiration Month",
          description: "The card's expiration month in 2 digits.",
          type: "integer",
          required: true
        },
        cardExpireYear: {
          title: "Expiration Year",
          description: "The card's expiration year in 4 digits.",
          type: "integer",
          required: true
        }
      }
    }
  };

}());

$$ );
