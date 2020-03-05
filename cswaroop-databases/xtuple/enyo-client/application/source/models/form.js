/*jshint indent:2, curly:true, eqeqeq:true, immed:true, latedef:true,
newcap:true, noarg:true, regexp:true, undef:true, strict:true, trailing:true,
white:true*/
/*global XT:true, XM:true, _:true, Backbone:true */

(function () {
  "use strict";

  /**
    @class

    @extends XM.Document
  */
  XM.Form = XM.Document.extend({
    /** @scope XM.Form.prototype */

    recordType: 'XM.Form',

    keepInHistory: false,

    initialize: function (attributes, options) {
      XM.Model.prototype.initialize.apply(this, arguments);
      
      this.meta = new Backbone.Model({
        "order": null,
        "printer": null
      });
      this.meta.on("change", this.metaChanged());
    },

    /**
      Set this model's PrintSettings attribute (User Form Print Settings preference).
    */
    metaChanged: function () {
      this.setStatus(XM.Model.READY_DIRTY);
    },

    save: function () {
      return;
    }

  });

  _.extend(XM.Form, {
     /** @scope XM.Form */

    /**
      Credit memo form type.
      @static
      @constant
      @type String
      @default C
    */
    RETURN: 'C',

    /**
      Invoice form type
      @static
      @constant
      @type String
      @default I
    */
    INVOICE: 'I',

    /**
      Statement form type
      @static
      @constant
      @type String
      @default S
    */
    STATEMENT: 'S',

    /**
      Quote form type
      @static
      @constant
      @type String
      @default Q
    */
    QUOTE: 'Q',

    /**
      Packlist form type.
      @static
      @constant
      @type String
      @default P
    */
    PACK_LIST: 'P',

    /**
      Picklist form type
      @static
      @constant
      @type String
      @default L
    */
    PICK_LIST: 'L'

  });

  /**
    @class

    @extends XM.Document
  */
  XM.LabelForm = XM.Document.extend({
    /** @scope XM.LabelForm.prototype */

    recordType: 'XM.LabelForm',

    documentKey: 'name',

    nameAttribute: 'name',

    keepInHistory: false

  });

  /**
    @class

    @extends XM.Document
  */
  XM.ShipForm = XM.Document.extend({
    /** @scope XM.ShipForm.prototype */

    recordType: 'XM.ShipForm',

    documentKey: 'name',

    nameAttribute: 'name',

    keepInHistory: false

  });

  // ..........................................................
  // COLLECTIONS
  //

  XM.FormCollection = XM.Collection.extend({
    /** @scope XM.FormCollection.prototype */

    model: XM.Form

  });

  XM.LabelFormCollection = XM.Collection.extend({
    /** @scope XM.LabelFormCollection.prototype */

    model: XM.LabelForm

  });

  XM.ShipFormCollection = XM.Collection.extend({
    /** @scope XM.ShipFormCollection.prototype */

    model: XM.ShipForm

  });

}());
