/*jshint bitwise:true, indent:2, curly:true, eqeqeq:true, immed:true,
latedef:true, newcap:true, noarg:true, regexp:true, undef:true,
trailing:true, white:true, strict:false*/
/*global XT:true, XM:true, XV:true, _:true, enyo:true, window:true, Globalize:true, async:true*/

(function () {

  /**
    Expected to a have a parameter widget that contains an order and
    a transaction date.

    @name XV.TransactionList
    @extends XV.List
   */
  enyo.kind(
    /** @lends XV.TransactionList */{
    name: "XV.TransactionList",
    kind: "XV.List",
    fixedHeight: true,
    draggable: true,
    published: {
      transModule: null,
      transWorkspace: null,
      transFunction: null,
      itemScan: null,
      traceScan: null,
      locationScan: null,
      shipment: null,
      scannedItems: [],
      status: null
    },
    events: {
      onProcessingChanged: "",
      onOrderChanged: "",
      onShipmentChanged: "",
      onUpdateHeader: ""
    },
    handlers: {
      onBarcodeCapture: "captureBarcode"
    },
    multiSelect: true,
    showDeleteAction: false,
    toggleSelected: true,
    actions: [
      {name: "transactItem", prerequisite: "canTransactItem",
        method: "transactItem", notify: false, isViewMethod: true},
      {name: "transactLine", prerequisite: "canTransactItem",
        method: "transactLine", notify: false, isViewMethod: true},
      {name: "returnLine", prerequisite: "canReturnItem",
        method: "returnItem", notify: false, isViewMethod: true}
    ],
    captureBarcode: function (inSender, inEvent) {
      var that = this,
        transFunction = that.getTransFunction(),
        transModule = that.getTransModule(),
        match,
        params,
        data = [],
        scan = inEvent.data,
        items = this.scannedItems.length ? this.scannedItems : this.value.models,
        matchingModels = _.filter(items, function (model) {
          var K = XM.ItemSite,
            detModels = model.getValue("itemSite.detail").models,
            scanModel = null,
            itemBarcode = model.getValue("itemSite.item.barcode"),
            itemNumber = model.getValue("itemSite.item.number"),
            isLocControl = model.getValue("itemSite.locationControl"),
            isLsControl = model.getValue("itemSite.controlMethod") ===
              K.SERIAL_CONTROL || model.getValue("itemSite.controlMethod") === K.LOT_CONTROL,
            isItemScan = (itemBarcode ? itemBarcode === scan.substring(0, itemBarcode.length) : false) ||
              (itemNumber === scan.substring(0, itemNumber.length)),
            traceScanReady = (that.kind === "XV.EnterReceiptList" && that.getScannedItems().length === 1 &&
              (isLocControl ? model.getValue("locationScan") : true));

          if (isItemScan) {
            match = "itemScan";
            that.setItemScan(scan);
            return model;
          }
          if (isLocControl) {
            // Enter Receipt special handling
            if (that.kind === "XV.EnterReceiptList" && that.getScannedItems().length === 1) {
              // TODO: define detModels for EnterReceipt as all possible locations for item
              var isLocation = _.find(XM.locations.models, function (mod) {
                return mod.formatConcat() === scan;
              });

              if (isLocation) {
                match = "locationScan";
                that.setLocationScan(scan);
                return model;
              }
            } else {
              // Not EnterReceipt handling
              scanModel = _.find(detModels, function (det) {
                return det.getValue("location.name") === scan;
              });

              if (scanModel) {
                match = "locationScan";
                that.setLocationScan(scan);
                return model;
              }
            }
          }
          if (isLsControl) {
            scanModel = _.find(detModels, function (det) {
              return det.getValue("trace.number") === scan;
            });
            // Enter Receipt special handling
            if (scanModel || traceScanReady) {
              match = "traceScan";
              that.setTraceScan(scan);
              return model;
            }
          }
        });
      // We have a successful scan, a matched scan attribute and a matching model
      if (scan && ((matchingModels.length === 1 && match) ||
        /** 
          Or we have a matched itemScan and more than 1 matching models, if this is the case,
          sort the models by date and select the first one that has qty required (balance).
        */
        (matchingModels.length && match === "itemScan"))) {
        if (matchingModels.length > 1 && match === "itemScan") {
          var sortedMatchingModels = _.sortBy(matchingModels, function (mod) {
            return mod.getValue("dueDate") || mod.getValue("scheduleDate");
          });
          matchingModels = [_.find(sortedMatchingModels, function (itemModel) {
            return itemModel.getValue("balance");
          })];
          if (!matchingModels) {return; }
        }

        var model = matchingModels[0],
          index = that.value.indexOf(model),
          scannedItems = that.getScannedItems();

        // If index !== scannedItems index reset the scanned attributes on the model
        if ((scannedItems.length === 1) &&
          scannedItems[0] !== model) {
          that.resetScannedItems();
        }
        // Patch, only add it to scannedItems if it's not there already from a prev. matching scan
        if (!_.contains(scannedItems, model)) {
          that.scannedItems.push(model);
        }
        model.setValue(match, scan);
        that.sortList();

        // Check model for all requiredScans, if so, proceed
        if (model.validateScanAttrs()) {
          var balance = model.getValue("balance"),
            qtyToTransact = balance < 1 ? balance : 1,
            options = {},
            dispOptions = {};
          if (transFunction === "receipt") {
            options.freight = model.get("freight");
          }
          options.asOf = model.transactionDate;
          options.detail = model.formatDetail();

          if (!qtyToTransact) {
            return that.doNotify({message: "Error: " + "_noQtyToTransact".loc()});
          }
          if (options.detail.length > 1) {
            return that.doNotify({message: "Error: " + "_multipleDetailModels".loc()});
          }
          params = {
            orderLine: model.id,
            quantity: qtyToTransact,
            options: options
          };
          data.push(params);

          that.doProcessingChanged({isProcessing: true});
          dispOptions.success = function () {
            that.doProcessingChanged({isProcessing: false});
            /*
              If Print Label sticky checkbox has been checked in the transaction workspace kind,
              proceed to print. This should be replaced by a metric or user pref. print setting.
            */
            if (ws && ws.$.printLabel.isChecked()) {
              var printOptions = {
                docType: "label",
                model: model,
                printQty: model.printQty
              };
              that.doPrint(printOptions);
            }
            that.resetScannedItems();
          };
          dispOptions.error = function () {
            that.resetScannedItems();
            that.doProcessingChanged({isProcessing: false});
          };

          // Get the workspace in order to check the Print Label checkbox in dispOptions.success.
          var Workspace = enyo.getObject(that.getTransWorkspace()),
            ws = new Workspace();
          // model's transactItem method sends dispatch
          return transModule.transactItem(data, dispOptions, transFunction);
        }
      } else if (matchingModels.length > 1) {
        var oldMatchingModels = _.difference(this.scannedItems, matchingModels);
        // Reset the old scanned models that are no longer matching.
        if (oldMatchingModels) {
          _.each(oldMatchingModels, function (model) {
            model.resetScanAttrs();
          });
        }
        // Reset/Set the new matching models
        that.setScannedItems([]);
        _.each(matchingModels, function (model) {
          if (!_.contains(that.getScannedItems(), model)) {
            that.scannedItems.push(model);
          }
          model.setValue(match, scan);
        });

        return that.sortList();
      } else { // scan didn't match any thing on the list
        if (that.kind === "XV.EnterReceiptList" && !that.getScannedItems().length) {
          return that.doNotify({message: "_itemScanReqMessage".loc() + scan});
        }
        if (that.kind === "XV.EnterReceiptList" && that.getScannedItems().length === 1 && !that.getScannedItems()[0].getValue("locationScan")) {
          return this.doNotify({message: "_locationScanReqMessage".loc() + scan});
        }
        inEvent.noItemFound = true;
        return this.doNotify({message: "_noItemFoundForScan".loc() + scan});
      }
    },
    /**
      Refresh model(s) to disp. fifoDetail meta attribute which was set after list rendered.
    */
    fetched: function (collection, data, options) {
      this.inherited(arguments);
      this.sortList();
    },
    formatQuantity: function (value) {
      var scale = XT.locale.quantityScale;
      return Globalize.format(value, "n" + scale);
    },
    formatQohOther: function (value, view, model) {
      if (model.getValue("metaStatus").code === "O") {
        view.setShowing(true);
      }
      return value;
    },
    formatScanAttrs: function (value, view, model) {
      if (!value && model.requiresDetail()) {
        value = "_req.".loc();
      }
      return value;
    },
    formatScanText: function () {
      var item = this.getItemScan() ? "_item:".loc() + this.getItemScan() : "",
        trace = this.getTraceScan() ? "_lot:".loc() + this.getTraceScan() : "",
        location = this.getLocationScan() ? "_location:".loc() + this.getLocationScan() : "";

      return item + location + trace;
    },
    formatScheduleDate: function (value, view, model) {
      var today = new Date(),
        isLate = XT.date.compareDate(value, today) < 1 &&
          model.get("balance") > 0;
      view.addRemoveClass("error", isLate);
      return value ? Globalize.format(value, "d") : "";
    },
    resetScannedItems: function () {
      this.setScannedItems([]);
      this.setTraceScan();
      this.setItemScan();
      this.setLocationScan(); //TODO - don't erase locationScan
      _.each(this.value.models, function (model) {
        model.resetScanAttrs();
      });
      this.sortList();
      return true;
    },
    formatStatus: function (value, view, model) {
      var color = model.getValue("metaStatus").color;
      view.addStyles("color: " + color + "; font-size: 32px; text-align: center; " +
        "vertical-align: middle; width: 32px; padding-bottom: 0px;");
      return value;
    },
    /**
      Handle div bars
    */
    setupItem: function (inSender, inEvent) {
      this.inherited(arguments);
      var i = inEvent.index,
          data = this.filter ? this.filtered : this.value.models,
          model = data.models[i];

      // Handle Divider:
      if (model && this.$.divider) {
        var status = model.formatStatus(),
          prev = data.models[i - 1],
          showd = status !== (prev && prev.formatStatus());

        this.$.divider.canGenerate = showd;
        if (model.getValue("metaStatus").code === "P") {
          var desc = model.getValue("metaStatus").description,
            formatScanText = this.formatScanText();

          this.$.divider.setContent(desc + formatScanText);
        } else {
          this.$.divider.setContent(model.getValue("metaStatus").description);
        }
        //this.$.listItem.applyStyle('border-top', showd ? 'none' : null);
      }
    },
    /**
      Sort the list by (meta) status
    */
    sortList: function () {
      this.refresh();
      this.value.models.sort(function (a, b) {
        if (a.getValue("metaStatus").order < b.getValue("metaStatus").order) {
          return -1;
        } else if (a.getValue("metaStatus").order > b.getValue("metaStatus").order) {
          return 1;
        } else {
          return 0;
        }
      });
      this.refresh();
    },
    /**
        Helper function for transacting `transact` on an array of models.

        @param {Array} Models
        @param {Boolean} Prompt user for confirmation on every model
        @param {String} Optional to handle the transaction function name, if not passed
        it will use the published value. Used by ReturnMaterial's actions.
        @param {String} Optional to handle the workspace name, if not passed
        it will use the published value. Used by ReturnMaterial's actions.
        @param {String} Optional to handle the quantity attr name, if not passed
        it will use the model.quantityAttribute. Used by ReturnMaterial's actions.
    */
    transact: function (models, prompt, transFunction, transWorkspace) {
      var that = this,
        i = -1,
        callback,
        data = [];

      that._printModels = [];

      // Recursively transact everything we can
      // #refactor see a simpler implementation of this sort of thing
      // using async in inventory's ReturnListItem stomp
      callback = function (workspace, transFunction, transWorkspace) {
        var model,
          options = {},
          toTransact,
          transDate,
          params,
          dispOptions = {},
          wsOptions = {},
          wsParams,
          transModule = that.getTransModule();

        transFunction = transFunction || that.getTransFunction();
        transWorkspace = transWorkspace || that.getTransWorkspace();

        // If argument is false, this whole process was cancelled
        if (workspace === false) {
          return;

        // If a workspace brought us here, process the information it obtained
        } else if (workspace) {
          model = workspace.getValue();
          toTransact = model.quantityAttribute ? model.get(model.quantityAttribute) : null;
          transDate = model.transactionDate;
          if (workspace._printAfterPersist) {
            that._printModels.push(model);
          }

          if (toTransact) {
            model.printQty = toTransact;
            if (transFunction === "receipt") {
              wsOptions.freight = model.get("freight");
            }
            wsOptions.detail = model.formatDetail();
            wsOptions.asOf = transDate;
            wsParams = {
              orderLine: model.id,
              quantity: toTransact,
              options: wsOptions
            };
            data.push(wsParams);
          }
          workspace.doPrevious();
        }

        i++;
        // If we've worked through all the models then forward to the server
        if (i === models.length) {
          if (data[0]) {
            that.doProcessingChanged({isProcessing: true});
            dispOptions.success = function () {
              that.doProcessingChanged({isProcessing: false});
              if (that._printModels.length) {
                var printOptions = [];
                return _.each(that._printModels, function (model) {
                  printOptions.docType = "label";
                  printOptions.model = model;
                  printOptions.printQty = model.printQty;
                  that.doPrint(printOptions);
                });
              }

            };
            dispOptions.error = function () {
              that.doProcessingChanged({isProcessing: false});
            };
            transModule.transactItem(data, dispOptions, transFunction);
          } else {
            return;
          }

        // Else if there's something here we can transact, handle it
        } else {
          model = models[i];
          toTransact = model.get(model.quantityAttribute) || model.get("balance");
          transDate = model.transactionDate;

          // See if there's anything to transact here
          if (toTransact || prompt) {

            // If prompt or distribution detail required,
            // open a workspace to handle it
            if (prompt || model.undistributed() || model.requiresDetail()) {
              that.doWorkspace({
                workspace: transWorkspace,
                id: model.id,
                callback: callback,
                allowNew: false
              });

            // Otherwise just use the data we have
            } else {
              // Shove in this model to get printed because it didn't come from a workspace,
              var Workspace = enyo.getObject(that.getTransWorkspace()),
                ws = new Workspace();
              if (ws.$.printLabel && ws.$.printLabel.isChecked()) {
                model.printQty = toTransact;
                that._printModels.push(model);
              }
              if (transFunction === "receipt") {
                options.freight = model.get("freight");
              }
              options.asOf = transDate;
              options.detail = model.formatDetail();
              params = {
                orderLine: model.id,
                quantity: toTransact,
                options: options
              };
              data.push(params);
              callback(null, transFunction, transWorkspace);
            }

          // Nothing to transact, move on
          } else {
            callback(null, transFunction, transWorkspace);
          }
        }
      };
      callback(null, transFunction, transWorkspace);
    },
    transactAll: function () {
      var models = this.getValue().models;
      // use 'balance' attribute for qty
      this.transact(models);
    },
    transactLine: function () {
      var models = this.selectedModels();
      // use 'balance' attribute for qty
      this.transact(models);
    },
    transactItem: function () {
      var models = this.selectedModels();
      this.transact(models, true);
    },
    returnItem: function () {
      var models = this.selectedModels(),
        that = this,
        data =  [],
        options = {},
        qtyTransacted,
        model,
        i,
        transModule = that.getTransModule();

      for (i = 0; i < models.length; i++) {
        model = models[i];
        qtyTransacted = model.get(model.quantityTransactedAttribute);

        // See if there's anything to transact here
        if (qtyTransacted) {
          data.push(model.id);
        }
      }

      if (data.length) {
        that.doProcessingChanged({isProcessing: true});
        options.success = function () {
          that.doProcessingChanged({isProcessing: false});
        };
        transModule.returnItem(data, options);
      }
    },
    selectedModels: function () {
      var collection = this.getValue(),
        models = [],
        selected,
        prop;
      if (collection.length) {
        selected = this.getSelection().selected;
        for (prop in selected) {
          if (selected.hasOwnProperty(prop)) {
            models.push(this.getModel(prop - 0));
          }
        }
      }
      return models;
    }
  });

}());

