select xt.install_js('XT','Data','xtuple', $$

(function () {

  /**
   * @class
   *
   * The XT.Data class includes all functions necessary to process data source requests against the database.
   * It should be instantiated as an object against which its funtion calls are made. This class enforces privilege
   * control and as such is not and should not be dispatchable.
   */

  XT.Data = {

    ARRAY_TYPE: 'A',
    COMPOSITE_TYPE: 'C',
    DATE_TYPE: 'D',
    STRING_TYPE: 'S',

    CREATED_STATE: 'create',
    READ_STATE: 'read',
    UPDATED_STATE: 'update',
    DELETED_STATE: 'delete',

    /**
     * Queries whether the current user has been granted the privilege passed.
     *
     * @param {String} privilege
     * @returns {Boolean}
     */
    checkPrivilege: function (privilege) {
      var i,
        privArray,
        res,
        ret = privilege,
        sql;

      if (typeof privilege === 'string') {
        if (!this._granted) { this._granted = {}; }
        if (!this._granted[XT.username]) { this._granted[XT.username] = {}; }
        if (this._granted[XT.username][privilege] !== undefined) { return this._granted[XT.username][privilege]; }

        /* The privilege name is allowed to be a set of space-delimited privileges */
        /* If a user has any of the applicable privileges then they get access */
        privArray = privilege.split(" ");
        sql = 'select coalesce(usrpriv_priv_id, grppriv_priv_id, -1) > 0 as granted ' +
               'from priv ' +
               'left join usrpriv on (priv_id=usrpriv_priv_id) and (usrpriv_username=$1) ' +
               'left join ( ' +
               '  select distinct grppriv_priv_id ' +
               '  from grppriv ' +
               '    join usrgrp on (grppriv_grp_id=usrgrp_grp_id) and (usrgrp_username=$1) ' +
               '  ) grppriv on (grppriv_priv_id=priv_id) ' +
               'where priv_name = $2';

        for (var i = 1; i < privArray.length; i++) {
          sql = sql + ' or priv_name = $' + (i + 2);
        }
        sql = sql + "order by granted desc limit 1;";

        /* Cleverness: the query parameters are just the priv array with the username tacked on front. */
        privArray.unshift(XT.username);

        if (DEBUG) {
          XT.debug('checkPrivilege sql =', sql);
          XT.debug('checkPrivilege values =', privArray);
        }
        res = plv8.execute(sql, privArray);
        ret = res.length ? res[0].granted : false;

        /* Memoize. */
        this._granted[XT.username][privilege] = ret;
      }

      if (DEBUG) {
        XT.debug('Privilege check for "' + XT.username + '" on "' + privilege + '" returns ' + ret);
      }

      return ret;
    },

    /**
     * Validate whether user has read access to data. If a record is passed, check personal privileges of
     * that record.
     *
     * @param {String} name space
     * @param {String} type name
     * @param {Object} record - optional
     * @param {Boolean} is top level, default is true
     * @returns {Boolean}
     */
    checkPrivileges: function (nameSpace, type, record, isTopLevel) {
      isTopLevel = isTopLevel !== false ? true : false;
      var action =  record && record.dataState === this.CREATED_STATE ? 'create' :
                  record && record.dataState === this.DELETED_STATE ? 'delete' :
                  record && record.dataState === this.UPDATED_STATE ? 'update' : 'read',
        committing = record ? record.dataState !== this.READ_STATE : false,
        isGrantedAll = true,
        isGrantedPersonal = false,
        map = this.fetchOrm(nameSpace, type),
        privileges = map.privileges,
        pkey,
        old;

      /* If there is no ORM, this isn't a table data type so no check required. */
      /*
      if (DEBUG) {
        XT.debug('orm type is ->', map.type);
        XT.debug('orm is ->', map);
      }
      */
      if (!map) { return true; }

      /* Can not access 'nested only' records directly. */
      if (DEBUG) {
        XT.debug('is top level ->', isTopLevel);
        XT.debug('is nested ->', map.isNestedOnly);
      }
      if (isTopLevel && map.isNestedOnly) { return false; }

      /* Check privileges - first do we have access to anything? */
      if (privileges) {
        if (DEBUG) { XT.debug('privileges found', privileges); }
        if (committing) {
          if (DEBUG) { XT.debug('is committing'); }

          /* Check if user has 'all' read privileges. */
          isGrantedAll = privileges.all ? this.checkPrivilege(privileges.all[action]) : false;

          /* Otherwise check for 'personal' read privileges. */
          if (!isGrantedAll) {
            isGrantedPersonal =  privileges.personal ?
              this.checkPrivilege(privileges.personal[action]) : false;
          }
        } else {
          if (DEBUG) { XT.debug('is NOT committing'); }

          /* Check if user has 'all' read privileges. */
          isGrantedAll = privileges.all ?
                         this.checkPrivilege(privileges.all.read) ||
                         this.checkPrivilege(privileges.all.update) : false;

          /* Otherwise check for 'personal' read privileges. */
          if (!isGrantedAll) {
            isGrantedPersonal =  privileges.personal ?
              this.checkPrivilege(privileges.personal.read) ||
              this.checkPrivilege(privileges.personal.update) : false;
          }
        }
      }

      /* If we're checknig an actual record and only have personal privileges, */
      /* see if the record allows access. */
      if (record && !isGrantedAll && isGrantedPersonal && action !== "create") {
        if (DEBUG) { XT.debug('checking record level personal privileges'); }
        var that = this,

        /* Shared checker function that checks 'personal' properties for access rights. */
        checkPersonal = function (record) {
          var i = 0,
            isGranted = false,
            props = privileges.personal.properties,
            get = function (obj, target) {
              var idx,
                part,
                parts = target.split("."),
                ret;

              for (var idx = 0; idx < parts.length; idx++) {
                part = parts[idx];
                ret = ret ? ret[part] : obj[part];
                if (ret === null || ret === undefined) {
                  return null;
                }
              }

              return ret;
            };

          while (!isGranted && i < props.length) {
            var prop = props[i],
                personalUser = get(record, prop);

            if (personalUser instanceof Array) {
              for (var userIdx = 0; userIdx < personalUser.length; userIdx++) {
                if (personalUser[userIdx].toLowerCase() === XT.username) {
                  isGranted = true;
                }
              }
            } else if (personalUser) {
              isGranted = personalUser.toLowerCase() === XT.username;
            }

            i++;
          }

          return isGranted;
        };

        /* If committing we need to ensure the record in its previous state is editable by this user. */
        if (committing && (action === 'update' || action === 'delete')) {
          pkey = XT.Orm.naturalKey(map) || XT.Orm.primaryKey(map);
          old = this.retrieveRecord({
            nameSpace: nameSpace,
            type: type,
            id: record[pkey],
            superUser: true,
            includeKeys: true
          });
          isGrantedPersonal = checkPersonal(old.data);

        /* Otherwise check personal privileges on the record passed. */
        } else if (action === 'read') {
          isGrantedPersonal = checkPersonal(record);
        }
      }

      if (DEBUG) {
        XT.debug('is granted all ->', isGrantedAll);
        XT.debug('is granted personal ->', isGrantedPersonal);
      }

      return isGrantedAll || isGrantedPersonal;
    },

    /**
     * Commit array columns with their own statements
     *
     * @param {Object} Orm
     * @param {Object} Record
     */
    commitArrays: function (orm, record, encryptionKey) {
      var pkey = XT.Orm.primaryKey(orm),
        fkey,
        ormp,
        prop,
        val,
        values,
        columnToKey,
        propToKey,

        resolveKey = function (col) {
          var attr;

          /* First search properties */
          var ary = orm.properties.filter(function (prop) {
            return prop.attr && prop.attr.column === col;
          });

          if (ary.length) {
            attr =  ary[0].name;

          } else {
            /* If not found must be extension, search relations */
            if (orm.extensions.length) {
              orm.extensions.forEach(function (ext) {
                if (!attr) {
                  ary = ext.relations.filter(function (prop) {
                    return prop.column === col;
                  });

                  if (ary.length) {
                    attr = ary[0].inverse;
                  }
                }
              })
            };
          }
          if (attr) { return attr };

          /* If still not found, we have a structural problem */
          throw new Error("Can not resolve primary id on toMany relation");
        };

      for (prop in record) {
        ormp = XT.Orm.getProperty(orm, prop);

        /* If the property is an array of objects they must be records so commit them. */
        if (ormp.toMany && ormp.toMany.isNested) {
          fkey = ormp.toMany.inverse;
          values = record[prop];

          for (var i = 0; i < values.length; i++) {
            val = values[i];

            /* Populate the parent key into the foreign key field if it's absent. */
            if (!val[fkey]) {
              columnToKey = ormp.toMany.column;
              propToKey = columnToKey ? resolveKey(columnToKey) : pkey;
              if (!record[propToKey]) {
                /* If there's no data, we have a structural problem */
                throw new Error("Can not resolve foreign key on toMany relation " + ormp.name);
              }
              val[fkey] = record[propToKey];
            }

            this.commitRecord({
              nameSpace: orm.nameSpace,
              type: ormp.toMany.type,
              data: val,
              encryptionKey: encryptionKey
            });
          }
        }
      }
    },

    /**
     * Commit metrics that have changed to the database.
     *
     * @param {Object} metrics
     * @returns Boolean
     */
    commitMetrics: function (metrics) {
      var key,
        sql = 'select setMetric($1,$2)',
        value;

      for (key in metrics) {
        value = metrics[key];
        if (typeof value === 'boolean') {
          value = value ? 't' : 'f';
        } else if (typeof value === 'number') {
          value = value.toString();
        }

        if (DEBUG) {
          XT.debug('commitMetrics sql =', sql);
          XT.debug('commitMetrics values =', [key, value]);
        }
        plv8.execute(sql, [key, value]);
      }

      return true;
    },

    /**
     * Commit a record to the database. The record must conform to the object hiearchy as defined by the
     * record's `ORM` definition. Each object in the tree must include state information on a reserved property
     * called `dataState`. Valid values are `create`, `update` and `delete`. Objects with other dataState values including
     * `undefined` will be ignored. State values can be added using `XT.jsonpatch.updateState(obj, state)`.
     *
     * @seealso XT.jsonpatch.updateState
     * @param {Object} Options
     * @param {String} [options.nameSpace] Namespace. Required.
     * @param {String} [options.type] Type. Required.
     * @param {Object} [options.data] The data payload to be processed. Required
     * @param {Number} [options.etag] Record version for optimistic locking.
     * @param {Object} [options.lock] Lock information for pessemistic locking.
     * @param {Boolean} [options.superUser=false] If true ignore privilege checking.
     * @param {String} [options.encryptionKey] Encryption key.
     */
    commitRecord: function (options) {
      var data = options.data,
        dataState = data ? data.dataState : false,
        hasAccess = options.superUser ||
          this.checkPrivileges(options.nameSpace, options.type, data, false);

      if (!hasAccess) { throw new Error("Access Denied."); }
      switch (dataState)
      {
      case (this.CREATED_STATE):
        this.createRecord(options);
        break;
      case (this.UPDATED_STATE):
        this.updateRecord(options);
        break;
      case (this.DELETED_STATE):
        this.deleteRecord(options);
      }
    },

    /**
     * Commit insert to the database
     *
     * @param {Object} Options
     * @param {String} [options.nameSpace] Namespace. Required.
     * @param {String} [options.type] Type. Required.
     * @param {Object} [options.data] The data payload to be processed. Required.
     * @param {String} [options.encryptionKey] Encryption key.
     */
    createRecord: function (options) {
      var data = options.data,
        encryptionKey = options.encryptionKey,
        i,
        orm = this.fetchOrm(options.nameSpace, options.type),
        sql,
        pkey = XT.Orm.primaryKey(orm),
        rec;

      /*
        https://github.com/xtuple/xtuple/pull/1964
        Document associations are stored "wrong" on the client.
        Swap out the object of a document association for its primary key
      */
      if (orm.type === "DocumentAssociation" && typeof data.target === "object") {
        var targetType = XT.documentAssociations[data.targetType];
        var targetOrm = this.fetchOrm("XM", targetType);
        var targetNaturalKeyAttr = XT.Orm.naturalKey(targetOrm);
        var targetId = this.getId(targetOrm, data.target[targetNaturalKeyAttr]);
        data.target = targetId;
      }
      sql = this.prepareInsert(orm, data, null, encryptionKey);

      /* Handle extensions on the same table. */
      for (var i = 0; i < orm.extensions.length; i++) {
        if (orm.extensions[i].table === orm.table) {
          sql = this.prepareInsert(orm.extensions[i], data, sql, encryptionKey);
        }
      }

      /* Commit the base record. */
      if (DEBUG) {
        XT.debug('createRecord sql =', sql.statement);
        XT.debug('createRecord values =', sql.values);
      }

      if (sql.statement) {
        rec = plv8.execute(sql.statement, sql.values);
        /* Make sure the primary key is populated */
        if (!data[pkey]) {
          data[pkey] = rec[0].id;
        }
        /* Make sure the obj_uuid is populated, if applicable */
        if (!data.obj_uuid && rec[0] && rec[0].obj_uuid) {
          data.uuid = rec[0].obj_uuid;
        }
      }

      /* Handle extensions on other tables. */
      for (var i = 0; i < orm.extensions.length; i++) {
        if (orm.extensions[i].table !== orm.table &&
           !orm.extensions[i].isChild) {
          sql = this.prepareInsert(orm.extensions[i], data, null, encryptionKey);

          if (DEBUG) {
            XT.debug('createRecord sql =', sql.statement);
            XT.debug('createRecord values =', sql.values);
          }

          if (sql.statement) {
            plv8.execute(sql.statement, sql.values);
          }
        }
      }

      /* Okay, now lets handle arrays. */
      this.commitArrays(orm, data, encryptionKey);

      /*
       * After commitArrays, trigger an update to this parent record so any
       * update triggers fire that rely on data in those array commits.
       * This allows things like characteristics on SO Lines to create child WOs.
       */
      var columnNKey = XT.Orm.naturalKey(orm, true);
      var columnPKey = XT.Orm.primaryKey(orm, true);
      if (columnNKey && options.nameSpace === 'XM') {
        var updateSql = 'UPDATE %1$I.%2$I SET %3$I = %4$I WHERE %5$I = $1';
        if (orm.table.indexOf(".") > 0) {
          var namespace = orm.table.beforeDot();
          var table = orm.table.afterDot();
          updateSql = XT.format(updateSql, [namespace, table, columnNKey, columnNKey, columnPKey]);
        } else {
          updateSql = XT.format(updateSql, ['public', orm.table, columnNKey, columnNKey, columnPKey]);
        }
        updateParams = [data[pkey]];

        if (DEBUG) {
          XT.debug('createRecord update sql =', updateSql);
          XT.debug('createRecord update values =', updateParams);
        }

        plv8.execute(updateSql, updateParams);
      }
    },

    /**
     * Use an orm object and a record and build an insert statement. It
     * returns an object with a table name string, columns array, expressions
     * array and insert statement string that can be executed.
     *
     * The optional params object includes objects columns, expressions
     * that can be cumulatively added to the result.
     *
     * @params {Object} Orm
     * @params {Object} Record
     * @params {Object} Params - optional
     * @params {String} Encryption Key
     * @returns {Object}
     */
    prepareInsert: function (orm, record, params, encryptionKey) {
      var attr,
        attributePrivileges,
        columns,
        count,
        encryptQuery,
        encryptSql,
        exp,
        i,
        iorm,
        namespace,
        nkey,
        ormp,
        pkey = XT.Orm.primaryKey(orm),
        prop,
        query,
        sql = "select nextval($1) as id",
        table,
        toOneQuery,
        toOneSql,
        type,
        val,
        isValidSql = params && params.statement ? true : false,
        canEdit;

      params = params || {
        table: "",
        columns: [],
        expressions: [],
        identifiers: [],
        values: []
      };
      params.table = orm.table;
      count = params.values.length + 1;

      /* If no primary key, then create one. */
      if (!record[pkey] && orm.idSequenceName) {
        if (DEBUG) {
          XT.debug('prepareInsert sql =', sql);
          XT.debug('prepareInsert values =', [orm.idSequenceName]);
        }
        record[pkey] = plv8.execute(sql, [orm.idSequenceName])[0].id;
      }

      /* If extension handle key. */
      if (orm.relations) {
        for (var i = 0; i < orm.relations.length; i++) {
          column = orm.relations[i].column;
          if (!params.identifiers.contains(column)) {
            params.columns.push("%" + count + "$I");
            params.values.push(record[orm.relations[i].inverse]);
            params.expressions.push('$' + count);
            params.identifiers.push(orm.relations[i].column);
            count++;
          }
        }
      }

      /* Build up the content for insert of this record. */
      for (var i = 0; i < orm.properties.length; i++) {
        ormp = orm.properties[i];
        prop = ormp.name;

        if (ormp.toMany && ormp.toMany.column === 'obj_uuid') {
          params.parentUuid = true;
        }

        attr = ormp.attr ? ormp.attr : ormp.toOne ? ormp.toOne : ormp.toMany;
        type = attr.type;
        iorm = ormp.toOne ? this.fetchOrm(orm.nameSpace, ormp.toOne.type) : false,
        nkey = iorm ? XT.Orm.naturalKey(iorm, true) : false;
        val = ormp.toOne && record[prop] instanceof Object ?
          record[prop][nkey || ormp.toOne.inverse || 'id'] : record[prop];

        /**
         * Ignore derived fields for insert/update
         */
        if (attr.derived) continue;

        attributePrivileges = orm.privileges &&
          orm.privileges.attribute &&
          orm.privileges.attribute[prop];

        if(!attributePrivileges || attributePrivileges.create === undefined) {
          canEdit = true;
        } else if (typeof attributePrivileges.create === 'string') {
          canEdit = this.checkPrivilege(attributePrivileges.create);
        } else {
          canEdit = attributePrivileges.create; /* if it's true or false */
        }

        /* Handle fixed values. */
        if (attr.value !== undefined) {
          params.columns.push("%" + count + "$I");
          params.expressions.push('$' + count);
          params.values.push(attr.value);
          params.identifiers.push(attr.column);
          isValidSql = true;
          count++;

        /* Handle passed values. */
        } else if (canEdit && val !== undefined && val !== null && !ormp.toMany) {
          if (attr.isEncrypted) {
            if (encryptionKey) {
              encryptQuery = "select encrypt(setbytea(%1$L), setbytea(%2$L), %3$L)";
              encryptSql = XT.format(encryptQuery, [record[prop], encryptionKey, 'bf']);
              val = record[prop] ? plv8.execute(encryptSql)[0].encrypt : null;
              params.columns.push("%" + count + "$I");
              params.values.push(val);
              params.identifiers.push(attr.column);
              params.expressions.push("$" + count);
              isValidSql = true;
              count++;
            } else {
              throw new Error("No encryption key provided.");
            }
          } else {
            if (ormp.toOne && nkey) {
              if (iorm.table.indexOf(".") > 0) {
                toOneQuery = "select %1$I from %2$I.%3$I where %4$I = $" + count;
                toOneSql = XT.format(toOneQuery, [
                    XT.Orm.primaryKey(iorm, true),
                    iorm.table.beforeDot(),
                    iorm.table.afterDot(),
                    nkey
                  ]);
              } else {
                toOneQuery = "select %1$I from %2$I where %3$I = $" + count;
                toOneSql = XT.format(toOneQuery, [
                    XT.Orm.primaryKey(iorm, true),
                    iorm.table,
                    nkey
                  ]);
              }
              exp = "(" + toOneSql + ")";
              params.expressions.push(exp);
            } else {
              params.expressions.push('$' + count);
            }

            params.columns.push("%" + count + "$I");
            params.values.push(val);
            params.identifiers.push(attr.column);
            isValidSql = true;
            count++;
          }
        /* Handle null value if applicable. */
        } else if (canEdit && val === undefined || val === null) {
          if (attr.nullValue) {
            params.columns.push("%" + count + "$I");
            params.values.push(attr.nullValue);
            params.identifiers.push(attr.column);
            params.expressions.push('$' + count);
            isValidSql = true;
            count++;
          } else if (attr.required) {
            plv8.elog(ERROR, "Attribute " + ormp.name + " is required.");
          }
        }
      }

      if (!isValidSql) {
        return false;
      }

      /* Build the insert statement */
      columns = params.columns.join(', ');
      columns = XT.format(columns, params.identifiers);
      expressions = params.expressions.join(', ');
      expressions = XT.format(expressions, params.identifiers);

      if (params.table.indexOf(".") > 0) {
        namespace = params.table.beforeDot();
        table = params.table.afterDot();
        query = 'insert into %1$I.%2$I (' + columns + ') values (' + expressions + ')';
        params.statement = XT.format(query, [namespace, table]);
      } else {
        query = 'insert into %1$I (' + columns + ') values (' + expressions + ')';
        params.statement = XT.format(query, [params.table]);
      }

      /* If we can get the primary key column we want to return that
         for cases where it is determined behind the scenes */
      if (!record[pkey] && !params.primaryKey) {
        params.primaryKey = XT.Orm.primaryKey(orm, true);
      }

      if (params.primaryKey && params.parentUuid) {
        params.statement = params.statement + ' returning ' + params.primaryKey + ' as id, obj_uuid';
      } else if (params.parentUuid) {
        params.statement = params.statement + ' returning obj_uuid';
      } else if (params.primaryKey) {
        params.statement = params.statement + ' returning ' + params.primaryKey + ' as id';
      }

      if (DEBUG) {
        XT.debug('prepareInsert statement =', params.statement);
        XT.debug('prepareInsert values =', params.values);
      }

      return params;
    },

    /**
     * Commit update to the database
     *
     * @param {Object} Options
     * @param {String} [options.nameSpace] Namespace. Required.
     * @param {String} [options.type] Type. Required.
     * @param {Object} [options.data] The data payload to be processed. Required.
     * @param {Number} [options.etag] Record version for optimistic locking.
     * @param {Object} [options.lock] Lock information for pessemistic locking.
     * @param {String} [options.encryptionKey] Encryption key.
     */
    updateRecord: function (options) {
      var data = options.data,
        encryptionKey = options.encryptionKey,
        orm = this.fetchOrm(options.nameSpace, options.type),
        pkey = XT.Orm.primaryKey(orm),
        id = data[pkey],
        ext,
        etag = this.getVersion(orm, id),
        i,
        iORuQuery,
        iORuSql,
        lock,
        lockKey = options.lock && options.lock.key ? options.lock.key : false,
        lockTable = orm.lockTable || orm.table,
        rows,
        sql = this.prepareUpdate(orm, data, null, encryptionKey);

      /* Test for optimistic lock. */
      if (!XT.disableLocks && etag && options.etag !== etag) {
      // TODO - Improve error handling.
        plv8.elog(ERROR, "The version being updated is not current.");
      }
      /* Test for pessimistic lock. */
      if (orm.lockable) {
        lock = this.tryLock(lockTable, id, {key: lockKey});
        if (!lock.key) {
          // TODO - Improve error handling.
          plv8.elog(ERROR, "Can not obtain a lock on the record.");
        }
      }

      /* Okay, now lets handle arrays. */
      this.commitArrays(orm, data, encryptionKey);

      /* Handle extensions on the same table. */
      for (var i = 0; i < orm.extensions.length; i++) {
        if (orm.extensions[i].table === orm.table) {
          sql = this.prepareUpdate(orm.extensions[i], data, sql, encryptionKey);
        }
      }

      sql.values.push(id);

      /* Commit the base record. */
      if (DEBUG) {
        XT.debug('updateRecord sql =', sql.statement);
        XT.debug('updateRecord values =', sql.values);
      }
      plv8.execute(sql.statement, sql.values);

      /* Handle extensions on other tables. */
      for (var i = 0; i < orm.extensions.length; i++) {
        ext = orm.extensions[i];
        if (ext.table !== orm.table &&
           !ext.isChild) {

          /* Determine whether to insert or update. */
          if (ext.table.indexOf(".") > 0) {
            iORuQuery = "select %1$I from %2$I.%3$I where %1$I = $1;";
            iORuSql = XT.format(iORuQuery, [
                ext.relations[0].column,
                ext.table.beforeDot(),
                ext.table.afterDot()
              ]);
          } else {
            iORuQuery = "select %1$I from %2$I where %1$I = $1;";
            iORuSql = XT.format(iORuQuery, [ext.relations[0].column, ext.table]);
          }

          if (DEBUG) {
            XT.debug('updateRecord sql =', iORuSql);
            XT.debug('updateRecord values =', [data[pkey]]);
          }
          rows = plv8.execute(iORuSql, [data[pkey]]);

          if (rows.length) {
            sql = this.prepareUpdate(ext, data, null, encryptionKey);
            sql.values.push(id);
          } else {
            sql = this.prepareInsert(ext, data, null, encryptionKey);
          }

          if (DEBUG) {
            XT.debug('updateRecord sql =', sql.statement);
            XT.debug('updateRecord values =', sql.values);
          }

          if (sql.statement) {
            plv8.execute(sql.statement, sql.values);
          }
        }
      }

      /* Release any lock. */
      if (orm.lockable) {
        this.releaseLock({table: lockTable, id: id});
      }
    },

    /**
     * Use an orm object and a record and build an update statement. It
     * returns an object with a table name string, expressions array and
     * insert statement string that can be executed.
     *
     * The optional params object includes objects columns, expressions
     * that can be cumulatively added to the result.
     *
     * @params {Object} Orm
     * @params {Object} Record
     * @params {Object} Params - optional
     * @returns {Object}
     */
    prepareUpdate: function (orm, record, params, encryptionKey) {
      var attr,
        attributePrivileges,
        columnKey,
        count,
        encryptQuery,
        encryptSql,
        exp,
        expressions,
        iorm,
        key,
        keyValue,
        namespace,
        ormp,
        pkey,
        prop,
        query,
        table,
        toOneQuery,
        toOneSql,
        type,
        val,
        isValidSql = false,
        canEdit;

      params = params || {
        table: "",
        expressions: [],
        identifiers: [],
        values: []
      };
      params.table = orm.table;
      count = params.values.length + 1;

      if (orm.relations) {
        /* Extension. */
        pkey = orm.relations[0].inverse;
        columnKey = orm.relations[0].column;
      } else {
        /* Base. */
        pkey = XT.Orm.primaryKey(orm);
        columnKey = XT.Orm.primaryKey(orm, true);
      }

      /* Build up the content for update of this record. */
      for (var i = 0; i < orm.properties.length; i++) {
        ormp = orm.properties[i];
        prop = ormp.name;
        attr = ormp.attr ? ormp.attr : ormp.toOne ? ormp.toOne : ormp.toMany;
        type = attr.type;
        iorm = ormp.toOne ? this.fetchOrm(orm.nameSpace, ormp.toOne.type) : false;
        nkey = iorm ? XT.Orm.naturalKey(iorm, true) : false;
        val = ormp.toOne && record[prop] instanceof Object ?
          record[prop][nkey || ormp.toOne.inverse || 'id'] : record[prop],

        attributePrivileges = orm.privileges &&
          orm.privileges.attribute &&
          orm.privileges.attribute[prop];

        /**
         * Ignore derived fields for insert/update
         */
        if (attr.derived) continue;

        if(!attributePrivileges || attributePrivileges.update === undefined) {
          canEdit = true;
        } else if (typeof attributePrivileges.update === 'string') {
          canEdit = this.checkPrivilege(attributePrivileges.update);
        } else {
          canEdit = attributePrivileges.update; /* if it's true or false */
        }

        if (canEdit && val !== undefined && !ormp.toMany) {

          /* Handle encryption if applicable. */
          if (attr.isEncrypted) {
            if (encryptionKey) {
              encryptQuery = "select encrypt(setbytea(%1$L), setbytea(%2$L), %3$L)";
              encryptSql = XT.format(encryptQuery, [val, encryptionKey, 'bf']);
              val = record[prop] ? plv8.execute(encryptSql)[0].encrypt : null;
              params.values.push(val);
              params.identifiers.push(attr.column);
              params.expressions.push("%" + count + "$I = $" + count);
              isValidSql = true;
              count++;
            } else {
              // TODO - Improve error handling.
              throw new Error("No encryption key provided.");
            }
          } else if (ormp.name !== pkey) {
            if (val === null) {
              if (attr.required) {
                plv8.elog(ERROR, "Attribute " + ormp.name + " is required.");
              } else {
                params.values.push(attr.nullValue || null);
                params.expressions.push("%" + count + "$I = $" + count);
              }
            } else if (ormp.toOne && nkey) {
              if (iorm.table.indexOf(".") > 0) {
                toOneQuery = "select %1$I from %2$I.%3$I where %4$I = $" + count;
                toOneSql = XT.format(toOneQuery, [
                    XT.Orm.primaryKey(iorm, true),
                    iorm.table.beforeDot(),
                    iorm.table.afterDot(),
                    nkey
                  ]);
              } else {
                toOneQuery = "select %1$I from %2$I where %3$I = $" + count;
                toOneSql = XT.format(toOneQuery, [
                    XT.Orm.primaryKey(iorm, true),
                    iorm.table,
                    nkey
                  ]);
              }

              exp = "%" + count + "$I = (" + toOneSql + ")";
              params.values.push(val);
              params.expressions.push(exp);
            } else {
              params.values.push(val);
              params.expressions.push("%" + count + "$I = $" + count);
            }
            params.identifiers.push(attr.column);
            isValidSql = true;
            count++;
          }
        }
      }

      /* Build the update statement */
      expressions = params.expressions.join(', ');
      expressions = XT.format(expressions, params.identifiers);

      // do not send an invalid sql statement
      if (!isValidSql) { return params; }

      if (params.table.indexOf(".") > 0) {
        namespace = params.table.beforeDot();
        table = params.table.afterDot();
        query = 'update %1$I.%2$I set ' + expressions + ' where %3$I = $' + count + ';';
        params.statement = XT.format(query, [namespace, table, columnKey]);
      } else {
        query = 'update %1$I set ' + expressions + ' where %2$I = $' + count + ';';
        params.statement = XT.format(query, [params.table, columnKey]);
      }

      if (DEBUG) {
        XT.debug('prepareUpdate statement =', params.statement);
        XT.debug('prepareUpdate values =', params.values);
      }

      return params;
    },

    /**
     * Commit deletion to the database
     *
     * @param {Object} Options
     * @param {String} [options.nameSpace] Namespace. Required.
     * @param {String} [options.type] Type. Required.
     * @param {Object} [options.data] The data payload to be processed. Required.
     * @param {Number} [options.etag] Optional record id version for optimistic locking.
     *  If set and version does not match, delete will fail.
     * @param {Number} [options.lock] Lock information for pessemistic locking.
     */
    deleteRecord: function (options) {
      var data = options.data,
        orm = this.fetchOrm(options.nameSpace, options.type, {silentError: true}),
        pkey,
        nkey,
        id,
        columnKey,
        etag,
        ext,
        i,
        lockKey = options.lock && options.lock.key ? options.lock.key : false,
        lockTable,
        namespace,
        prop,
        ormp,
        query = '',
        sql = '',
        table,
        values;

      /* Set variables or return false with message. */
      if (!orm) {
        throw new handleError("Not Found", 404);
      }

      pkey = XT.Orm.primaryKey(orm);
      nkey = XT.Orm.naturalKey(orm);
      lockTable = orm.lockTable || orm.table;
      if (!pkey && !nkey) {
        throw new handleError("Not Found", 404);
      }

      id = nkey ? this.getId(orm, data[nkey]) : data[pkey];
      if (!id) {
        throw new handleError("Not Found", 404);
      }

      /* Test for optional optimistic lock. */
      etag = this.getVersion(orm, id);
      if (etag && options.etag && etag !== options.etag) {
        throw new handleError("Precondition Required", 428);
      }

      /* Test for pessemistic lock. */
      if (orm.lockable) {
        lock = this.tryLock(lockTable, id, {key: lockKey});
        if (!lock.key) {
          throw new handleError("Conflict", 409);
        }
      }

      /* Delete children first. */
      for (prop in data) {
        ormp = XT.Orm.getProperty(orm, prop);

        /* If the property is an array of objects they must be records so delete them. */
        if (ormp.toMany && ormp.toMany.isNested) {
          values = data[prop];
          for (var i = 0; i < values.length; i++) {
            this.deleteRecord({
              nameSpace: options.nameSpace,
              type: ormp.toMany.type,
              data: values[i]
            });
          }
        }
      }

      /* Next delete from extension tables. */
      for (var i = 0; i < orm.extensions.length; i++) {
        ext = orm.extensions[i];
        if (ext.table !== orm.table &&
            !ext.isChild) {
          columnKey = ext.relations[0].column;
          nameKey = ext.relations[0].inverse;

          if (ext.table.indexOf(".") > 0) {
            namespace = ext.table.beforeDot();
            table = ext.table.afterDot();
            query = 'delete from %1$I.%2$I where %3$I = $1';
            sql = XT.format(query, [namespace, table, columnKey]);
          } else {
            query = 'delete from %1$I where %2$I = $1';
            sql = XT.format(query, [ext.table, columnKey]);
          }

          if (DEBUG) {
            XT.debug('deleteRecord sql =', sql);
            XT.debug('deleteRecord values =',  [id]);
          }
          plv8.execute(sql, [id]);
        }
      }

      /* Now delete the top. */
      nameKey = XT.Orm.primaryKey(orm);
      columnKey = XT.Orm.primaryKey(orm, true);

      if (orm.table.indexOf(".") > 0) {
        namespace = orm.table.beforeDot();
        table = orm.table.afterDot();
        query = 'delete from %1$I.%2$I where %3$I = $1';
        sql = XT.format(query, [namespace, table, columnKey]);
      } else {
        query = 'delete from %1$I where %2$I = $1';
        sql = XT.format(query, [orm.table, columnKey]);
      }

      /* Commit the record.*/
      if (DEBUG) {
        XT.debug('deleteRecord sql =', sql);
        XT.debug('deleteRecord values =', [id]);
      }
      plv8.execute(sql, [id]);

      /* Release any lock. */
      if (orm.lockable) {
        this.releaseLock({table: lockTable, id: id});
      }
    },

    /**
     * Decrypts properties where applicable.
     *
     * @param {String} name space
     * @param {String} type
     * @param {Object} record
     * @param {Object} encryption key
     * @returns {Object}
     */
    decrypt: function (nameSpace, type, record, encryptionKey) {
      var result,
        that = this,
        hexToAlpha = function (hex) {
          var str = '', i;
          for (i = 2; i < hex.length; i += 2) {
            str += String.fromCharCode(parseInt(hex.substr(i, 2), 16));
          }
          return str;
        },
        orm = this.fetchOrm(nameSpace, type);

      for (prop in record) {
        var ormp = XT.Orm.getProperty(orm, prop.camelize());

        /* Decrypt property if applicable. */
        if (ormp && ormp.attr && ormp.attr.isEncrypted) {
          if (encryptionKey) {
            sql = "select formatbytea(decrypt($1, setbytea($2), 'bf')) as result";
            // TODO - Handle not found error.

            if (DEBUG && false) {
              XT.debug('decrypt prop =', prop);
              XT.debug('decrypt sql =', sql);
              XT.debug('decrypt values =', [record[prop], encryptionKey]);
            }
            result = plv8.execute(sql, [record[prop], encryptionKey])[0].result;
            /* we SOMETIMES need to translate from hex here */
            if(typeof result === 'string' && result.substring(0, 2) === '\\x') {
              result = result ? hexToAlpha(result) : result;
            }
            /* in the special case of encrypted credit card numbers, we don't give the
              user the full decrypted number EVEN IF they have the encryption key */
            if(ormp.attr.isEncrypted === "credit_card_number" && result && result.length >= 4) {
              record[prop] = "************" + result.substring(result.length - 4);
            } else {
              record[prop] = result;
            }
          } else {
            record[prop] = '**********';
          }

        /* Check recursively. */
        } else if (ormp.toOne && ormp.toOne.isNested) {
          that.decrypt(nameSpace, ormp.toOne.type, record[prop], encryptionKey);

        } else if (ormp.toMany && ormp.toMany.isNested) {
          record[prop].map(function (subdata) {
            that.decrypt(nameSpace, ormp.toMany.type, subdata, encryptionKey);
          });
        }
      }

      return record;
    },

    /**
      Fetches the ORM. Caches the result in this data object, where it can be used
      for this request but will be conveniently forgotten between requests.
     */
    fetchOrm: function (nameSpace, type) {
      var res,
        ret,
        recordType = nameSpace + '.'+ type;

      if (!this._maps) {
        this._maps = [];
      }

      res = this._maps.findProperty('recordType', recordType);
      if (res) {
        ret = res.map;
      } else {
        ret = XT.Orm.fetch(nameSpace, type);

        /* cache the result so we don't requery needlessly */
        this._maps.push({ "recordType": recordType, "map": ret});
      }
      return ret;
    },

    /**
     * Get the current database server version.
     * If the optional precision argument is passed, return the first prec
     * fields of the full version number.
     *
     * @example
     * var x   = getPgVersion(1),       // '9'
     *     xy  = getPgVersion(2),       // '9.1'
     *     xyz = getPgVersion(3),       // '9.1.3'
     *     all = getPgVersion();        // '9.1.3'
     *
     * @param   {Number} proc - optional precision
     * @returns {String} X[.Y[.Z]]
     */
    getPgVersion: function (prec) {
      var q = plv8.execute("select setting from pg_settings " +
                           "where name='server_version';"),
          ret;
      ret = q[0].setting;
      if (typeof prec === 'number') {
        ret = ret.split(".").slice(0,prec).join(".");
      }
      return ret;
    },

    /**
     * Get the oid for a given table name.
     *
     * @param {String} table name
     * @returns {Number}
     */
    getTableOid: function (table) {
      var tableName = this.getTableFromNamespacedTable(table).toLowerCase(), /* be generous */
        namespace = this.getNamespaceFromNamespacedTable(table),
        ret,
        sql = "select pg_class.oid::integer as oid " +
             "from pg_class join pg_namespace on relnamespace = pg_namespace.oid " +
             "where relname = $1 and nspname = $2";

      if (DEBUG) {
        XT.debug('getTableOid sql =', sql);
        XT.debug('getTableOid values =', [tableName, namespace]);
      }
      ret = plv8.execute(sql, [tableName, namespace])[0].oid - 0;

      // TODO - Handle not found error.

      return ret;
    },

    /**
     * Get the primary key id for an object based on a passed in natural key.
     *
     * @param {Object} Orm
     * @param {String} Natural key value
     */
    getId: function (orm, value) {
      var ncol = XT.Orm.naturalKey(orm, true),
        pcol = XT.Orm.primaryKey(orm, true),
        query,
        ret,
        sql;

      if (orm.table.indexOf(".") > 0) {
        namespace = orm.table.beforeDot();
        table = orm.table.afterDot();
        query = "select %1$I as id from %2$I.%3$I where %4$I = $1";
        sql = XT.format(query, [pcol, namespace, table, ncol]);
      } else {
        query = "select %1$I as id from %2$I where %3$I = $1";
        sql = XT.format(query, [pcol, orm.table, ncol]);
      }

      if (DEBUG) {
        XT.debug('getId sql =', sql);
        XT.debug('getId values =', [value]);
      }

      ret = plv8.execute(sql, [value]);

      if(ret.length) {
        return ret[0].id;
      } else {
        throw new handleError("Primary Key not found on " + orm.table +
          " where " + ncol + " = " + value, 400);
      }
    },

    getNamespaceFromNamespacedTable: function (fullName) {
      return fullName.indexOf(".") > 0 ? fullName.beforeDot() : "public";
    },

    getTableFromNamespacedTable: function (fullName) {
      return fullName.indexOf(".") > 0 ? fullName.afterDot() : fullName;
    },

// TODO: Do we need to use this function in buildQuery?
    getPgTypeFromOrmType: function (schema, table, column) {
      var sql = "select data_type from information_schema.columns " +
                "where true " +
                "and table_schema = $1 " +
                "and table_name = $2 " +
                "and column_name = $3;",
          pgType,
          values = [schema, table, column];

      if (DEBUG) {
        XT.debug('getPgTypeFromOrmType sql =', sql);
        XT.debug('getPgTypeFromOrmType values =', values);
      }

      pgType = plv8.execute(sql, values);
      pgType = pgType && pgType[0] ? pgType[0].data_type : false;

      return pgType;
    },

    /**
     * Get the natural key id for an object based on a passed in primary key.
     *
     * @param {Object} Orm
     * @param {Number|String} Primary key value
     * @param {Boolean} safe Return the original value instead of erroring if no match is found
     */
    getNaturalId: function (orm, value, safe) {
      var ncol = XT.Orm.naturalKey(orm, true),
        pcol = XT.Orm.primaryKey(orm, true),
        query,
        ret,
        sql;

      if (orm.table.indexOf(".") > 0) {
        namespace = orm.table.beforeDot();
        table = orm.table.afterDot();
        query = "select %1$I as id from %2$I.%3$I where %4$I = $1";
        sql = XT.format(query, [ncol, namespace, table, pcol]);
      } else {
        query = "select %1$I as id from %2$I where %3$I = $1";
        sql = XT.format(query, [ncol, orm.table, pcol]);
      }

      if (DEBUG) {
        XT.debug('getNaturalId sql =', sql);
        XT.debug('getNaturalId values =', [value]);
      }

      ret = plv8.execute(sql, [value]);

      if (ret.length) {
        return ret[0].id;
      } else if (safe) {
        return value;
      } else {
        throw new handleError("Natural Key Not Found: " + orm.nameSpace + "." + orm.type, 400);
      }
    },

    /**
     * Returns the current version of a record.
     *
     * @param {Object} Orm
     * @param {Number|String} Record id
     */
    getVersion: function (orm, id) {
      if (!orm.lockable) {
        return;
      }

      var etag,
        i = 0,
        oid = this.getTableOid(orm.lockTable || orm.table),
        res,
        selectSql = 'select ver_etag from xt.ver where ver_table_oid = $1 and ver_record_id = $2;',
        insertSql = 'insert into xt.ver (ver_table_oid, ver_record_id, ver_etag) values ($1, $2, $3::uuid);';

      while (i < 5) {
        try {
          if (DEBUG) {
            XT.debug('getVersion sql = ', selectSql);
            XT.debug('getVersion values = ', [oid, id]);
          }
          res = plv8.execute(selectSql, [oid, id]);
          etag = res.length ? res[0].ver_etag : false;

          if (!etag) {
            etag = XT.generateUUID();

            if (DEBUG) {
              XT.debug('getVersion insert sql = ', insertSql);
              XT.debug('getVersion insert values = ', [oid, id, etag]);
            }
            plv8.execute(insertSql, [oid, id, etag]);
            /* The insert worked, exit the loop and move on. */
            break;
          } else {
            /* The select worked, exit the loop and move on. */
            break;
          }
        } catch (err) {
          /* It's possible to get ERROR duplicate key value violates unique constraint */
          /* "ver_ver_table_oid_ver_record_id" from the insert due to concurrency. */
          /* Continue looping and try the insert again. */
          plv8.elog(WARNING, 'Insert duplicate key error on XT.getVersion.');
          i++;
        }
      }

      return etag;
    },

    /**
     * Add additional parameters to the `payload.query` to enforce
     * privileges when building the query.
     *
     * @param payload {Object} The payload of query details.
     * @return {Array} The query result.
     */
    addPrivileges: function addPrivileges (payload) {
      if (!this.orm) {
        this.orm = this.fetchOrm(payload.nameSpace, payload.type);
      }

      var privileges = this.orm.privileges;

      if (this.orm.isNestedOnly) {
        plv8.elog(ERROR, 'Access Denied');
      }

      if (privileges &&
          (!privileges.all ||
            (privileges.all &&
              (!this.checkPrivilege(privileges.all.read) &&
              !this.checkPrivilege(privileges.all.update)))
          ) &&
          privileges.personal &&
          (this.checkPrivilege(privileges.personal.read) ||
            this.checkPrivilege(privileges.personal.update))
        ) {

        if (privileges.personal.properties.length > 0) {
          if (!payload.query) {
            payload.query = {
              parameters: []
            }
          }
          if (!payload.query.parameters) {
            payload.query.parameters = [];
          }

          /*
           * To improve Shared User Access performance, we set this flag here and
           * use it to control adding a `JOIN` below:
           *   `JOIN xm.share_users ON t1.uuid = share_users.uuid`
           * along with a `WHERE` clause:
           *   `AND share_users.username = XT.username-here`
           * This helps Postgres's query planner avoid a full scan of `xm.share_users`.
           */
          if (privileges.personal.properties.indexOf('crmaccountUsers') !== -1) {
            payload.query.crmaccountUsers = true;
          }

          payload.query.parameters.push({
            attribute: privileges.personal.properties,
            operator: 'MATCHES',
            value: XT.username
          });
        }
      }

      return payload;
    },

    /**
     * @typedef Query
     * @type Object
     * @property sql {String} The SQL query string.
     * @property values {Array} The `WHERE` clause literal values.
     */

    /**
     * Build the SQL query string from the payload.
     *
     * @param payload {Object} The payload of query details.
     * @return {Query} The SQL query object.
     */
    buildQuery: function buildQuery (payload) {
      payload = this.addPrivileges(payload);

      var parts = this.getQueryParts(payload);
      var sql = parts.select +
                parts.columns +
                parts.from +
                parts.joins +
                parts.where +
                parts.orderBy +
                parts.limit +
                parts.offset +
                ';';

      return {
        sql: sql,
        values: parts.whereLiteralValues
      };
    },

    /**
     * @typedef QueryParts
     * @type Object
     * @property select {String} The built `SELECT` clause.
     * @property columns {String} The built `SELECT` column list.
     * @property from {String} The built `FROM` clause.
     * @property joins {String} The built `JOIN` clauses.
     * @property where {String} The built `WHERE` clause.
     * @property orderBy {String} The built `ORDER BY` clause.
     * @property limit {String} The built `LIMIT` clause.
     * @property offset {String} The built `OFFSET` clause.
     * @property whereLiteralValues {Array} The `WHERE` clause literal values.
     */

    /**
     * Get the query parts from the payload.
     *
     * @param payload {Object} The payload of query details.
     * @return {QueryParts} The parts of the SQL Query.
     */
    getQueryParts: function getQueryParts (payload) {
      var queryParts = {};

      queryParts.select =this.buildSelect(payload);
      queryParts.columns = this.buildColumns(payload);
      queryParts.from = this.buildFrom(payload);
      queryParts.joins = this.buildJoins(payload);
      queryParts.where = this.buildWhere(payload);
      queryParts.orderBy = this.buildOrderBy(payload);
      queryParts.limit = this.buildLimit(payload);
      queryParts.offset = this.buildOffset(payload);
      queryParts.whereLiteralValues = this.whereLiteralValues;

      return queryParts;
    },

    /**
     * Build the `SELECT` clause from the payload.
     *
     * @param payload {Object} The payload of query details.
     * @return {String} The built `SELECT` clause.
     */
    buildSelect: function buildSelect (payload) {
      var selectClause = 'SELECT\n';

      return selectClause;
    },

    columnsStaticExtensions: this.columnsStaticExtensions || {},

    /**
     * Add a static, always present, extension handler function to `XT.Data.columnsStaticExtensions`
     * for a `nameSpace` and `type` ORM. The supplied `extFunc` will be called when building an
     * ORM's query's select columns'.
     *
     * @param nameSpace {String} The ORM nameSpace.
     * @param type {String} The ORM type to extend.
     * @param extFunc {Function} The extension function to run.
     */
    addColumnsStaticExtension: function addColumnsStaticExtension (nameSpace, type, extFunc) {
      if (!XT.Data.columnsStaticExtensions[nameSpace]) {
        XT.Data.columnsStaticExtensions[nameSpace] = {};
      }

      if (!XT.Data.columnsStaticExtensions[nameSpace][type]) {
        XT.Data.columnsStaticExtensions[nameSpace][type] = [];
      }

      XT.Data.columnsStaticExtensions[nameSpace][type].push(extFunc);
    },

    /**
     * Add a dynamic, runtime only, extension function to `this.columnsDynamicExtensions` for a
     * `nameSpace` and `type` ORM. Note, `columnsDynamicExtensions` does not exist on `XT.Data`
     * It is only present on a child object that inherits from `XT.Data`. See `XM.InventoryAvailability.fetch`
     * for a use of this function. The supplied `extFunc` will be called when building an ORM's
     * query's select columns'.
     *
     * @param nameSpace {String} The ORM nameSpace.
     * @param type {String} The ORM type to extend.
     * @param extFunc {Function} The extension function to run.
     */
    addColumnsDynamicExtension: function addColumnsDynamicExtension (nameSpace, type, extFunc) {
      if (!this.columnsDynamicExtensions) {
        this.columnsDynamicExtensions = {};
      }

      if (!this.columnsDynamicExtensions[nameSpace]) {
        this.columnsDynamicExtensions[nameSpace] = {};
      }

      if (!this.columnsDynamicExtensions[nameSpace][type]) {
        this.columnsDynamicExtensions[nameSpace][type] = [];
      }

      this.columnsDynamicExtensions[nameSpace][type].push(extFunc);
    },

    /**
     * Get the `SELECT` columns extensions and run them. The extension handler
     * functions are passed the payload and current columns. The handler should
     * modify or replace the columns string and return it.
     *
     * @param payload {Object} The payload of query details.
     * @param columns {String} The default columns built by `buildColumns()`.
     */
    buildColumnsExtensions: function buildColumnsExtensions (payload, columns) {
      var self = this;
      var columnExtensions = [];

      if (this.columnsStaticExtensions[payload.nameSpace] &&
          this.columnsStaticExtensions[payload.nameSpace][payload.type]) {

        columnExtensions = columnExtensions.concat(this.columnsStaticExtensions[payload.nameSpace][payload.type]);
      }

      if (this.columnsDynamicExtensions &&
          this.columnsDynamicExtensions[payload.nameSpace] &&
          this.columnsDynamicExtensions[payload.nameSpace][payload.type]) {

        columnExtensions = columnExtensions.concat(this.columnsDynamicExtensions[payload.nameSpace][payload.type]);
      }

      columnExtensions.forEach(function (extFunc) {
        columns = '-- Added by buildColumnsExtensions\n' +
                  extFunc.call(self, payload, columns);
      });

      return columns;
    },

    /**
     * Build the columns list from the payload.
     *
     * @param payload {Object} The payload of query details.
     * @return {String} The built `SELECT` column list.
     */
    buildColumns: function buildColumns (payload) {
      if (!this.orm) {
        this.orm = this.fetchOrm(payload.nameSpace, payload.type);
      }
      if (!this.whereLiteralValues) {
        this.whereLiteralValues = [];
      }

      /* The default `columnsClause` is `SELECT *`. */
      var columnsClause = '  *';

      if (payload.query && payload.query.count) {
        columnsClause = '  count(*)';
      } else {
        /* Pass off `columnsClause` to any extensions to modify it. */
        columnsClause = this.buildColumnsExtensions(payload, columnsClause);
      }

      return columnsClause + '\n';
    },

    /**
     * Build the `FROM` clause from the payload.
     *
     * @param payload {Object} The payload of query details.
     * @return {String} The built `FROM` clause.
     */
    buildFrom: function buildFrom (payload) {
      var fromClause = XT.format('FROM %1$I.%2$I AS t1\n', [payload.nameSpace.decamelize(), payload.type.decamelize()]);

      return fromClause;
    },

    /**
     * Build the `JOIN` clause for etags from the payload.
     *
     * @param payload {Object} The payload of query details.
     * @return {String} The built `JOIN` clause for etags.
     */
    buildJoinEtags: function buildJoinEtags (payload) {
      if (!this.orm) {
        this.orm = this.fetchOrm(payload.nameSpace, payload.type);
      }

      var oid = this.getTableOid(this.orm.lockTable || this.orm.table);
      var joinEtagsClause = '';

      /* If this is a count query, etags do not matter. */
      if (payload.query && payload.query.count) {
        return joinEtagsClause;
      }

      if (this.orm.lockable) {
        var etagsSql = 'LEFT JOIN (\n' +
                       '  SELECT\n' +
                       '    ver_etag as etag,\n' +
                       '    ver_record_id as id\n' +
                       '  FROM xt.ver\n' +
                       '  WHERE true\n' +
                       '    AND ver_table_oid = %1$L' +
                       ') AS etags USING (id)\n';

        joinEtagsClause = XT.format(etagsSql, [oid]);
      }

      return joinEtagsClause;
    },

    /**
     * Build the `JOIN` clause for `xm.share_users` for `crmaccountUsers` restriction.
     *
     * @param payload {Object} The payload of query details.
     * @return {String} The built `JOIN` clause for etags.
     */
    buildJoinShareUsers: function buildJoinShareUsers (payload) {
      var joinShareUsersClause = '';

      if (payload.query && payload.query.crmaccountUsers) {
        /* buildFrom() will create an alias for the base table as `t1`. Reference it here. */
        joinShareUsersClause = 'JOIN xm.share_users ON t1.uuid = share_users.uuid\n';
      }

      return joinShareUsersClause;
    },

    joinClauseStaticExtensions: this.joinClauseStaticExtensions || {},

    /**
     * Add a static, always present, extension handler function to `XT.Data.joinClauseStaticExtensions`
     * for a `nameSpace` and `type` ORM. The supplied `extFunc` will be called when building an
     * ORM's query and added as `JOIN`s to it.
     *
     * @param nameSpace {String} The ORM nameSpace.
     * @param type {String} The ORM type to extend.
     * @param extFunc {Function} The extension function to run.
     */
    addJoinClauseStaticExtension: function addJoinClauseStaticExtension (nameSpace, type, extFunc) {
      if (!XT.Data.joinClauseStaticExtensions[nameSpace]) {
        XT.Data.joinClauseStaticExtensions[nameSpace] = {};
      }

      if (!XT.Data.joinClauseStaticExtensions[nameSpace][type]) {
        XT.Data.joinClauseStaticExtensions[nameSpace][type] = [];
      }

      XT.Data.joinClauseStaticExtensions[nameSpace][type].push(extFunc);
    },

    /**
     * Add a dynamic, runtime only, extension function to `this.joinClauseDynamicExtensions` for a
     * `nameSpace` and `type` ORM. Note, `joinClauseDynamicExtensions` does not exist on `XT.Data`
     * It is only present on a child object that inherits from `XT.Data`. See `XM.ItemSitePrivate.fetch`
     * for a use of this function. The supplied `extFunc` will be called when building an ORM's
     * query and added as `JOIN` clauses to it.
     *
     * @param nameSpace {String} The ORM nameSpace.
     * @param type {String} The ORM type to extend.
     * @param extFunc {Function} The extension function to run.
     */
    addJoinClauseDynamicExtension: function addJoinClauseDynamicExtension (nameSpace, type, extFunc) {
      if (!this.joinClauseDynamicExtensions) {
        this.joinClauseDynamicExtensions = {};
      }

      if (!this.joinClauseDynamicExtensions[nameSpace]) {
        this.joinClauseDynamicExtensions[nameSpace] = {};
      }

      if (!this.joinClauseDynamicExtensions[nameSpace][type]) {
        this.joinClauseDynamicExtensions[nameSpace][type] = [];
      }

      this.joinClauseDynamicExtensions[nameSpace][type].push(extFunc);
    },

    /**
     * Get `JOIN` clause extensions and add them.
     *
     * @param payload {Object} The payload of query details.
     */
    buildJoinExtensions: function buildJoinExtensions (payload) {
      var self = this;
      var joinsClauseExtensions = '';
      var joinExtensions = [];

      if (this.joinClauseStaticExtensions[payload.nameSpace] &&
          this.joinClauseStaticExtensions[payload.nameSpace][payload.type]) {

        joinExtensions = joinExtensions.concat(this.joinClauseStaticExtensions[payload.nameSpace][payload.type]);
      }

      if (this.joinClauseDynamicExtensions &&
          this.joinClauseDynamicExtensions[payload.nameSpace] &&
          this.joinClauseDynamicExtensions[payload.nameSpace][payload.type]) {

        joinExtensions = joinExtensions.concat(this.joinClauseDynamicExtensions[payload.nameSpace][payload.type]);
      }

      joinExtensions.forEach(function (extFunc) {
        joinsClauseExtensions += '-- Added by buildJoinExtensions\n';
        joinsClauseExtensions += extFunc.call(self, payload);
      });

      return joinsClauseExtensions;
    },

    /**
     * Build the `JOIN`s from the payload or extensions.
     *
     * @param payload {Object} The payload of query details.
     * @return {String} The built `JOIN`s clause.
     */
    buildJoins: function buildJoins (payload) {
      if (!this.orm) {
        this.orm = this.fetchOrm(payload.nameSpace, payload.type);
      }
      if (!this.whereLiteralValues) {
        this.whereLiteralValues = [];
      }

      var joinsClause = '';

      joinsClause += this.buildJoinEtags(payload);
      joinsClause += this.buildJoinShareUsers(payload);
      joinsClause += this.buildJoinExtensions(payload);

      return joinsClause;
    },

    /**
     * Map the `WHERE` parameter `operator` to the corresponding SQL operator.
     *
     * @param operator {String} The operator of the `WHERE` parameter.
     * @return {String} The mapped `WHERE` parameter operator.
     */
    mapOperator: function mapOperator (operator) {
      switch (operator) {
        case '':
        case undefined: /* Default if not provided is `=`. */
          operator = ' = ';
          break;
        case '=':
        case '>':
        case '<':
        case '>=':
        case '<=':
        case '!=':
          operator = ' ' + operator + ' ';
          break;
        case 'BEGINS_WITH':
          operator = ' ~^ ';
          break;
        case 'ENDS_WITH':
          operator = ' ~? ';
          break;
        case 'MATCHES':
          operator = ' ~* ';
          break;
        case 'ANY':
          operator = ' <@ ';
          break;
        case 'NOT ANY':
          operator = ' !<@ ';
          break;
        default:
          plv8.elog(ERROR, 'Invalid operator: ' + operator);
      }

      return operator;
    },

    whereClauseStaticExtensions: this.whereClauseStaticExtensions || {},

    /**
     * Add a static, always present, extension handler function to `XT.Data.whereClauseStaticExtensions`
     * for a `nameSpace` and `type` ORM. The supplied `extFunc` will be called when building an
     * ORM's query and added as `WHERE` clauses to it.
     *
     * @param nameSpace {String} The ORM nameSpace.
     * @param type {String} The ORM type to extend.
     * @param extFunc {Function} The extension function to run.
     */
    addWhereClauseStaticExtension: function addWhereClauseStaticExtension (nameSpace, type, extFunc) {
      if (!XT.Data.whereClauseStaticExtensions[nameSpace]) {
        XT.Data.whereClauseStaticExtensions[nameSpace] = {};
      }

      if (!XT.Data.whereClauseStaticExtensions[nameSpace][type]) {
        XT.Data.whereClauseStaticExtensions[nameSpace][type] = [];
      }

      XT.Data.whereClauseStaticExtensions[nameSpace][type].push(extFunc);
    },

    /**
     * Add a dynamic, runtime only, extension function to `this.whereClauseDynamicExtensions` for a
     * `nameSpace` and `type` ORM. Note, `whereClauseDynamicExtensions` does not exist on `XT.Data`
     * It is only present on a child object that inherits from `XT.Data`. See `XM.ItemSitePrivate.fetch`
     * for a use of this function. The supplied `extFunc` will be called when building an ORM's
     * query and added as `WHERE` clauses to it.
     *
     * @param nameSpace {String} The ORM nameSpace.
     * @param type {String} The ORM type to extend.
     * @param extFunc {Function} The extension function to run.
     */
    addWhereClauseDynamicExtension: function addWhereClauseDynamicExtension (nameSpace, type, extFunc) {
      if (!this.whereClauseDynamicExtensions) {
        this.whereClauseDynamicExtensions = {};
      }

      if (!this.whereClauseDynamicExtensions[nameSpace]) {
        this.whereClauseDynamicExtensions[nameSpace] = {};
      }

      if (!this.whereClauseDynamicExtensions[nameSpace][type]) {
        this.whereClauseDynamicExtensions[nameSpace][type] = [];
      }

      this.whereClauseDynamicExtensions[nameSpace][type].push(extFunc);
    },

    /**
     * Get `WHERE` clause extensions and run them.
     *
     * @param payload {Object} The payload of query details.
     */
    buildWhereClauseExtensions: function buildWhereClauseExtensions (payload) {
      var self = this;
      var whereBody = '';
      var whereExtensions = [];

      if (this.whereClauseStaticExtensions[payload.nameSpace] &&
          this.whereClauseStaticExtensions[payload.nameSpace][payload.type]) {

        whereExtensions = whereExtensions.concat(this.whereClauseStaticExtensions[payload.nameSpace][payload.type]);
      }

      if (this.whereClauseDynamicExtensions &&
          this.whereClauseDynamicExtensions[payload.nameSpace] &&
          this.whereClauseDynamicExtensions[payload.nameSpace][payload.type]) {

        whereExtensions = whereExtensions.concat(this.whereClauseDynamicExtensions[payload.nameSpace][payload.type]);
      }

      whereExtensions.forEach(function (extFunc) {
        whereBody += '-- Added by buildWhereClauseExtensions\n';
        whereBody += extFunc.call(self, payload);
      });


      return whereBody;
    },

    /**
     * @typedef WhereClauseObject
     * @type Object
     * @property whereClause {String} The single `WHERE` clause with placeholders.
     * @property whereLiteralValues {Array} The `WHERE` clause literal values.
     */

    /**
     * Build a single `WHERE` clause from the payload or extensions. e.g.
     *
     *   AND (false
     *     OR number ~^ $1
     *     OR barcode ~^ $1
     *   )
     *
     * This is a helper function for `buildWhere()` below, but can also be called from a
     * `addWhereClauseDynamicExtension()`'s callback if additional manipulation is needed.
     * See `XM.ItemSitePrivate.fetch` for any example of that.
     *
     * @param payload {Object} The payload of query details.
     * @param parameter {Object} The parameter to build the `WHERE` clause part for.
     * @param literalIndex {Number} The index of the whereLiteralValues array to build with.
     * @return {WhereClauseObject} The built single `WHERE` clause object.
     */
    buildWhereClause: function buildWhereClause (payload, parameter, literalIndex) {
      if (!this.orm) {
        this.orm = this.fetchOrm(payload.nameSpace, payload.type);
      }

      var whereLiterals = [];
      var whereLiteralValues = [];
      var whereClause = '';

      /**
       * Add a `WHERE` clause literal value to the `whereLiterals` and `whereLiteralValues` arrays.
       *
       * @param value {String|Number|Date} The parameter value for this part of the `WHERE` clause.
       * @return {Number} The index of the whereLiteralValues just added.
       */
      function _addLiteral (value) {
        whereLiteralValues.push(value);
        whereLiterals[literalIndex] = '$' + (literalIndex);
      }

      /**
       * Create a cast string e.g. '::integer[]' for query params that need one.
       *
       * The old XT.Data.buildClause() would generate: `t1.product_id <@ ARRAY[$1,$2,$3,$4]::integer[]`
       * mimic that for the `ANY` and `NOT ANY` operators like: `AND product_id <@ $1::integer[]`
       */
      function _paramCast (paramOrmProp, operator) {
        var cast = '';

        if ((operator === 'ANY' || operator === 'NOT ANY') && paramOrmProp.attr) {
          switch (paramOrmProp.attr.type) {
            case 'Date':
              cast = '::date[]';
              break;
            case 'Number':
              cast = '::integer[]';
              break;
            case 'String':
              cast = '::text[]';
              break;
            default:
          }
        }

        return cast;
      }

      /**
       * Build array clause. e.g. `["account.name","name","phone"]`:
       *
       *   "query":{
       *     "parameters":[
       *       {
       *         "attribute": [
       *           "name",
       *           "account.name", // This is a path and must be handled too.
       *           "phone"
       *         ],
       *         "operator": "MATCHES",
       *         "value": "ttoys"
       *       }
       *     ]
       *   },
       *
       * @param parameter {Object} The parameter to build the `WHERE` clause part for.
       * @param literalIndex {Number} The index of the whereLiteralValues array to build with.
       * @return {String} The part of the `WHERE` clause for this parameter.
       */
      function _buildArray (parameter, literalIndex) {
        var clause = [];
        var wrappedOrClause = '';

        for (var i = 0; i < parameter.attribute.length; i++) {
          var subParam = {
            attribute: parameter.attribute[i],
            value: parameter.value
          };

          if (parameter.operator) {
            subParam.operator = parameter.operator;
          }

          if (parameter.includeNull) {
            subParam.includeNull = parameter.includeNull;
          }

          if (subParam.attribute.indexOf('.') > -1) {
            /* Handle path case. e.g. `address.state` */
            clause = clause.concat(_buildPath.call(this, subParam, literalIndex));
          } else {
            /* Handle normal case. */
            clause = clause.concat(_buildNormal.call(this, subParam, literalIndex));
          }
        }

        /* Wrap the returned clauses in an `( ... OR ... )`.
         * Build clause like:
         *
         *  (
         *    (account).number ~* $1
         *    OR (account).name ~* $1
         *    OR name ~* $1
         *    OR ("billingContact").address.city ~* $1
         *  )
         */
        if (clause.length > 0) {
          wrappedOrClause = '(\n' +
                            '    ' + clause.join('    OR ') +
                            '  )\n';
        }

        return wrappedOrClause;
      }

      /**
       * Build normal clause. e.g. `state`:
       *
       *   "query":{
       *     "parameters":[
       *       {
       *         "attribute": "state",
       *         "operator": "MATCHES",
       *         "value": "VA"
       *       }
       *     ]
       *   },
       *
       * @param parameter {Object} The parameter to build the `WHERE` clause part for.
       * @param literalIndex {Number} The index of the whereLiteralValues array to build with.
       * @return {String} The part of the `WHERE` clause for this parameter.
       */
      function _buildNormal (parameter, literalIndex) {
        var operator = this.mapOperator(parameter.operator);
        var paramOrmProp = XT.Orm.getPathProperty(this.orm, parameter.attribute);
        var clause = '';

        if (!paramOrmProp) {
          plv8.elog(ERROR, 'Invalid query:', parameter.attribute, operator, parameter.value);
        }

        if ((paramOrmProp.attr && paramOrmProp.attr.type === 'Array') ||
            (paramOrmProp.toMany && !paramOrmProp.toMany.isNested)) {

          /* Build clause like: `$4 = ANY ("contactRelations")` */
          return XT.format(whereLiterals[literalIndex] + operator + 'ANY (%1$I)', [parameter.attribute]) + ' \n';
        } else if (paramOrmProp.toMany && paramOrmProp.toMany.isNested) {
          /*
           * Support the short cut wherein the client asks for a filter on a toMany.isNested with a
           * string, but no path. Technically they should use "theAttr.theAttrNaturalKey",
           * but if they don't, add the naturalKey to the attribute as if they did.
           */
          var paramOrm = XT.Orm.getPathOrm(this.orm, parameter.attribute);
          var naturalKey = XT.Orm.naturalKey(paramOrm);
          parameter.attribute += '.' + naturalKey;

          return _buildPath.call(this, parameter, literalIndex);
        } else if (paramOrmProp.toOne && paramOrmProp.toOne.isNested) {
          /*
           * Support the short cut wherein the client asks for a filter on a toOne with a
           * string, but no path. Technically they should use "theAttr.theAttrNaturalKey",
           * but if they don't, add the naturalKey to the attribute as if they did.
           */
          var paramOrm = XT.Orm.getPathOrm(this.orm, parameter.attribute);
          var naturalKey = XT.Orm.naturalKey(paramOrm);
          parameter.attribute += '.' + naturalKey;

          /* Build cluase like: `AND ("billingContact").number = $6` */
          return _buildPath.call(this, parameter, literalIndex);
        } else {
          if (parameter.includeNull) {
            /* Build clause like: `(name = $5 OR name IS NULL)` */
            return XT.format('(%1$I' + operator + whereLiterals[literalIndex] + ' OR %1$I IS NULL)', [parameter.attribute]) +
                   _paramCast(paramOrmProp, parameter.operator) +
                   ' \n';
          } else {
            /* Build clause like: `name = $5` */
            return XT.format('%1$I' + operator + whereLiterals[literalIndex], [parameter.attribute]) +
                   _paramCast(paramOrmProp, parameter.operator) +
                   ' \n';
          }
        }
      }

      /**
       * Build path clause. e.g. `address.state`:
       *
       *   "query":{
       *     "parameters":[
       *       {
       *         "attribute": "address.state",
       *         "operator": "MATCHES",
       *         "value": "VA"
       *       }
       *     ]
       *   },
       *
       * @param parameter {Object} The parameter to build the `WHERE` clause part for.
       * @param literalIndex {Number} The index of the whereLiteralValues array to build with.
       * @return {String} The part of the `WHERE` clause for this parameter.
       */
      function _buildPath (parameter, literalIndex) {
        var operator = this.mapOperator(parameter.operator);
        var paramOrmProp = XT.Orm.getPathProperty(this.orm, parameter.attribute);
        var whereIdentifiers = [];
        var whereIdentifierValues = [];
        var childPath = parameter.attribute.split('.');
        var parentPath = childPath.slice(0, (childPath.length - 1));
        var parentOrmProp = XT.Orm.getPathProperty(this.orm, parentPath.join('.'));
        var clause = '';

        if (!paramOrmProp) {
          plv8.elog(ERROR, 'Invalid query:', parameter.attribute, operator, parameter.value);
        }

        /**
         * Build up the Identifier string and replacement values for a path.
         * e.g. `(%1$I).%2$I.%3$I` for use in a `WHERE` clause like:
         *   `AND ("billingContact").address.city = $1`.
         *
         * @param path {Array} The `WHERE` clause table.column path.
         */
        function _buildPathIdentifiers (path) {
          for (var i = 0; i < path.length; i++) {
            whereIdentifierValues.push(path[i]);
            if (i === 0) {
              whereIdentifiers[i] = '(%' + (whereIdentifierValues.length) + '$I)';
            } else {
              whereIdentifiers[i] = '.%' + (whereIdentifierValues.length) + '$I';
            }
          }
        }

        /**
         * Build an `id IN (sub select array)` clause like:
         *
         * id IN (
         *     SELECT id FROM (
         *       SELECT
         *         id,
         *         unnest(shiptos) AS list_item
         *       FROM xm.customer
         *     ) AS unnested -- Need to unnest the array so you can address individual parts of the composite type in the where clause.
         *     WHERE true
         *       -- Note, the () are required around (table.column), even if table is omitted; i.e., "(list_item).text"
         *       AND (unnested.list_item).uuid = 'eb431661-be71-401b-b49e-d0cb6907700d'
         *   )
         *
         * @See: http://www.postgresql.org/message-id/01da01cda028$091353d0$1b39fb70$@yahoo.com
         *
         * @param column {String} The column name at the end of the path to filter on.
         * @return {String} The in array clause.
         */
        function _buildIdInToManyArrayClause (column) {
          var idInToManyArrayClause = 'id IN (\n' +
                                      '    SELECT id FROM (\n' +
                                      '      SELECT\n' +
                                      '        id,\n' +
                                      '        unnest(' + whereIdentifiers.join('') + ') AS list_item\n' +
                                      '      ' + this.buildFrom(payload) +
                                      '    ) AS unnested\n' +
                                      '    WHERE true\n' +
                                      '      AND (unnested.list_item).' + column + operator + whereLiterals[literalIndex] + '\n' +
                                      '  )';

          return XT.format(idInToManyArrayClause, whereIdentifierValues) + ' \n';
        }

        if (parentOrmProp.toMany && parentOrmProp.toMany.isNested) {
          _buildPathIdentifiers.call(this, parentPath);

          return _buildIdInToManyArrayClause.call(this, paramOrmProp.name);
        } else if (parentOrmProp.toOne && !parentOrmProp.toOne.isNested) {
          _buildPathIdentifiers.call(this, parentPath);

          if (parameter.includeNull) {
            /* Build clause like: `(("billingContact").address.city = $5 OR ("billingContact").address.city IS NULL)` */
            return XT.format('(' + whereIdentifiers.join('') + operator + whereLiterals[literalIndex] +
                               ' OR ' + whereIdentifiers.join('') + ' IS NULL)',
                             whereIdentifierValues) + ' \n';
          } else {
            /* Build clause like: `("billingContact").address.city = $1` */
            return whereIdentifiers.length ?
              XT.format(whereIdentifiers.join(''), whereIdentifierValues) + operator + whereLiterals[literalIndex] + ' \n'
              : '';
          }
        } else if (paramOrmProp.toMany && paramOrmProp.toMany.isNested) {
          /*
           * Support the short cut wherein the client asks for a filter on a toMany.isNested with a
           * string, but no path. Technically they should use "theAttr.theAttrNaturalKey",
           * but if they don't, add the naturalKey to the attribute as if they did.
           */
          var paramOrm = XT.Orm.getPathOrm(orm, parameter.attribute);
          var naturalKey = XT.Orm.naturalKey(paramOrm);
          _buildPathIdentifiers.call(this, childPath);

          return _buildIdInToManyArrayClause.call(this, naturalKey);
        } else if ((paramOrmProp.attr && paramOrmProp.attr.type === 'Array') ||
                   (paramOrmProp.toMany && !paramOrmProp.toMany.isNested)) {

          _buildPathIdentifiers.call(this, childPath);

          /* Build clause like: `'admin' = ANY ((address)."crmaccountUsers")` */
          return XT.format(whereLiterals[literalIndex] + operator + 'ANY (' + whereIdentifiers.join('') + ')', whereIdentifierValues) + ' \n';
        } else if (paramOrmProp.toOne && paramOrmProp.toOne.isNested) {
          /*
           * Support the short cut wherein the client asks for a filter on a toOne with a
           * string, but no path. Technically they should use "theAttr.theAttrNaturalKey",
           * but if they don't, add the naturalKey to the attribute as if they did.
           */
          var paramOrm = XT.Orm.getPathOrm(orm, parameter.attribute);
          var naturalKey = XT.Orm.naturalKey(paramOrm);
          parameter.attribute += '.' + naturalKey;

          /* Build cluase like: `("billingContact").address.number = $6` where `number` is the added naturalKey. */
          return _buildPath.call(this, parameter, literalIndex);
        } else {
          _buildPathIdentifiers.call(this, childPath);

          if (parameter.includeNull) {
            /* Build clause like: `(("billingContact").address.city = $5 OR ("billingContact").address.city IS NULL)` */
            return XT.format('(' + whereIdentifiers.join('') + operator + whereLiterals[literalIndex] +
                               ' OR ' + whereIdentifiers.join('') + ' IS NULL)',
                             whereIdentifierValues) + ' \n';
          } else {
            /* Build clause like: `("billingContact").address.city = $1` */
            return whereIdentifiers.length ?
              XT.format(whereIdentifiers.join(''), whereIdentifierValues) + operator + whereLiterals[literalIndex] + ' \n'
              : '';
          }
        }
      }

      _addLiteral.call(this, parameter.value);

      if (parameter.attribute.indexOf('.') > -1) {
        /* Handle path case. e.g. `address.state` */
        whereClause += _buildPath.call(this, parameter, literalIndex);
      } else if (Array.isArray(parameter.attribute)) {
        /* Handle array case. e.g. `["account.name","name","phone"]` */
        whereClause += _buildArray.call(this, parameter, literalIndex);
      } else {
        /* Handle normal case. e.g. `state` */
        whereClause += _buildNormal.call(this, parameter, literalIndex);
      }

      var whereClauseObject = {
        whereClause: whereClause,
        whereLiteralValues: whereLiteralValues
      };

      return whereClauseObject;
    },

    /**
     * Build the `WHERE` clause from the payload or extensions.
     *
     * @param payload {Object} The payload of query details.
     * @return {String} The built `WHERE` clause.
     */
    buildWhere: function buildWhere (payload) {
      var parameters = (payload.query) ? payload.query.parameters : undefined;
      var whereBody = '';

      if (!this.whereLiteralValues) {
        this.whereLiteralValues = [];
      }

      /**
       * Handle characteristics parameters e.g.:
       *  {
       *    "isCharacteristic": true,
       *    "attribute": "CUST-VOLUME",
       *    "operator": "=",
       *    "value": "> 50,000"
       *  }
       *
       * Add two new parameters that will create a `AND id IN (... char sub query here ...)` clause.
       *
       * @param param {Object} The isCharacteristic parameter.
       */
      function _mapCharacteristic (param) {
        var charParamCharacteristic = {
          attribute: "characteristics.characteristic",
          value: param.attribute
        };
        var charParamValue = {
          attribute: "characteristics.value",
          value: param.value
        };

        if (param.operator) {
          charParamCharacteristic.operator = param.operator;
          charParamValue.operator = param.operator;
        }

        parameters.push(charParamCharacteristic);
        parameters.push(charParamValue);
      }

      whereBody = 'WHERE true\n';

      if (payload.query && payload.query.crmaccountUsers) {
        whereBody += XT.format('  AND share_users.username = %1$L', [XT.username]) + '\n';
      }

      if (parameters) {
        for (var i = 0; i < parameters.length; i++) {
          if (parameters[i].isCharacteristic) {
            // This will increase the `parameters.length` by two when the characteristic
            // parameters are added by `_mapCharacteristic()`. The for loop eveluates `parameters.length`
            // on each iteration of the loop, so it will know the length has increased each time.
            _mapCharacteristic.call(this, parameters[i]);
            continue;
          }

          var literalIndex = this.whereLiteralValues.length + 1;
          var whereClause = this.buildWhereClause(payload, parameters[i], literalIndex);
          whereBody += '  AND ' + whereClause.whereClause;
          Array.prototype.push.apply(this.whereLiteralValues, whereClause.whereLiteralValues);
        }
      }

      whereBody += this.buildWhereClauseExtensions(payload);

      return whereBody;
    },

    /**
     * Build the `ORDER BY` clause from the payload.
     *
     * @param payload {Object} The payload of query details.
     * @return {String} The built `ORDER BY` clause.
     */
    buildOrderBy: function buildOrderBy (payload) {
      if (!this.orm) {
        this.orm = this.fetchOrm(payload.nameSpace, payload.type);
      }

      var orderBy = (payload.query && payload.query.orderBy) ? payload.query.orderBy : [];
      var orderByIdentifiers = [];
      var orderByIdentifierValues = [];
      var orderByClause = '';

      /* If this is a count query, `ORDER BY` doesn't matter. */
      if (payload.query && payload.query.count) {
        return orderByClause;
      }

      for (var i = 0; i < orderBy.length; i++) {
        if (orderBy[i].attribute.indexOf('.') > -1) { /* Handle path case. e.g. `address.state` */
          path = orderBy[i].attribute.split('.');
          for (var n = 0; n < path.length; n++) {
            orderByIdentifierValues.push(path[n]);
            if (n === 0) {
              orderByIdentifiers[i] = '(%' + (orderByIdentifierValues.length) + '$I)';
            } else {
              orderByIdentifiers[i] += '.%' + (orderByIdentifierValues.length) + '$I';
            }
          }
        } else { /* Normal case. */
          orderByIdentifierValues.push(orderBy[i].attribute);
          orderByIdentifiers[i] = '%' + (orderByIdentifierValues.length) + '$I';
        }

        if (orderBy[i].descending) {
          orderByIdentifiers[i] += ' DESC';
        }
      }
      orderByClause = orderByIdentifiers.length ?
        XT.format('ORDER BY\n  ' + orderByIdentifiers.join(', \n  '), orderByIdentifierValues) + ' \n'
        : '';

      /* Because we query views of views, you can get inconsistent results */
      /* when doing limit and offest queries without an order by. Add a default. */
      if (payload.query &&
          payload.query.rowLimit &&
          payload.query.rowOffset &&
          (!orderBy || !orderBy.length) &&
          !orderByClause.length) {

        var pkeyColumn = XT.Orm.primaryKey(this.orm, true);
        orderByClause = XT.format('ORDER BY\n  %1$I ', [pkeyColumn]);
      }

      return orderByClause;
    },

    /**
     * Build the `LIMIT` clause from the payload.
     * Note, the `restQueryFormat()` function sets a default `rowLimit` to 100 if none is supplied.
     * This is intended to protect the API from misuse/abuse. Although a high `rowLimit` can be set
     * by API clients. e.g. `rowLimit: 1000000`
     *
     * Internally, no `rowLimit` will be defaulted unless specifically set on the payload.
     *
     * @param payload {Object} The payload of query details.
     * @return {String} The built `LIMIT` clause.
     */
    buildLimit: function buildLimit (payload) {
      if (!this.orm) {
        this.orm = this.fetchOrm(payload.nameSpace, payload.type);
      }

      var limitClause;

      if (payload.query && !payload.query.count) {
        limitClause = payload.query.rowLimit ? XT.format('LIMIT %1$L', [payload.query.rowLimit]) + ' \n' : '';
      } else {
        limitClause = '';
      }
      return limitClause;
    },

    /**
     * Build the `OFFSET` clause from the payload.
     *
     * @param payload {Object} The payload of query details.
     * @return {String} The built `OFFSET` clause.
     */
    buildOffset: function buildOffset (payload) {
      if (!this.orm) {
        this.orm = this.fetchOrm(payload.nameSpace, payload.type);
      }

      var offsetClause;

      if (payload.query) {
        offsetClause = payload.query.rowOffset ? XT.format('OFFSET %1$L', [payload.query.rowOffset]) + ' \n' : '';
      } else {
        offsetClause = '';
      }

      return offsetClause;
    },

    /**
     * Fetch an array of records from the database.
     *
     * @param payload {Object} The payload of query details.
     * @param {String} [payload.nameSpace] The ORM Namespace. Required.
     * @param {String} [payload.type] The ORM Type. Required.
     * @param {Array}  [payload.parameters] The query parameters - optional
     * @param {Array}  [payload.orderBy] The query `ORDER BY` - optional
     * @param {Number} [payload.rowLimit] The query `LIMIT` - optional
     * @param {Number} [payload.rowOffset] The query `OFFSET` - optional
     * @return {Array} The query result.
     */
    fetch: function fetch (payload) {
      if (!this.orm) {
        this.orm = this.fetchOrm(payload.nameSpace, payload.type);
      }
      if (!this.checkPrivileges(payload.nameSpace, payload.type)) {
        return [];
      }

      var encryptionKey = payload.encryptionKey;
      var nkey = XT.Orm.naturalKey(this.orm);
      var pkey = XT.Orm.primaryKey(this.orm);
      var query = this.buildQuery(payload);
      var result = {
        nameSpace: payload.nameSpace,
        type: payload.type
      };

      if (DEBUG) {
        XT.debug('fetch sql = ' + query.sql);
        XT.debug('fetch values = ', query.values);
      }
      result.data = plv8.execute(query.sql, query.values);

      if (!result.data.length) {
        return [];
      };

      /* If this is a count query, we do not need to decrypt, sanitize and add etags. */
      if (payload.query && payload.query.count) {
        return result;
      }

      if (this.orm.lockable) {
        result.etags = {};
      }

      // Loop over the result data, decrypt if needed, sanitize and add etags if needed.
      for (var i = 0; i < result.data.length; i++) {
        result.data[i] = this.decrypt(payload.nameSpace, payload.type, result.data[i], encryptionKey);

        if (this.orm.lockable) {
          /* Add etags to result or create new one. */
          if (result.data[i].etag) {
            result.etags[result.data[i][nkey]] = result.data[i].etag;
            delete result.data[i].etag;
          } else {
            result.etags[result.data[i][nkey]] = this.getVersion(this.orm, result.data[i][pkey]);
          }
        }

        /* The sanitizeRow() method will remove the `pkey`, `id`. This must be after etags are handled. */
        this.sanitizeRow(payload.nameSpace, payload.type, result.data[i], payload);
      }

      return result;
    },

    /**
    Fetch a metric value.

    @param {String} Metric name
    @param {String} Return type 'text', 'boolean' or 'number' (default 'text')
    */
    fetchMetric: function (name, type) {
      plv8.elog(ERROR, "name: " + name + " type: " + type);
      var fn = 'fetchmetrictext';
      if (type === 'boolean') {
        fn = 'fetchmetricbool';
      } else if (type === 'number') {
        fn = 'fetchmetricvalue';
      }
      return plv8.execute("select " + fn + "($1) as resp", [name])[0].resp;
    },

    /**
     * Retreives a record from the database. If the user does not have appropriate privileges an
     * error will be thrown unless the `silentError` option is passed.
     *
     * If `context` is passed as an option then a record will only be returned if it exists in the context (parent)
     * record which itself must be accessible by the effective user.
     *
     * @param {Object} options
     * @param {String} [options.nameSpace] Namespace. Required.
     * @param {String} [options.type] Type. Required.
     * @param {Number} [options.id] Record id. Required.
     * @param {Boolean} [options.superUser=false] If true ignore privilege checking.
     * @param {String} [options.encryptionKey] Encryption key
     * @param {Boolean} [options.silentError=false] Silence errors
     * @param {Object} [options.context] Context
     * @param {String} [options.context.nameSpace] Context namespace.
     * @param {String} [options.context.type] The type of context object.
     * @param {String} [options.context.value] The value of the context's primary key.
     * @param {String} [options.context.relation] The name of the attribute on the type to which this record is related.
     * @returns Object
     */
    retrieveRecord: function (options) {
      options = options ? options : {};
      options.obtainLock = false;

      var id = options.id,
        nameSpace = options.nameSpace,
        type = options.type,
        map = this.fetchOrm(nameSpace, type),
        context = options.context,
        encryptionKey = options.encryptionKey,
        join = "",
        lockTable = map.lockTable || map.table,
        nkey = XT.Orm.naturalKey(map),
        params = {},
        pkey = XT.Orm.primaryKey(map),
        ret = {
          nameSpace: nameSpace,
          type: type,
          id: id
        },
        sql;

      if (!pkey) {
        throw new Error('No key found for {nameSpace}.{type}'
                        .replace("{nameSpace}", nameSpace)
                        .replace("{type}", type));
      }

      /* If this object uses a natural key, go get the primary key id. */
      if (nkey && !options.queryOnPrimaryKey) {
        id = this.getId(map, id);
        if (!id) {
          return false;
        }
      }

      /* Context means search for this record inside another. */
      if (context) {
        context.nameSpace = context.nameSpace || context.recordType.beforeDot();
        context.type = context.type || context.recordType.afterDot()
        context.map = this.fetchOrm(context.nameSpace, context.type);
        context.prop = XT.Orm.getProperty(context.map, context.relation);
        context.pertinentExtension = XT.Orm.getProperty(context.map, context.relation, true);
        context.underlyingTable = context.pertinentExtension.table,
        context.underlyingNameSpace = this.getNamespaceFromNamespacedTable(context.underlyingTable);
        context.underlyingType = this.getTableFromNamespacedTable(context.underlyingTable);
        context.fkey = context.prop.toMany.inverse;
        context.fkeyColumn = context.prop.toMany.column;
        context.pkey = XT.Orm.naturalKey(context.map) || XT.Orm.primaryKey(context.map);
        params.attribute = context.pkey;
        params.value = context.value;

        join = 'join %1$I.%2$I on (%1$I.%2$I.%3$I = %4$I.%5$I)';
        join = XT.format(join, [
            context.underlyingNameSpace,
            context.underlyingType,
            context.fkeyColumn,
            type.decamelize(),
            context.fkey
          ]);
      }

      /* Validate - don't bother running the query if the user has no privileges. */
      if(!options.superUser && !context && !this.checkPrivileges(nameSpace, type)) {
        if (options.silentError) {
          return false;
        } else {
          throw new handleError("Unauthorized", 401);
        }
      }

      ret.etag = this.getVersion(map, id);

      /* Obtain lock if required. */
      if (map.lockable) {
        ret.lock = this.tryLock(lockTable, id, options);
      }

      /* Data sql. */
      sql = 'select %1$I.* from %2$I.%1$I {join} where %1$I.%3$I = $1;';
      sql = sql.replace(/{join}/, join);
      sql = XT.format(sql, [type.decamelize(), nameSpace.decamelize(), pkey]);

      /* Query the map. */
      if (DEBUG) {
        XT.debug('retrieveRecord sql = ', sql);
        XT.debug('retrieveRecord values = ', [id]);
      }
      ret.data = plv8.execute(sql, [id])[0] || {};

      if (!context) {
        /* Check privileges again, this time against record specific criteria where applicable. */
        if(!options.superUser && !this.checkPrivileges(nameSpace, type, ret.data)) {
          if (options.silentError) {
            return false;
          } else {
            throw new handleError("Unauthorized", 401);
          }
        }
        /* Decrypt result where applicable. */
        ret.data = this.decrypt(nameSpace, type, ret.data, encryptionKey);
      }

      this.sanitizeRow(nameSpace, type, ret.data, options);

      /* Return the results. */
      return ret || {};
    },

    /**
     *  Remove unprivileged attributes, primary and foreign keys from the data.
     *  Only removes the primary key if a natural key has been specified in the ORM.
     *  Also format for printing using XT.format functions if printFormat=true'
     *
     * @param nameSpace {String} The ORM Namespace.
     * @param type {String} The ORM Type.
     * @param row {Object} The data row to sanitize.
     * @param payload {Object} They query payload.
     * @param {Boolean} [payload.includeKeys=false] Do not remove primary and foreign keys.
     * @param {Boolean} [payload.superUser=false] Do not remove unprivileged attributes.
     * @param {Boolean} [payload.printFormat=true] Format for printing.
     */
    sanitizeRow: function sanitizeRow (nameSpace, type, row, payload) {
      payload = payload || {};
      if (payload.includeKeys && payload.superUser) {
        return;
      }

      var orm = this.fetchOrm(nameSpace, type);
      var pkey = XT.Orm.primaryKey(orm);
      var nkey = XT.Orm.naturalKey(orm);
      var props = orm.properties;
      var attrPriv = orm.privileges && orm.privileges.attribute ?
          orm.privileges.attribute : false;
      var inclKeys = payload.includeKeys;
      var superUser = payload.superUser;
      var printFormat = payload.printFormat;
      var prop;
      var rowAttr;
      var filteredProps;
      var preOffsetDate;
      var offsetDate;
      var check = function (p) {
        return p.name === rowAttr;
      };


      /* Remove primary key if applicable */
      if (!inclKeys && nkey && nkey !== pkey) {
        delete row[pkey];
      }

      for (rowAttr in row) {
        if (!row.hasOwnProperty(rowAttr)) {
          continue;
        }
        filteredProps = orm.properties.filter(check);

        if (filteredProps.length === 0 && orm.extensions.length > 0) {
          /* Try to get the orm prop from an extension if it's not in the core*/
          orm.extensions.forEach(function (ext) {
            if (filteredProps.length === 0) {
              filteredProps = ext.properties.filter(check);
            }
          });
        }

        /* Remove attributes not found in the ORM */
        if (filteredProps.length === 0) {
          delete row[rowAttr];
        } else {
          prop = filteredProps[0];
        }

        /* Remove unprivileged attribute if applicable */
        if (!superUser && attrPriv && attrPriv[prop.name] &&
          (attrPriv[prop.name].view !== undefined) &&
          !this.checkPrivilege(attrPriv[prop.name].view)) {
          delete row[prop.name];
        }

        /*  Format for printing if printFormat and not an object. */
        if (printFormat && !prop.toOne && !prop.toMany) {
          switch(prop.attr.type) {
            case "Date":
            case "DueDate":
              preOffsetDate = row[rowAttr];
              offsetDate = preOffsetDate &&
                new Date(preOffsetDate.valueOf() + 60000 * preOffsetDate.getTimezoneOffset());
              row[rowAttr] = XT.formatDate(offsetDate).formatdate;
            break;
            case "Cost":
              row[rowAttr] = XT.formatCost(row[rowAttr]).formatcost.toString();
            break;
            case "Number":
              row[rowAttr] = XT.formatNumeric(row[rowAttr], "").formatnumeric.toString();
            break;
            case "Money":
              row[rowAttr] = XT.formatMoney(row[rowAttr]).formatmoney.toString();
            break;
            case "SalesPrice":
              row[rowAttr] = XT.formatSalesPrice(row[rowAttr]).formatsalesprice.toString();
            break;
            case "PurchasePrice":
              row[rowAttr] = XT.formatPurchPrice(row[rowAttr]).formatpurchprice.toString();
            break;
            case "ExtendedPrice":
              row[rowAttr] = XT.formatExtPrice(row[rowAttr]).formatextprice.toString();
            break;
            case "Quantity":
              row[rowAttr] = XT.formatQty(row[rowAttr]).formatqty.toString();
            break;
            case "QuantityPer":
              row[rowAttr] = XT.formatQtyPer(row[rowAttr]).formatqtyper.toString();
            break;
            case "UnitRatioScale":
              row[rowAttr] = XT.formatRatio(row[rowAttr]).formatratio.toString();
            break;
            case "Percent":
              row[rowAttr] = XT.formatPrcnt(row[rowAttr]).formatprcnt.toString();
            break;
            case "WeightScale":
              row[rowAttr] = XT.formatWeight(row[rowAttr]).formatweight.toString();
            break;
            default:
              row[rowAttr] = (row[rowAttr] || "").toString();
          }
        }

        /* Handle composite types */
        if (prop.toOne && prop.toOne.isNested && row[prop.name]) {
          this.sanitizeRow(nameSpace, prop.toOne.type, row[prop.name], payload);
        } else if (prop.toMany && prop.toMany.isNested && row[prop.name]) {
          for (var i = 0; i < row[prop.name].length; i++) {
            var val = row[prop.name][i];

            /* Remove foreign key if applicable */
            if (!inclKeys) {
              delete val[prop.toMany.inverse];
            }
            this.sanitizeRow(nameSpace, prop.toMany.type, val, payload);
          }
        }
      }
    },

    /**
     * Returns a array of key value pairs of metric settings that correspond with an array of passed keys.
     *
     * @param {Array} array of metric names
     * @returns {Array}
     */
    retrieveMetrics: function (keys) {
      var literals = [],
        prop,
        qry,
        ret = {},
        sql = 'select metric_name as setting, metric_value as value '
            + 'from metric '
            + 'where metric_name in ({literals})';

      for (var i = 0; i < keys.length; i++) {
        literals[i] = "%" + (i + 1) + "$L";
      }

      sql = sql.replace(/{literals}/, literals.join(','));
      sql = XT.format(sql, keys)

      if (DEBUG) {
        XT.debug('retrieveMetrics sql = ', sql);
      }
      qry = plv8.execute(sql);

      /* Recast where applicable. */
      for (var i = 0; i < qry.length; i++) {
        prop = qry[i].setting;
        if(qry[i].value === 't') { ret[prop] = true; }
        else if(qry[i].value === 'f') { ret[prop] = false }
        else if(!isNaN(qry[i].value)) { ret[prop] = qry[i].value - 0; }
        else { ret[prop] = qry[i].value; }
      }

      /* Make sure there is a result at all times */
      keys.forEach(function (key) {
        if (ret[key] === undefined) { ret[key] = null; }
      });

      return ret;
    },

    /**
     * Creates and returns a lock for a given table. Defaults to a time based lock of 30 seconds
     * unless aternate timeout option or process id (pid) is passed. If a pid is passed, the lock
     * is considered infinite as long as the pid is valid. If a previous lock key is passed and it is
     * valid, a new lock will be granted.
     *
     * @param {String | Number} Table name or oid
     * @param {Number} Record id
     * @param {Object} Options
     * @param {Number} [options.timeout=30]
     * @param {Number} [options.pid] Process id
     * @param {Number} [options.key] Key
     * @param {Boolean} [options.obtainLock=true] If false, only checks for existing lock
     */
    tryLock: function (table, id, options) {
      options = options ? options : {};

      var deleteSql = "delete from xt.lock where lock_id = $1;",
        timeout = options.timeout || 30,
        expires = new Date(),
        i,
        insertSqlExp = "insert into xt.lock (lock_table_oid, lock_record_id, lock_username, lock_expires) " +
                       "values ($1, $2, $3, $4) returning lock_id, lock_effective;",
        insertSqlPid = "insert into xt.lock (lock_table_oid, lock_record_id, lock_username, lock_pid) " +
                       "values ($1, $2, $3, $4) returning lock_id, lock_effective;",
        lock,
        lockExp,
        oid,
        pcheck,
        pgver = 0 + this.getPgVersion(2),
        pid = options.pid || null,
        pidcol = (pgver < 9.2) ? "procpid" : "pid",
        pidSql = "select usename, {pidcol} " +
                 "from pg_stat_activity " +
                 "where datname=current_database() " +
                 " and usename=$1 " +
                 " and {pidcol}=$2;",
        query,
        selectSql = "select * " +
                    "from xt.lock " +
                    "where lock_table_oid = $1 " +
                    " and lock_record_id = $2;",
        username = XT.username;

      pidSql = pidSql.replace(/{pidcol}/g, pidcol);

      /* If passed a table name, look up the oid. */
      oid = typeof table === "string" ? this.getTableOid(table) : table;

      if (DEBUG) XT.debug("Trying lock table", [oid, id]);

      /* See if there are existing lock(s) for this record. */
      if (DEBUG) {
        XT.debug('tryLock sql = ', selectSql);
        XT.debug('tryLock values = ', [oid, id]);
      }
      query = plv8.execute(selectSql, [oid, id]);

      /* Validate result */
      if (query.length > 0) {
        while (query.length) {
          lock = query.shift();

          /* See if we are confirming our own lock. */
          if (options.key && options.key === lock.lock_id) {
            /* Go on and we'll get a new lock. */

          /* Make sure if they are pid locks users is still connected. */
          } else if (lock.lock_pid) {
            if (DEBUG) {
              XT.debug('tryLock sql = ', pidSql);
              XT.debug('tryLock values = ', [lock.lock_username, lock.lock_pid]);
            }
            pcheck = plv8.execute(pidSql, [lock.lock_username, lock.lock_pid]);
            if (pcheck.length) { break; } /* valid lock */
          } else {
            lockExp = new Date(lock.lock_expires);
            if (DEBUG) { XT.debug("Lock found", [lockExp > expires, lockExp, expires]); }
            if (lockExp > expires) { break; } /* valid lock */
          }

          /* Delete invalid or expired lock. */
          if (DEBUG) {
            XT.debug('tryLock sql = ', deleteSql);
            XT.debug('tryLock values = ', [lock.lock_id]);
          }
          plv8.execute(deleteSql, [lock.lock_id]);
          lock = undefined;
        }

        if (lock) {
          if (DEBUG) XT.debug("Lock found", lock.lock_username);

          return {
            username: lock.lock_username,
            effective: lock.lock_effective
          }
        }
      }

      if (options.obtainLock === false) { return; }

      if (DEBUG) { XT.debug("Creating lock."); }
      if (DEBUG) { XT.debug('tryLock sql = ', insertSqlPid); }

      if (pid) {
        if (DEBUG) { XT.debug('tryLock values = ', [oid, id, username, pid]); }
        lock = plv8.execute(insertSqlPid, [oid, id, username, pid])[0];
      } else {
        expires = new Date(expires.setSeconds(expires.getSeconds() + timeout));
        if (DEBUG) { XT.debug('tryLock values = ', [oid, id, username, expires]); }
        lock = plv8.execute(insertSqlExp, [oid, id, username, expires])[0];
      }

      if (DEBUG) { XT.debug("Lock returned is", lock.lock_id); }

      return {
        username: username,
        effective: lock.lock_effective,
        key: lock.lock_id
      }
    },

    /**
     * Release a lock. Pass either options with a key, or table, id and username.
     *
     * @param {Object} Options: key or table and id
     */
    releaseLock: function (options) {
      var oid,
        sqlKey = 'delete from xt.lock where lock_id = $1;',
        sqlUsr = 'delete from xt.lock where lock_table_oid = $1 and lock_record_id = $2 and lock_username = $3;',
        username = XT.username;

      if (options.key) {
        if (DEBUG) {
          XT.debug('releaseLock sql = ', sqlKey);
          XT.debug('releaseLock values = ', [options.key]);
        }
        plv8.execute(sqlKey, [options.key]);
      } else {
        oid = typeof options.table === "string" ? this.getTableOid(options.table) : options.table;

        if (DEBUG) {
          XT.debug('releaseLock sql = ', sqlUsr);
          XT.debug('releaseLock values = ', [oid, options.id, username]);
        }
        plv8.execute(sqlUsr, [oid, options.id, username]);
      }

      return true;
    },

    /**
     * Renew a lock. Defaults to rewing the lock for 30 seconds.
     *
     * @param {Number} Key
     * @params {Object} Options: timeout
     * @returns {Date} New expiration or false.
     */
    renewLock: function (key, options) {
      var expires = new Date(),
        updated,
        timeout = options && options.timeout ? options.timeout : 30,
        updateSql = "update xt.lock set lock_expires = $1 where lock_id = $2;";

      if (typeof key !== "number") { return false; }
      expires = new Date(expires.setSeconds(expires.getSeconds() + timeout));

      if (DEBUG) {
        XT.debug('renewLock sql = ', updateSql);
        XT.debug('renewLock values = ', [expires, key]);
      }
      updated = plv8.execute(updateSql, [expires, key]);

      if (updated) {
        return true;
      }

      return false;
    }
  }

}());

$$ );
