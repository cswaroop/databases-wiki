/* Delete previously misnamed record */
delete from xt.js where js_context='xtuple' and js_type = 'item_site';

select xt.install_js('XM','ItemSite','xtuple', $$
  /* Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
     See www.xm.ple.com/CPAL for the full text of the software license. */

(function () {

  if (!XM.ItemSite) { XM.ItemSite = {}; }

  XM.ItemSite.isDispatchable = true;

  /**
    Return the current cost for a particular item site.
  */
  XM.ItemSite.cost = function (itemsiteId) {
    if (!XT.Data.checkPrivilege('ViewCosts')) { return null; }
    return plv8.execute('select itemcost(itemsite_id) as cost from itemsite where obj_uuid = $1;', [itemsiteId])[0].cost;
  };

  if (!XM.ItemSitePrivate) { XM.ItemSitePrivate = {}; }

  /*
    This should NEVER be set to true. XM.ItemSitePrivate.fetch can be passed
    table and column names to drasitcally change it behaviour which could be
    abused. It should NOT be isDispatchable.
  **/
  XM.ItemSitePrivate.isDispatchable = false;

  /**
    @private

    This function supports the XM.ItemSiteListItem.fetch() and XM.ItemSiteRelation.fetch(),
    but also xDruple extension XM.XdProduct.xdProductFetch() call like this:
    XM.ItemSitePrivate.fetch("XM.XdProduct", "xdruple.xd_commerce_product", query, 'product_id', 'id');
  */
  XM.ItemSitePrivate.fetch = function fetch (recordType, query, keySearchAttrMap) {
    var data = Object.create(XT.Data);
    var nameSpace = recordType.beforeDot();
    var type = recordType.afterDot();
    var includeNumberBarcodeAliasParam = false;
    var payload = {
      username: XT.username,
      nameSpace: nameSpace,
      type: type,
      query: query
    };

    if (query.parameters) {
      var customerId = null;
      var accountId = -1;
      var shiptoId = null;
      var effectiveDate = new Date();
      var vendorId = null;

      payload.query.parameters = query.parameters.filter(function (param) {
        /* Over-ride usual search behavior by adding parameters. */
        if (param.keySearch) {

          includeNumberBarcodeAliasParam = {
            attribute: keySearchAttrMap.concat(param.attribute).unique(),
            operator: 'BEGINS_WITH',
            value: param.value
          };

          return false;
        }

        switch (param.attribute) {
          case "customer":
            customerId = XT.Data.getId(XT.Data.fetchOrm('XM', 'CustomerProspectRelation'), param.value);
            accountId = XT.Data.getId(XT.Data.fetchOrm('XM', 'AccountRelation'), param.value);
            return false;
          case "shipto":
            shiptoId = XT.Data.getId(XT.Data.fetchOrm('XM', 'CustomerShipto'), param.value);
            return false;
          case "effectiveDate":
            effectiveDate = param.value;
            return false;
          case "vendor":
            vendorId = XT.Data.getId(XT.Data.fetchOrm('XM', 'VendorRelation'), param.value);
            return false;
          default:
            return true;
        }

        return true;
      });

      if (includeNumberBarcodeAliasParam) {
        data.addWhereClauseDynamicExtension(nameSpace, type, function (originPayload) {
          var extnSql = '';
          var literalIndex = data.whereLiteralValues.length + 1;
          var whereClause = data.buildWhereClause(originPayload, includeNumberBarcodeAliasParam, literalIndex);

          if (whereClause && whereClause.whereLiteralValues && whereClause.whereLiteralValues.length > 0) {
            Array.prototype.push.apply(data.whereLiteralValues, whereClause.whereLiteralValues);

            /* The above `includeNumberBarcodeAliasParam` will produce a clause like:
             *
             *   (
             *     number ~^ $1
             *     OR barcode ~^ $1
             *     -- Plus any additional param.attributes here.
             *   )
             *
             * Trim the trailing `)\n` and spaces off so we can add the `OR id IN (` alias clause below.
             */
            var trimmedClause = whereClause.whereClause.trim();
            if (trimmedClause.indexOf(')', trimmedClause.length - 1) !== -1) {
              extnSql = '  AND ' + trimmedClause.substr(0, (trimmedClause.length - 1)) + /* Remove the `)` from the end. */
                        '    OR id IN (\n' +
                        '      SELECT\n' +
                        '        itemsite_id AS id\n' +
                        '      FROM itemsite\n' +
                        '      JOIN (\n' +
                        '        SELECT\n' +
                        '          itemalias_item_id AS itemsite_item_id\n' +
                        '        FROM itemalias\n' +
                        '        WHERE true\n' +
                        '          AND itemalias_number ~^ $' + data.whereLiteralValues.length + '\n' +
                        '          AND (false\n' +
                        '            OR itemalias_crmacct_id IS NULL\n' +
                        '            OR itemalias_crmacct_id = $' + data.whereLiteralValues.push(accountId) + '\n' +
                        '          )\n' +
                        '      ) AS itemalias_item_id USING (itemsite_item_id)\n' +
                        '    )\n' +
                        '  )\n'; /* Add the removed `)` back. */

            }
          }

          return extnSql;
        });
      }

      /* If customer passed, restrict results to item sites allowed to be sold to that customer */
      if (customerId || shiptoId) {
        data.addJoinClauseDynamicExtension(nameSpace, type, function (originPayload) {
          var extSql =  'JOIN (\n' +
                        '  SELECT\n' +
                        '    itemsite_id AS id\n' +
                        '  FROM itemsite\n' +
                        '  JOIN custitem(\n' +
                        '    $' + data.whereLiteralValues.push(customerId) + ',\n' +
                        '    $' + data.whereLiteralValues.push(shiptoId) + ',\n' +
                        '    $' + data.whereLiteralValues.push(effectiveDate) + '\n' +
                        '  ) AS itemsite_item_id USING (itemsite_item_id)\n' +
                        ') AS cust_itemsites USING (id)\n';

          return extSql;
        });
      }

      /* If vendor passed and vendor can only supply against defined item sources, then restrict results. */
      if (vendorId) {
        var isItemSourceRequiredSql = 'SELECT vend_restrictpurch FROM vendinfo WHERE vend_id = $1';
        var isItemSourceRequired = plv8.execute(isItemSourceRequiredSql, [vendorId])[0];

        if (isItemSourceRequired && isItemSourceRequired.vend_restrictpurch) {
          data.addJoinClauseDynamicExtension(nameSpace, type, function (originPayload) {
            var extSql =  'JOIN (\n' +
                          '  SELECT\n' +
                          '    itemsite_id AS id\n' +
                          '  FROM itemsite\n' +
                          '  JOIN (\n' +
                          '    SELECT\n' +
                          '      itemsrc_item_id AS itemsite_item_id\n' +
                          '    FROM itemsrc\n' +
                          '    WHERE true\n' +
                          '      AND itemsrc_active\n' +
                          '      AND itemsrc_vend_id = $' + data.whereLiteralValues.push(vendorId) + '\n' +
                          '  ) AS itemsite_item_id USING (itemsite_item_id)\n' +
                          ') AS vend_itemsrc USING (id)\n';

            return extSql;
          });
        }
      }
    }

    return data.fetch(payload);
  };

  if (!XM.ItemSiteListItem) { XM.ItemSiteListItem = {}; }

  XM.ItemSiteListItem.isDispatchable = true;

  /**
    Returns item site list items using usual query means with additional special support for:
      * Attributes `customer`,`shipto`, and `effectiveDate` for exclusive item rules.
      * Attribute `vendor` to filter on only items with associated item sources.
      * Cross check on `alias` and `barcode` attributes for item numbers.

    @param {String} Record type. Must have `itemsite` or related view as its orm source table.
    @param {Object} Additional query filter (Optional)
    @returns {Array}
  */
  XM.ItemSiteListItem.fetch = function (query) {
    var keySearchAttrMap = [
      'item.number',
      'item.barcode'
    ];
    var result = XM.ItemSitePrivate.fetch("XM.ItemSiteListItem", query, keySearchAttrMap);
    return result.data;
  };

  /**
   Wrapper for XM.ItemSitePrivate.fetch with support for REST query formatting.
   Sample usage:
    select xt.post('{
      "nameSpace":"XM",
      "type":"ItemSiteListItem",
      "dispatch":{
        "functionName":"restFetch",
        "parameters":[
          {
            "query":[
              {"customer":{"EQUALS":"TTOYS"}},
              {"shipto":{"EQUALS":"1d103cb0-dac6-11e3-9c1a-0800200c9a66"}},
              {"effectiveDate":{"EQUALS":"2014-05-01"}}
            ]
          }
        ]
      },
      "username":"admin",
      "encryptionKey":"hm6gnf3xsov9rudi"
    }');

   @param {Object} options: query
   @returns Object
  */
  XM.ItemSiteListItem.restFetch = function (options) {
    options = options || {};

    var items = {},
      query = {},
      result = {};

    var keySearchAttrMap = [
      'item.number',
      'item.barcode'
    ];

    if (options) {
      /* Convert from rest_query to XM.Model.query structure. */
      query = XM.Model.restQueryFormat("XM.ItemSiteListItem", options);

      /* Perform the query. */
      return XM.ItemSitePrivate.fetch("XM.ItemSiteListItem", query, keySearchAttrMap);
    } else {
      throw new handleError("Bad Request", 400);
    }
  };
  XM.ItemSiteListItem.restFetch.description = "Returns ItemSiteListItems with additional special support for exclusive item rules, to filter on only items with associated item sources and Cross check on `alias` and `barcode` attributes for item numbers.";
  XM.ItemSiteListItem.restFetch.request = {
    "$ref": "ItemSiteListItemQuery"
  };
  XM.ItemSiteListItem.restFetch.parameterOrder = ["options"];
  // For JSON-Schema deff, see:
  // https://github.com/fge/json-schema-validator/issues/46#issuecomment-14681103
  XM.ItemSiteListItem.restFetch.schema = {
    ItemSiteListItemQuery: {
      properties: {
        attributes: {
          title: "ItemSiteListItem Service request attributes",
          description: "An array of attributes needed to perform a ItemSiteListItem query.",
          type: "array",
          items: [
            {
              title: "Options",
              type: "object",
              "$ref": "ItemSiteListItemOptions"
            }
          ],
          "minItems": 1,
          "maxItems": 1,
          required: true
        }
      }
    },
    ItemSiteListItemOptions: {
      properties: {
        query: {
          title: "query",
          description: "The query to perform.",
          type: "array",
          items: [
            {
              title: "column",
              type: "object"
            }
          ],
          "minItems": 1
        },
        orderby: {
          title: "Order By",
          description: "The query order by.",
          type: "array",
          items: [
            {
              title: "column",
              type: "object"
            }
          ]
        },
        rowlimit: {
          title: "Row Limit",
          description: "The query for paged results.",
          type: "integer"
        },
        maxresults: {
          title: "Max Results",
          description: "The query limit for total results.",
          type: "integer"
        },
        pagetoken: {
          title: "Page Token",
          description: "The query offset page token.",
          type: "integer"
        },
        count: {
          title: "Count",
          description: "Set to true to return only the count of results for this query.",
          type: "boolean"
        }
      }
    }
  };

  if (!XM.ItemSiteRelation) { XM.ItemSiteRelation = {}; }

  XM.ItemSiteRelation.isDispatchable = true;

  /**
    Returns item site relatinos using usual query means with additional special support for:
      * Attributes `customer`,`shipto`, and `effectiveDate` for exclusive item rules.
      * Attribute `vendor` to filter on only items with associated item sources.
      * Cross check on `alias` and `barcode` attributes for item numbers.

    @param {String} Record type. Must have `itemsite` or related view as its orm source table.
    @param {Object} Additional query filter (Optional)
    @returns {Array}
  */
  XM.ItemSiteRelation.fetch = function (query) {
    var keySearchAttrMap = [
      'number',
      'barcode'
    ];
    var result = XM.ItemSitePrivate.fetch("XM.ItemSiteRelation", query, keySearchAttrMap);
    return result.data;
  };

}());

$$ );
