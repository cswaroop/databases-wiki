select xt.install_js('XM','Model','xtuple', $$
  /* Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
     See www.xm.ple.com/CPAL for the full text of the software license. */

  if (!XM.Model) { XM.Model = {}; }

  XM.Model.isDispatchable = true;

  if (!XM.PrivateModel)  { XM.PrivateModel = {}; }
  XM.PrivateModel.isDispatchable = false;

  /**
    Pass in a record type and get the next id for that type

    @param {String} record type
    @returns Number
  */
  XM.Model.fetchId = function(recordType) {
    var nameSpace = recordType.beforeDot(),
        type = recordType.afterDot(),
        map = XT.Orm.fetch(nameSpace, type),
        seq = map.idSequenceName,
        sql = 'select nextval($1) as result';

    return seq ? plv8.execute(sql, [seq])[0].result : false;
  }

  /**
    Pass in a record type and get the next id for that type

    @param {String} record type
    @returns Number
  */
  XM.Model.fetchNumber = function(recordType) {
    var nameSpace = recordType.beforeDot(),
        type = recordType.afterDot(),
        map = XT.Orm.fetch(nameSpace, type),
        seq = map.orderSequence,
        sql = 'select fetchNextNumber($1) as result';

    /**  if the order sequence name in orderseq is not found in the ORM
      throw an error */
    if (seq) {
      return plv8.execute(sql, [seq])[0].result;
    } else {
      plv8.elog(ERROR, "orderSequence is not defined in the ORM");
    }
  },

  /**
    Pass in a uuid and get the public table's pk

    @param {String} uuid
    @returns Number
  */
  XM.Model.fetchPrimaryKeyId = function (options) {
    var schema = "public",
      tableName,
      sql,
      sql1 = "SELECT tblname AS tblname " +
        "FROM xt.obj_uuid WHERE obj_uuid = $1;",
      sql2 = "SELECT {table}_id AS id " +
        "FROM {table} WHERE obj_uuid = $1;",
      id,
      lineItemId;

    if (options.docUuid) {
      tableName = plv8.execute(sql1, [options.docUuid])[0];
      if (!tableName) {
        return plv8.elog(ERROR, "UUID " + options.docUuid + " not found in xt.obj_uuid table");
      }
      /* This could possibly be replaced with a query that doesn't depend on the xt.obj_uuid table */
      id = plv8.execute(sql2.replace(/{table}/g, tableName.tblname), [options.docUuid])[0].id;
    }

    if (options.lineItemUuid) {
      tableName = plv8.execute(sql1, [options.lineItemUuid])[0];
      if (!tableName) {
        return plv8.elog(ERROR, "UUID " + options.lineItemUuid + " not found in xt.obj_uuid table");
      }
      lineItemId = plv8.execute(sql2.replace(/{table}/g, tableName.tblname), [options.lineItemUuid])[0].id;
    }

    if (options.docNumber && options.table && options.column) {
      /* Handle xt.<tableName> */
      if (options.table.indexOf('.') !== -1) {
        schema = options.table.split(".")[0];
        options.table = options.table.split(".")[1];
      }
      sql = "SELECT {table}_id AS id FROM {schema}.{table} WHERE {column} = $1"
        .replace(/{schema}/g, schema)
        .replace(/{table}/g, options.table)
        .replace(/{column}/, options.column);

      id = plv8.execute(sql, [options.docNumber])[0].id;
    }

    if (!id) {
      throw new handleError("id not found", 400);
    }
    if (lineItemId && id) {
      return {lineItemId: lineItemId, id: id}
    }
    return id;
  },

  /**
    Obtain a pessemistic record lock. Defaults to timeout of 30 seconds.

    @param {String} Namespace
    @param {String} Type
    @param {String|Number} Id
    @param {String} etag
    @param {Object} Options: timeout
  */
  XM.Model.obtainLock = function (nameSpace, type, id, etag, options) {
    var orm = XT.Orm.fetch(nameSpace, type),
       data = Object.create(XT.Data),
       lockTable = orm.lockTable || orm.table,
       pkey = XT.Orm.primaryKey(orm),
       nkey = XT.Orm.naturalKey(orm),
       rec,
       pid;

    /* If the model uses a natural key, get the primary key value. */
    rec = data.retrieveRecord({
      nameSpace: nameSpace,
      type: type,
      id: id,
      silentError: true
    });

    if (!rec) { return false; }

    pid = nkey ? data.getId(orm, id) : id;
    if (!pid) {
// TODO - Send not found message back.
      return false;
    }

    if (!rec || !rec.data) { throw "Record for requested lock not found." }
    if (rec.etag !== etag) { return false; }

    return data.tryLock(lockTable, pid);
  }

  /**
    Renew a record lock. Defaults to timeout of 30 seconds.

    @param {Number} Key
    @param {Object} Options: timeout
  */
  XM.Model.renewLock = function (key, options) {
    return XT.Data.renewLock(key, options);
  }

  /**
    Release a record lock.

    @param {Number} key
  */
  XM.Model.releaseLock = function (key) {
    return XT.Data.releaseLock(key);
  }

  /**
    Release a number back into the sequence pool for a given type.

    @param {String} record type
    @param {Number} number
    @returns Boolean
  */
  XM.Model.releaseNumber = function(recordType, number) {
    var nameSpace = recordType.beforeDot(),
        type = recordType.afterDot(),
        map = XT.Orm.fetch(nameSpace, type),
        seq = map.orderSequence,
        sql = 'select releaseNumber($1, $2) as result';

    return seq ? plv8.execute(sql, [seq, number - 0])[0].result > 0 : false;
  }

  /**
    Return a matching record id for a passed user key and value. If none found returns zero.

    @param {String} record type
    @param {String} user key
    @param {Number} value
    @returns Number
  */
  XM.Model.findExisting = function(recordType, key, value, id) {
    var nameSpace = recordType.beforeDot(),
        type = recordType.afterDot(),
        map = XT.Orm.fetch(nameSpace, type),
        table = recordType.decamelize(),
        okey = XT.Orm.naturalKey(map) || XT.Orm.primaryKey(map),
        sql = 'select "{key}" as id from {table} where "{userKey}"::text=$1::text'
              .replace(/{key}/, okey)
              .replace(/{table}/, table)
              .replace(/{userKey}/, key),
        result;
        if (id) {
          sql += " and " + okey + " != $2";
          if (DEBUG) { XT.debug('XM.Model.findExisting sql = ', sql); }
          result = plv8.execute(sql, [value, id])[0];
        } else {
          if (DEBUG) { XT.debug('XM.Model.findExisting sql = ', sql); }
          result = plv8.execute(sql, [value])[0];
        }

    return result ? result.id : 0;
  };

  /**
   Returns a complex query's results.
   Sample usage:
    select xt.post('{
      "username": "admin",
      "nameSpace": "XM",
      "type": "Model",
      "dispatch":{
        "functionName":"query",
        "parameters":[
          "Address", {"query": {"parameters": [{"attribute": "city","operator": "=","value": "Norfolk"}]}}
        ]
      }
    }');

   @param {String} recordType to query
   @param {Object} options: query
   @returns Object
  */
  XM.Model.query = function (recordType, options) {
    options = options || {};
    var query = {};

    if (recordType && options && options.query) {
      query.username = XT.username;
      query.nameSpace = 'XM';
      query.type = recordType;
      query.query = options.query;
    }

    result = XT.Rest.get(query);

    return result;
  };
  XM.Model.query.scope = "Model";
  XM.Model.query.description = "Perform an complex query on a resource. This allows you to use a POST body for the query vs. a long URL.";
  XM.Model.query.request = {
    "$ref": "Query"
  };
  XM.Model.query.parameterOrder = ["recordType", "options"];
  // For JSON-Schema deff, see:
  // https://github.com/fge/json-schema-validator/issues/46#issuecomment-14681103
  XM.Model.query.schema = {
    Query: {
      properties: {
        attributes: {
          title: "Service request attributes",
          description: "An array of attributes needed to perform a complex query.",
          type: "array",
          items: [
            {
              title: "Resource",
              description: "The resource to query.",
              type: "string",
              required: true
            },
            {
              title: "Options",
              type: "object",
              "$ref": "QueryOptions"
            }
          ],
          "minItems": 2,
          "maxItems": 2,
          required: true
        }
      }
    },
    QueryOptions: {
      properties: {
        query: {
          title: "query",
          description: "The query to perform.",
          type: "object",
          "$ref": "QueryOptionsQuery"
        }
      }
    },
    QueryOptionsQuery: {
      properties: {
        parameters: {
          title: "Parameters",
          description: "The query parameters.",
          type: "array",
          items: [
            {
              title: "Attribute",
              type: "object",
              "$ref": "QueryOptionsParameters"
            }
          ],
          "minItems": 1
        },
        orderBy: {
          title: "Order By",
          description: "The query order by.",
          type: "array",
          items: [
            {
              title: "Attribute",
              type: "object",
              "$ref": "QueryOptionsOrderBy"
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
    },
    QueryOptionsParameters: {
      properties: {
        attribute: {
          title: "Attribute",
          description: "The column name used to construct the query's WHERE clasues.",
          type: "string",
          required: true
        },
        operator: {
          title: "Operator",
          description: "The operator used to construct the query's WHERE clasues.",
          type: "string"
        },
        value: {
          title: "Value",
          description: "The value used to construct the query's WHERE clasues.",
          required: true
        }
      }
    },
    QueryOptionsOrderBy: {
      properties: {
        attribute: {
          title: "Attribute",
          description: "The column name used to construct the query's ORDER BY.",
          type: "string",
          required: true
        },
        descending: {
          title: "Direction",
          description: "Set to true so the query's ORDER BY will be DESC.",
          type: "boolean"
        }
      }
    }
  };

  /**
   * TODO: This is a duplication of the node-datasource code here:
   *   node-datasource/lib/rest-query-format/index.js
   * TODO: Once require('rest-query-format') works in plv8, just require it here.
   *
   * Format a complex REST API query structure into an xTuple's datasource database query.
   *
   * This is a helper function that reformats the query structure from a REST API
   * query in to our XT.Rest query format. This function should be used by reformat
   * any REST API client queries.
   *
   * Example usage:
   *   var myQueryRequest = {
   *     "query": {
   *       "city":{"EQUALS":"Norfolk"}
   *     },
   *     "orderby": {
   *       "ASC": "line1",
   *       "DESC": "line2"
   *     }
   *   },
   *   payload = {
   *     nameSpace: "XM",
   *     type: "Address"
   *   };
   *   payload.query = XM.Model.restQueryFormat("XM.Address", "/db-name-here/api/v1alpha1/resources/address", myQueryRequest);
   *   if (payload.query) {
   *     return routes.queryDatabase("get", payload, session, callback);
   *   }
   *
   * @param {String} recordType: The ORM recordType to query.
   * @param {String} requestString: Optional. The original request's query string.
   *                                This could be the URL path requested or the
   *                                POSTed request query body for service dipatch calls.
   *                                It is only used to log errors.
   * @param {Object} requestQuery: The REST API requested query object.
   *
   * @returns {Object} The formated query ready to be passed to the datasource.
   */
  XM.Model.restQueryFormat = function (recordType, requestString, requestQuery) {
    try {
      var order = {},
          param = {},
          query = {},
          nameSpace = recordType.split(".")[0],
          type = recordType.split(".")[1],
          schema,
          validColNamePattern = new RegExp("^[a-zA-Z_][a-zA-Z0-9_]*$"),
          mapOperator = function (op) {
            // Convert REST API operator format to datasource format.
            var operators = {
                  value: {
                    ANY:          "ANY",
                    NOT_ANY:      "NOT ANY",
                    EQUALS:       "=",
                    NOT_EQUALS:   "!=",
                    LESS_THAN:    "<",
                    AT_MOST:      "<=",
                    GREATER_THAN: ">",
                    AT_LEAST:     ">=",
                    MATCHES:      "MATCHES",
                    BEGINS_WITH:  "BEGINS_WITH"
                  }
                };

            if (operators.value[op]) {
              return operators.value[op];
            } else {
              throw new Error();
            }
          },
          validateColumn = function (column) {
            // Make sure the column name is a valid PostgreSQL string.
            // Make sure the column is in the schema for this recordType.
            var valid = false,
              parentColumn = column.split(".")[0];

            if (validColNamePattern.test(column)) {
              for (var c = 0; c < schema.columns.length; c++) {
                // TODO: Only checking the recordType parameter columns, not any
                // toOne/toMany child columns. e.g. "[address.city]"
                if (schema.columns[c].name === parentColumn) {
                  valid = true;
                }
              }
            }

            return valid;
          },
          validateValue = function (value) {            
            // The value should be an array, string, boolean or numeric.
            if (Array.isArray(value)) {
              return value;
            }
            switch (typeof value) {
              case "boolean":
              case "number":
              case "string":
                return value;
              default:
                throw new Error();
            }
          };

      requestQuery = requestQuery || {};

      if (typeof plv8 !== "undefined") {
        // Get the schema in plv8.
        schema = XT.Session.schema(nameSpace.decamelize(), type.decamelize())[type];
      } else {
        // Get the schema in node-datasource.
        schema = XT.session.schemas.XM.attributes[type];
      }

      /* Convert from REST API query to XM.Model.query structure. */
      if (requestQuery) {
        if (requestQuery.query) {
          query.parameters = [];
          for (var column in requestQuery.query) {
            if (validateColumn(column)) {
              for (var op in requestQuery.query[column]) {
                param = {};
                param.attribute = column;
                param.operator = mapOperator(op);
                param.value = validateValue(requestQuery.query[column][op]);
                query.parameters.push(param);
              }
            } else {
              throw new Error();
            }
          }
        }

        /* Convert from REST API free text query to XM.Model.query structure. */
        if (recordType && requestQuery.q) {
          /* Add string columns to search query. */
          param = {
            "attribute": []
          };

          // TODO: Test that schema variable in plv8 works here.
          for (var c = 0; c < schema.columns.length; c++) {
            if (schema.columns[c].category === "S") {
              param.attribute.push(schema.columns[c].name);
            }
          }

          if (param.attribute.length) {
            /* Add all string columns to attribute query. */
            query.parameters = query.parameters || [];
            param.operator = "MATCHES";

            /* Replace any spaces with regex ".*" so multi-word search works on similar strings. */
            param.value = requestQuery.q.replace(" ", ".*");
            query.parameters.push(param);
          }
        }

        /* Convert from REST API orderBy query to XM.Model.query structure. */
        if (requestQuery.orderby || requestQuery.orderBy) {
          requestQuery.orderBy = requestQuery.orderby || requestQuery.orderBy;
          delete requestQuery.orderby;
          query.orderBy = [];
          for (var col in requestQuery.orderBy) {
            if (validateColumn(col)) {
              order = {};
              order.attribute = col;
              if (requestQuery.orderBy[col] === "DESC") {
                order.descending = true;
              } else {
                order.descending = false;
              }
              query.orderBy.push(order);
            } else {
              throw new Error();
            }
          }
        }

        /* Convert from REST API rowLimit query to XM.Model.query structure. */
        if (requestQuery.rowlimit || requestQuery.rowLimit) {
          requestQuery.rowLimit = +requestQuery.rowlimit || +requestQuery.rowLimit;
          delete requestQuery.rowlimit;
          query.rowLimit = requestQuery.rowLimit;
        } else {
          query.rowLimit = 100;
        }

        /* Convert from REST API maxResults query to XM.Model.query rowLimit structure. */
        if (requestQuery.maxresults || requestQuery.maxResults) {
          requestQuery.maxResults = +requestQuery.maxresults || +requestQuery.maxResults;
          delete requestQuery.maxresults;
          query.rowLimit = requestQuery.maxResults;
        }

        /* Convert from REST API pageToken query to XM.Model.query rowOffset structure. */
        if (requestQuery.pagetoken || requestQuery.pageToken) {
          requestQuery.pageToken = +requestQuery.pagetoken || +requestQuery.pageToken;
          delete requestQuery.pagetoken;
          if (query.rowLimit) {
            query.rowOffset = (requestQuery.pageToken || 0) * (query.rowLimit);
          } else {
            query.rowOffset = (requestQuery.pageToken || 0);
          }
        }

        /* Convert from REST API count query to XM.Model.query structure. */
        if (requestQuery.count || (requestQuery.hasOwnProperty("count") && requestQuery.count !== false)) {
          query.count = true;
        }
      }

      return query;
    } catch (err) {
      // Log this error to the console. The restRouter will send a 400 error back to the client.
      if (typeof plv8 !== "undefined") {
        plv8.elog(WARNING, "Bad REST query requestString: ", requestString,
                           "\nQuery string:\n", JSON.stringify(requestQuery, null, 2),
                           "\nStack ", err.stack);
      } else {
        // Log this error to the console. The restRouter will send a 400 error back to the client.
        X.err("Bad REST query requestString: ", requestString,
              "\nQuery string:\n", JSON.stringify(requestQuery, null, 2),
              "\nStack ", err.stack);
      }

      return false;
    }
  };

  /**
   Returns a complex query's results using the REST query structure. This is a
   wrapper for XM.Model.query that reformats the query structure from a
   rest_query to our XT.Rest structure. This dispatch function can be used by
   a REST API client to query a resource when the query would be too long to
   pass to the API as a GET URL query.

   Sample usage:
    select xt.post('{
      "username": "admin",
      "nameSpace": "XM",
      "type": "Model",
      "dispatch":{
        "functionName":"restQuery",
        "parameters":["Address", {"query": {"city":{"EQUALS":"Norfolk"}}, "orderby": {"line1": "ASC", "line2": "DESC"}}]
      }
    }');

   @param {String} recordType to query
   @param {Object} options: query
   @returns Object
  */
  XM.Model.restQuery = function (recordType, options) {
    options = options || {};
    var formattedOptions = {},
        query;

    /* Convert from rest_query to XM.Model.query structure. */
    if (recordType && options) {
      query = XM.Model.restQueryFormat("XM." + recordType, "XM.Model.restQuery for " + recordType, options);
      if (query) {
        formattedOptions = {
          "query": query
        };
      } else {
        throw new handleError("Bad Request", 400);
      }
    }

    result = XM.Model.query(recordType, formattedOptions);

    return result;
  };
  XM.Model.restQuery.description = "Perform an complex query on a resource using the REST query structure. This allows you to use a POST body for the query vs. a long URL.";
  XM.Model.restQuery.request = {
    "$ref": "RestQuery"
  };
  XM.Model.restQuery.parameterOrder = ["recordType", "options"];
  // For JSON-Schema deff, see:
  // https://github.com/fge/json-schema-validator/issues/46#issuecomment-14681103
  XM.Model.restQuery.schema = {
    RestQuery: {
      properties: {
        attributes: {
          title: "Service request attributes",
          description: "An array of attributes needed to perform a complex query.",
          type: "array",
          items: [
            {
              title: "Resource",
              description: "The resource to query.",
              type: "string",
              required: true
            },
            {
              title: "Options",
              type: "object",
              "$ref": "RestQueryOptions"
            }
          ],
          "minItems": 2,
          "maxItems": 2,
          required: true
        }
      }
    },
    RestQueryOptions: {
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

  /**
    Used to determine whether a model is used or not.

    @param {String} Record Type
    @param {String|Number} Id
    @param {Array} Array of schema qualified foreign key table names that are exceptions
    @private
  */
  XM.PrivateModel.used = function(recordType, id, exceptions) {
      exceptions = exceptions || [];
      var nameSpace = recordType.beforeDot(),
      type = recordType.afterDot(),
      map = XT.Orm.fetch(nameSpace, type),
      data = Object.create(XT.Data),
      nkey = XT.Orm.naturalKey(map),
      tableName = map.lockTable || map.table,
      tableSuffix = tableName.indexOf('.') ? tableName.afterDot() : tableName,
      sql,
      fkeys,
      uses,
      i,
      attr,
      seq,
      tableName,
      fkIndex,
      fkey,
      propIndex,
      probObj;

    if (nkey) {
      id = data.getId(map, id);
      if (!id) {
        /* Throw an error here because returning false is a valid use case. */
        plv8.elog(ERROR, "Can not find primary key.");
      }
    }

    /* Determine where this record is used by analyzing foreign key linkages */
    sql = "select pg_namespace.nspname AS schemaname, " +
          "con.relname AS tablename, " +
          "conkey AS seq, " +
          "conrelid AS class_id " +
          "from pg_constraint, pg_class f, pg_class con, pg_namespace " +
          "where confrelid=f.oid " +
          "and conrelid=con.oid " +
          "and f.relname = $1 " +
          "and con.relnamespace=pg_namespace.oid; "
    fkeys = plv8.execute(sql, [tableSuffix]);

    /* isNested toMany relationships are irrelevant and should not be counted */
    /* First boil down our list of isNested toManys from the orm */
    var toMany = map.properties.filter(function (prop) {
      return prop.toMany && prop.toMany.isNested;
    }).map(function (prop) {
      var toManyType = prop.toMany.type,
        toManyMap = XT.Orm.fetch(nameSpace, toManyType)
        toManyTable = toManyMap.lockTable || toManyMap.table,
        toManyPrefix = toManyTable.indexOf('.') < 0 ? "public" : toManyTable.beforeDot(),
        toManySuffix = toManyTable.afterDot();

      return {nameSpace: toManyPrefix, tableName: toManySuffix};
    });

    if (DEBUG) { XT.debug('XM.Model.used toMany relations are:', JSON.stringify(toMany)); }

    for (fkIndex = fkeys.length - 1; fkIndex >= 0; fkIndex-=1) {
      /* loop backwards because we might be deleting elements of the array */
      fkey = fkeys[fkIndex];
      toMany.map(function (prop) {
        if (fkey.schemaname === prop.nameSpace && fkey.tablename === prop.tableName) {
          fkeys.splice(fkIndex, 1);
        }
      });
    }

    /* Remove exceptions */
    fkeys = fkeys.filter(function (key) {
      var name = key.schemaname + '.' + key.tablename;
      return !exceptions.contains(name);
    });

    if (DEBUG) { XT.debug('XM.Model.used keys length:', fkeys.length) }
    if (DEBUG) { XT.debug('XM.Model.used keys:', JSON.stringify(fkeys)) }

    for (i = 0; i < fkeys.length; i++) {
      /* Validate */

      sql = "select attname " +
            "from pg_attribute, pg_class " +
            "where ((attrelid=pg_class.oid) " +
            " and (pg_class.oid = $1) " +
            " and (attnum = $2)); ";

      classId = fkeys[i].class_id;
      seq =  fkeys[i].seq[0];
      tableName = fkeys[i].schemaname + '.' + fkeys[i].tablename;
      if (DEBUG) { XT.debug('XM.Model.used vars:', [classId, seq, tableName]) }
      attr = plv8.execute(sql, [classId, seq])[0].attname;

      /* See if there are dependencies */
      sql = 'select * from ' + tableName + ' where ' + attr + ' = $1 limit 1;'
      uses = plv8.execute(sql, [id]);
      if (uses.length) { return true; }
    }

    return false
  }

  /**
    Return whether a model is referenced by another table.
  */
  XM.Model.used = function(recordType, id) {
    return XM.PrivateModel.used(recordType, id);
  };

$$ );
