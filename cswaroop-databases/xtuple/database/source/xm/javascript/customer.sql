select xt.install_js('XM','Customer','xtuple', $$
/* Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
   See www.xtuple.com/CPAL for the full text of the software license. */

(function () {

  if (!XM.Customer) { XM.Customer = {}; }

  XM.Customer.isDispatchable = true;

  /**
    Determine whether a customer can purchase a given item

    @param {Number} Customer id
    @param {Number} Item id
    @param {Date} Schedule date
    @param {Number} Shipto id
    @returns {Boolean}
  */
  XM.Customer.canPurchase = function (customerId, itemId, scheduleDate, shiptoId) {
    var sql = 'select customerCanPurchase(item_id, cust_id, $3, $4::date) as canpurchase ' +
              'from custinfo, item where item_number = $1 and cust_number = $2;',
      ret;
    shiptoId = shiptoId && XT.Data.getId(XT.Orm.fetch('XM','CustomerShipto'), shiptoId);
    ret = plv8.execute(sql, [itemId, customerId, shiptoId, scheduleDate]);
    return ret.length ? ret[0].canpurchase : true;
  };

  /**
   Returns an object with a price and type for a given customer, item and quantity.

   @param {Number} customer id
   @param {Number} item id
   @param {Number} quantity
   @param {Object} options:  asOf, shiptoId, quantityUnitId, priceUnitId, currencyId, effective
   @returns Object
  */
  XM.Customer.itemPrice = function (customerId, itemId, quantity, options) {
    options = options || {};
    var sql = "select itemipsprice(item_id, cust_id, $3, $4, $5, $6, $7, $8::date, $9::date, $10) as result " +
              "from custinfo, item where item_number = $1 and cust_number = $2",
      getUomNameSql = "SELECT uom_name FROM uom WHERE uom_id = $1;",
      today = new Date(),
      shiptoId,
      quantityUnitId,
      priceUnitId,
      currencyId,
      effective,
      asOf,
      siteId,
      result,
      err;

    if (!itemId) {
      err = "Item";
    } else if (!customerId) {
      err = "Customer";
    } else if (!quantity) {
      err = "Quantity"
    };
    if(err) { plv8.elog(ERROR, err + " is required.") }

    shiptoId = options.shiptoId ?
       XT.Data.getId(XT.Orm.fetch('XM', 'CustomerShipto'), options.shiptoId) : -1;
    quantityUnitId = options.quantityUnitId ?
       XT.Data.getId(XT.Orm.fetch('XM', 'Unit'), options.quantityUnitId) :
       plv8.execute("select item_inv_uom_id as result from item where item_number = $1;", [itemId])[0].result;
    priceUnitId = options.priceUnitId ?
      XT.Data.getId(XT.Orm.fetch('XM', 'Unit'), options.priceUnitId) :
      plv8.execute("select item_price_uom_id as result from item where item_number = $1;", [itemId])[0].result;
    currencyId = options.currencyId ?
      XT.Data.getId(XT.Orm.fetch('XM', 'Currency'), options.currencyId) :
      plv8.execute("select basecurrid() as result")[0].result;
    siteId = options.siteId ?
      XT.Data.getId(XT.Orm.fetch('XM', 'Site'), options.siteId) : null;
    effective = options.effective ? new Date(options.effective) : today;
    asOf = options.asOf ? new Date(options.asOf) : today;

    if (DEBUG) {
      XT.debug('XM.Customer.itemPrice sql = ', sql);
      XT.debug('XM.Customer.itemPrice values = ', [itemId, customerId, shiptoId, parseInt(quantity), quantityUnitId, priceUnitId, currencyId, effective, asOf, siteId]);
    }
    result = plv8.execute(sql, [itemId, customerId, shiptoId, parseFloat(quantity), quantityUnitId, priceUnitId, currencyId, effective, asOf, siteId])[0].result;

    result = {
      price: result.itemprice_price,
      list: result.itemprice_listprice,
      discountPercent: (result.itemprice_listprice - result.itemprice_price) / result.itemprice_listprice,
      method: result.itemprice_method,
      type: result.itemprice_type,
      sale: result.itemprice_sale,
      priceSchedule: result.itemprice_schedule,
      assignment: result.itemprice_assignment,
      basis: result.itemprice_basis,
      basisType: result.itemprice_basistype,
      modifierPercent: result.itemprice_modifierpct,
      modifierAmount: result.itemprice_modifieramt,
      qtyBreak: result.itemprice_qtybreak,
      qtyUom: result.itemprice_qty_uom_id ? plv8.execute(getUomNameSql, [result.itemprice_qty_uom_id])[0].uom_name : null,
      priceUom: result.itemprice_price_uom_id ? plv8.execute(getUomNameSql, [result.itemprice_price_uom_id])[0].uom_name : null,
      exclusive: result.itemprice_exclusive
    };

    return result;
  };
  XM.Customer.itemPrice.description = "Perform an item price quote for a given Customer, Item, Qty, Ship To, Date and Warehouse.";
  XM.Customer.itemPrice.request = {
    "$ref": "ItemPrice"
  };
  XM.Customer.itemPrice.parameterOrder = ["customerId", "itemId", "quantity", "options"];
  // For JSON-Schema deff, see:
  // https://github.com/fge/json-schema-validator/issues/46#issuecomment-14681103
  XM.Customer.itemPrice.schema = {
    ItemPrice: {
      properties: {
        attributes: {
          title: "Service request attributes",
          description: "An array of attributes needed to get a price quote.",
          type: "array",
          items: [
            {
              title: "Customer Id Key",
              description: "The Customer Number natural key",
              type: "string",
              "$ref": "Customer/number",
              required: true
            },
            {
              title: "Item Id Key",
              description: "The Item Number natural key",
              type: "string",
              "$ref": "Item/number",
              required: true
            },
            {
              title: "Quantity",
              description: "Quantity",
              type: "number",
              required: true
            },
            {
              title: "Options",
              type: "object",
              "$ref": "ItemPriceOptions"
            }
          ],
          "minItems": 3,
          "maxItems": 4,
          required: true
        }
      }
    },
    ItemPriceOptions: {
      properties: {
        asOf: {
          title: "As Of",
          description: "Transaction Timestamp, default to now()",
          type: "string",
          format: "date-time"
        },
        shiptoId: {
          title: "Ship To Id Key",
          description: "The Ship To Number natural key",
          type: "string",
          "$ref": "CustomerShipto/number",
          required: true
        },
        quantityUnitId: {
          title: "Quantity Unit Id",
          description: "The UOM Id for the quantity value.",
          type: "number",
          required: true
        },
        priceUnitId: {
          title: "Price Unit Id",
          description: "The UOM Id for the price value.",
          type: "number",
          required: true
        },
        currencyId: {
          title: "Currency Id",
          description: "The Currency Id for the price quote.",
          type: "number",
          required: true
        },
        effective: {
          title: "Effective Date",
          description: "Transaction Timestamp, default to now()",
          type: "string",
          format: "date-time"
        }
      }
    }
  };

  /**
   Returns a price for a given customer, item, characteristic and quantity.

   @param {Number} customer id
   @param {Number} item id
   @param {Number} characteristic id
   @param {Number} characteristic value
   @param {Number} quantity
   @param {Object} options:  asOf, shiptoId, currencyId, effective
   @returns Object
  */
  XM.Customer.characteristicPrice = function(customerId, itemId, characteristicId, value, quantity, options) {
    options = options || {};
    var sql = "select itemcharprice(item_id, char_id, $3, cust_id, $5, $6, $7, $8::date, $9::date) as result " +
              "from item, custinfo, char " +
              "where item_number = $1 and char_name = $2 and cust_number = $4;",
      today = new Date(),
      shiptoId = options.shiptoId || -1,
      currencyId,
      effective,
      asOf,
      result,
      err;

    if (!itemId) {
      err = "Item";
    } else if (!customerId) {
      err = "Characteristic";
    } else if (!customerId) {
      err = "Customer";
    } else if (!quantity) {
      err = "Quantity"
    };
    if(err) { plv8.elog(ERROR, err + " is required.") }

    currencyId = options.currencyId ?
      XT.Data.getId(XT.Orm.fetch('XM', 'Currency'), options.currencyId) :
      plv8.execute("select basecurrid() as result")[0].result;
    effective = options.effective ? new Date(options.effective) : today;
    asOf = options.asOf ? new Date(options.asOf) : today;
    result = plv8.execute(sql, [itemId, characteristicId, value, customerId, shiptoId, quantity, currencyId, effective, asOf])[0].result;

    return result;
  }

  /**
    Return whether a Customer is referenced by another table.

    @param {String} Customer Number
  */
  XM.Customer.used = function(id) {
    var exceptions = ["public.crmacct"];
    return XM.PrivateModel.used("XM.Customer", id, exceptions);
  };

  /**
   * Return a pseudo customer object with all default parameters set.
   */
  XM.Customer.defaults = function () {
    var settings = XT.Session.settings(),
      cust = {
        "customerType": settings.DefaultCustType,
        "isActive": true,
        "salesRep": XM.Customer.defaultSalesRepNumValue(),
        "commission": XM.Customer.defaultSalesRepCommValue(),
        "shipCharge": XM.Customer.defaultShipChargeValue(),
        "shipVia": XM.Customer.defaultShipViaValue(),
        "isFreeFormShipto": settings.DefaultFreeFormShiptos,
        "isFreeFormBillto": false,
        "terms": settings.DefaultTerms,
        "discount": 0,
        "creditStatus": "G",
        "balanceMethod": settings.DefaultBalanceMethod,
        "backorder": settings.DefaultBackOrders,
        "partialShip": settings.DefaultPartialShipments,
        "blanketPurchaseOrders": false,
        "usesPurchaseOrders": false,
        "autoUpdateStatus": false,
        "autoHoldOrders": false,
        "preferredSite": XM.Customer.defaultSellingWarehouseValue()
      };

    return cust;
  };

  /**
   * Return default ShipVia value.
   */
  XM.Customer.defaultShipViaValue = function () {
    var ret,
      settings = XT.Session.settings(),
      shipVia = plv8.execute("select * from shipvia where shipvia_code = $1;", [settings.DefaultShipViaId])[0];

    if (shipVia) {
      ret = shipVia.shipvia_code + "-" + shipVia.shipvia_descrip;
    }
    else {
      ret = "";
    }

    return ret;
  };

  /**
   * Return default shipCharge value.
   */
  XM.Customer.defaultShipChargeValue = function () {
    var ret,
      settings = XT.Session.settings(),
      shipCharge = plv8.execute("select * from shipchrg where shipchrg_id = $1;", [settings.DefaultShipChrgId])[0];

    if (shipCharge) {
      ret = shipCharge.shipchrg_name;
    }
    else {
      ret = "";
    }

    return ret;
  };

  /**
   * Return default sellingWarehouse value.
   */
  XM.Customer.defaultSellingWarehouseValue = function () {
    var ret,
      settings = XT.Session.settings(),
      sellingWarehouse = plv8.execute("select * from whsinfo where warehous_id = $1;", [settings.DefaultSellingWarehouseId])[0];

    if (sellingWarehouse) {
      ret = sellingWarehouse.warehous_code;
    }
    else {
      ret = "";
    }

    return ret;
  };

  /**
   * Return default salesRepNumber value.
   */
  XM.Customer.defaultSalesRepNumValue = function () {
    var ret,
      settings = XT.Session.settings(),
      salesRep = plv8.execute("select * from salesrep where salesrep_number = $1;", [settings.DefaultSalesRep])[0];

    if (salesRep) {
      ret = salesRep.salesrep_number;
    }
    else {
      ret = "";
    }

    return ret;
  };

  /**
   * Return default salesRepCommission value.
   */
  XM.Customer.defaultSalesRepCommValue = function () {
    var ret,
      settings = XT.Session.settings(),
      salesRep = plv8.execute("select * from salesrep where salesrep_number = $1;", [settings.DefaultSalesRep])[0];

    if (salesRep) {
      ret = salesRep.salesrep_commission;
    }
    else {
      ret = "";
    }

    return ret;
  };

}());

$$ );
