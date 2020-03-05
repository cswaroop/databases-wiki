/*jshint indent:2, curly:true, eqeqeq:true, immed:true, latedef:true,
newcap:true, noarg:true, regexp:true, undef:true, strict:true, trailing:true,
white:true*/
/*global XT:true, XM:true, _:true */

(function () {

  "use strict";

  var CREDIT_OK = 0;
  var CREDIT_WARN = 1;
  var CREDIT_HOLD = 2;
  var _checkCredit = function () {
    var creditStatus = this.getValue("customer.creditStatus"),
      K = XM.Customer,
      privs = XT.session.privileges;

    if (this.isNew() && creditStatus !== K.CREDIT_GOOD) {
      if (creditStatus === K.CREDIT_WARN &&
        !privs.get("CreateSOForWarnCustomer")) {
        return CREDIT_WARN;
      } else if (creditStatus === K.CREDIT_HOLD &&
        !privs.get("CreateSOForHoldCustomer")) {
        return CREDIT_HOLD;
      }
    }
    return CREDIT_OK;
  };

  /**
    @class

    @extends XM.SalesOrderBase
  */
  XM.SalesOrder = XM.SalesOrderBase.extend(
    /** @lends XM.SalesOrder.prototype */{

    recordType: 'XM.SalesOrder',

    nameAttribute: 'number',

    numberPolicySetting: 'CONumberGeneration',

    documentDateKey: "orderDate",

    handlers: {
      "change:holdType": "holdTypeDidChange",
      "change:scheduleDate": "scheduleDateChanged",
      "change:total": "calculateBalance"
    },

    /**
      Add default for wasQuote.
     */
    defaults: function () {
      var defaults = XM.SalesOrderBase.prototype.defaults.apply(this, arguments);

      defaults.wasQuote = false;

      defaults.balance = 0;

      return defaults;
    },

    calculateBalance: function () {
      var rawBalance = this.get("total") -
          this.get("allocatedCredit") -
          this.get("authorizedCredit") -
          this.get("outstandingCredit"),
        balance = Math.max(0, rawBalance);

      this.set({balance: balance});
    },

    customerDidChange: function () {
      XM.SalesOrderBase.prototype.customerDidChange.apply(this, arguments);
      var creditStatus = _checkCredit.call(this),
        warn = XM.Model.WARNING;
      if (creditStatus === CREDIT_WARN) {
        this.notify("_creditWarn".loc(), { type: warn });
      } else if (creditStatus === CREDIT_HOLD) {
        this.notify("_creditHold".loc(), { type: warn });
      }
    },

    getPrintParameters: function (callback) {
      var that = this,
        dispOptions = {},
        dispParams = {
          docNumber: that.id,
          table: "cohead",
          column: "cohead_number"
        };

      dispOptions.success = function (pkId) {
        var printParameters = [
          {name: "sohead_id", type: "integer", value: pkId},
          {name: "hide closed", type: "boolean", value: "true"}
          // Optional. TODO - What should determine warehouse id?
          //{name: "warehous_id", type: "integer", value: null}
        ];
        /*
          TODO - set printParameters according to the Report's req. parameters, i.e. PackingList:
        if (that.reportName === "PackingList") {
          printParameters.push(
            {name: "shiphead_id", type: "integer", value: },
            {name: "head_id", type: "integer", value: },
            {name: "head_type", type: "string", value: },
            {name: "MultiWhs", type: "boolean", value: },
            {name: "warehouse_id", type: integer, value: }
          );
        }
        */

        // Send back to enyo:
        callback({
          id: that.id, // Used for pdf naming convention in generate-report route.
          reportName: that.reportName || "CustOrderAcknowledgement",
          printParameters: printParameters
        });
      };

      if (that.custFormType) {
        this.dispatch("XM.Sales", "findCustomerForm", [this.getValue("customer.uuid"), that.custFormType], {success: function (resp) {
          that.reportName = resp;

          that.dispatch('XM.Model', 'fetchPrimaryKeyId', dispParams, dispOptions);
        }});
      } else {
        that.dispatch('XM.Model', 'fetchPrimaryKeyId', dispParams, dispOptions);
      }
    },

    holdTypeDidChange: function () {
      if (!this.get("holdType")) {
        _.each(this.get("workflow").where(
            {workflowType: XM.SalesOrderWorkflow.TYPE_CREDIT_CHECK}),
            function (workflow) {

          workflow.set({status: XM.Workflow.COMPLETED});
        });
      }
    },

    saleTypeDidChange: function () {
      var that = this,
        currentHoldType = this.get("holdType"),
        defaultHoldType = this.getValue("saleType.defaultHoldType") || null;

      if (!XT.session.settings.get("TriggerWorkflow")) {
        this.inheritWorkflowSource(this.get("saleType"), "XM.SalesOrderCharacteristic",
          "XM.SalesOrderWorkflow");
      }

      if (this.getStatus() === XM.Model.EMPTY) {
        // On a new order or saleType change with db TriggerWorkflow, set the hold type to the sale type default
        this.set({holdType: defaultHoldType});
      } else if (defaultHoldType !== currentHoldType && !XT.session.settings.get("TriggerWorkflow")) {
        // otherwise, if the sale type wants to drive a change to the hold type,
        // prompt the user.
        this.notify("_updateHoldType?".loc(), {
          type: XM.Model.QUESTION,
          callback: function (response) {
            if (response.answer) {
              that.set({holdType: defaultHoldType});
            }
          }
        });
      }
    },

    scheduleDateChanged: function () {
      var scheduleDate = this.get("scheduleDate"),
        packDate = this.get("packDate");

      if (!packDate) {
        this.set("packDate", scheduleDate);
      }
    },

    validate: function () {
      var creditStatus = _checkCredit.call(this);
      if (creditStatus === CREDIT_WARN) {
        return XT.Error.clone('xt2022');
      } else if (creditStatus === CREDIT_HOLD) {
        return XT.Error.clone('xt2023');
      }

      return XM.SalesOrderBase.prototype.validate.apply(this, arguments);
    }
  });
  _.extend(XM.SalesOrder.prototype, XM.WorkflowMixin);

  // ..........................................................
  // CLASS METHODS
  //
  _.extend(XM.SalesOrder, /** @lends XM.SalesOrderBase# */{
    /**
      Pass a quote id and receive a sales order in the success callback.

      @param {String} Quote number
      @param {Object} Options
      @param {Function} [options.success] Success callback
      @param {Function} [options.error] Error callback
    */
    convertFromQuote: function (id, options) {
      var success = options.success,
        proto = this.prototype;
      options.success = function (data) {
        data = proto.parse(data);
        success(data);
      };
      proto.dispatch("XM.SalesOrder", "convertFromQuote", [id], options);
    },

    used: function (id, options) {
      return XM.ModelMixin.dispatch('XM.SalesOrder', 'used',
        [id], options);
    }
  });

  XM.SalesOrderLine = XM.Model.extend(_.extend({}, XM.OrderLineMixin,
      XM.SalesOrderBaseMixin, XM.SalesOrderLineMixin, {

    recordType: 'XM.SalesOrderLine',

    parentKey: 'salesOrder',

    lineCharacteristicRecordType: "XM.SalesOrderLineCharacteristic",

    /**
      Add defaults for firm, and subnumber.
     */
    defaults: function () {
      var defaults = XM.SalesOrderLineMixin.defaults.apply(this, arguments);

      _.extend(defaults, {
        firm: false,
        subNumber: 0,
        status: XM.SalesOrder.OPEN_STATUS
      });

      return defaults;
    },

    isActive: function () {
      return this.get("status") === XM.SalesOrder.OPEN_STATUS;
    }
  }), XM.SalesOrderLineStaticMixin);

  XM.SalesOrderLine.prototype.augment({
    readOnlyAttributes: [
      "status"
    ]
  });


  /**
    @class

    @extends XM.Comment
  */
  XM.SalesOrderComment = XM.Comment.extend(/** @lends XM.SalesOrderComment.prototype */{

    recordType: 'XM.SalesOrderComment',

    sourceName: 'S'

  });

  /**
    @class

    @extends XM.CharacteristicAssignment
  */
  XM.SalesOrderCharacteristic = XM.CharacteristicAssignment.extend(/** @lends XM.SalesOrderCharacteristic.prototype */{

    recordType: 'XM.SalesOrderCharacteristic',

    which: 'isSalesOrders'

  });

  /**
    @class

    @extends XM.Workflow
  */
  XM.SalesOrderWorkflow = XM.Workflow.extend(
    /** @scope XM.SalesOrderWorkflow.prototype */ {

    recordType: 'XM.SalesOrderWorkflow',

    parentStatusAttribute: 'holdType',

    getSalesOrderWorkflowStatusString: function () {
      return XM.SalesOrderWorkflow.prototype.getWorkflowStatusString.call(this);
    }

  });
  _.extend(XM.SalesOrderWorkflow, /** @lends XM.SalesOrderLine# */{

    TYPE_OTHER: "O",

    TYPE_CREDIT_CHECK: "C",
  });

  /**
    @class

    @extends XM.CharacteristicAssignment
  */
  XM.SalesOrderLineCharacteristic = XM.CharacteristicAssignment.extend(/** @lends XM.SalesOrderLineCharacteristic.prototype */{

    recordType: 'XM.SalesOrderLineCharacteristic',

    readOnlyAttributes: [
      "price"
    ]

  });

  /**
    @class

    @extends XM.Comment
  */
  XM.SalesOrderLineComment = XM.Comment.extend(/** @lends XM.SalesOrderLineComment.prototype */{

    recordType: 'XM.SalesOrderLineComment',

    sourceName: 'SI'

  });

  /**
    @class

    @extends XM.Info
  */
  XM.SalesOrderListItem = XM.Info.extend(/** @lends XM.SalesOrderListItem.prototype */{

    recordType: 'XM.SalesOrderListItem',

    editableModel: 'XM.SalesOrder',

    getPrintParameters: XM.SalesOrder.prototype.getPrintParameters

  });

  XM.SalesOrderListItem = XM.SalesOrderListItem.extend(XM.SalesOrderBaseMixin);

  /**
    @class

    @extends XM.Info
  */
  XM.SalesOrderRelation = XM.Info.extend(/** @lends XM.SalesOrderRelation.prototype */{

    recordType: 'XM.SalesOrderRelation',

    editableModel: 'XM.SalesOrder',

    descriptionKey: "number"

  });

  XT.documentAssociations.S = {
    model: "XM.SalesOrderRelation",
    label: "_salesOrder".loc()
  };

  // ..........................................................
  // COLLECTIONS
  //

  /**
    @class

    @extends XM.Collection
  */
  XM.SalesOrderListItemCollection = XM.Collection.extend(/** @lends XM.SalesOrderListItemCollection.prototype */{

    model: XM.SalesOrderListItem

  });

  /**
    @class

    @extends XM.Collection
  */
  XM.SalesOrderRelationCollection = XM.Collection.extend(/** @lends XM.SalesOrderRelationCollection.prototype */{

    model: XM.SalesOrderRelation

  });

  /**
    @class

    @extends XM.Collection
  */
  XM.SalesOrderLineCollection = XM.Collection.extend(/** @lends XM.SalesOrderLineCollection.prototype */{

    model: XM.SalesOrderLine

  });

}());
