(function() {

var _ref;

Ember.Fn = Ember.Foundation = Ember.Namespace.create();

Ember.Foundation.VERSION = "5.0.2";

if ((_ref = Ember.libraries) != null) {
  _ref.register("Ember Foundation", Ember.Foundation.VERSION);
}


})();

(function() {

Ember.TEMPLATES["components/fn-panel"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
  var buffer = '', stack1, hashContexts, hashTypes, options, helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression;


  data.buffer.push("<div ");
  hashContexts = {'class': depth0};
  hashTypes = {'class': "STRING"};
  options = {hash:{
    'class': (":panel radius callout")
  },contexts:[],types:[],hashContexts:hashContexts,hashTypes:hashTypes,data:data};
  data.buffer.push(escapeExpression(((stack1 = helpers['bind-attr'] || (depth0 && depth0['bind-attr'])),stack1 ? stack1.call(depth0, options) : helperMissing.call(depth0, "bind-attr", options))));
  data.buffer.push(">\n  ");
  hashTypes = {};
  hashContexts = {};
  data.buffer.push(escapeExpression(helpers._triageMustache.call(depth0, "yield", {hash:{},contexts:[depth0],types:["ID"],hashContexts:hashContexts,hashTypes:hashTypes,data:data})));
  data.buffer.push("\n</div>\n");
  return buffer;
  
});

})();

(function() {


Ember.Foundation.FnPanelComponent = Ember.Component.extend({
  classNames: "panel",
  classNameBindings: ["callout:callout", "radius:radius"],
  callout: false,
  radius: false
});


})();

(function() {


Ember.Foundation.FormComponent = Ember.Component.extend(Ember.TargetActionSupport, {
  tagName: "form",
  attributeBindings: ["name", "method"],
  name: null,
  method: "POST",
  submit: function(event) {
    event.preventDefault();
    this.triggerAction();
    return Ember.get(this, "propogateEvents");
  }
});

Ember.Handlebars.helper("fn-form", Ember.Foundation.FormComponent);


})();
