// Last commit: f16740a (2013-02-27 16:14:05 -0500)


(function() {
Ember.Validations = Ember.Namespace.create({
  VERSION: '0.2.1'
});

})();



(function() {
Ember.Application.reopen({
  bootstrapValidations: function(validations) {
    var objectName, property, validator, option, value, tmp,
    normalizedValidations = {}, existingValidations;
    function normalizeObject(object) {
      var key, value, normalizedObject = {};

      for (key in object) {
        if (typeof(object[key]) === 'object') {
          value = normalizeObject(object[key]);
        } else {
          value = object[key];
        }
        normalizedObject[key.camelize()] = value;
      }
      return normalizedObject;
    }

    for (objectName in validations) {
      existingValidations = (new this[objectName.camelize().capitalize()]()).get('validations');
      normalizedValidations = normalizeObject(validations[objectName]);
      this[objectName.camelize().capitalize()].reopen({
        validations: Ember.$.extend(true, {}, normalizedValidations, existingValidations)
      });

    }
  }
});

})();



(function() {
Ember.Validations.messages = {
  render: function(attribute, context) {
    return Handlebars.compile(Ember.Validations.messages.defaults[attribute])(context);
  },
  defaults: {
    inclusion: "is not included in the list",
    exclusion: "is reserved",
    invalid: "is invalid",
    confirmation: "doesn't match {{attribute}}",
    accepted: "must be accepted",
    empty: "can't be empty",
    blank: "can't be blank",
    present: "must be blank",
    tooLong: "is too long (maximum is {{count}} characters)",
    tooShort: "is too short (minimum is {{count}} characters)",
    wrongLength: "is the wrong length (should be {{count}} characters)",
    notANumber: "is not a number",
    notAnInteger: "must be an integer",
    greaterThan: "must be greater than {{count}}",
    greaterThanOrEqualTo: "must be greater than or equal to {{count}}",
    equalTo: "must be equal to {{count}}",
    lessThan: "must be less than {{count}}",
    lessThanOrEqualTo: "must be less than or equal to {{count}}",
    otherThan: "must be other than {{count}}",
    odd: "must be odd",
    even: "must be even"
  }
};

})();



(function() {
Ember.Validations.Errors = Ember.Object.extend({
  add: function(property, value) {
    this.set(property, (this.get(property) || []).concat(value));
  },
  clear: function() {
    var keys = Object.keys(this);
    for(var i = 0; i < keys.length; i++) {
      this.set(keys[i], undefined);
      delete this[keys[i]];
    }
  }
});

})();



(function() {
Ember.Validations.Mixin = Ember.Mixin.create({
  init: function() {
    this._super();
    this.set('errors', Ember.Validations.Errors.create());
    if (this.get('validations') === undefined) {
      this.set('validations', {});
    }
  },
  validate: function(filter) {
    var options, message, property, validator, toRun, value, index1, index2, valid = true, deferreds = [];
    var object = this;
    if (filter !== undefined) {
      toRun = [filter];
    } else {
      toRun = Object.keys(object.validations);
    }
    for(index1 = 0; index1 < toRun.length; index1++) {
      property = toRun[index1];
      this.errors.set(property, undefined);
      delete this.errors[property];

      for(validator in this.validations[property]) {
        value = object.validations[property][validator];
        if (typeof(value) !== 'object' || (typeof(value) === 'object' && value.constructor !== Array)) {
          value = [value];
        }

        for(index2 = 0; index2 < value.length; index2++) {
          var deferredObject = new Ember.Deferred();
          deferreds = deferreds.concat(deferredObject);
          message = Ember.Validations.validators.local[validator](object, property, value[index2], deferredObject);
        }
      }
    }

    return Ember.RSVP.all(deferreds).then(function() {
      object.set('isValid', Object.keys(object.errors).length === 0);
    });
  }
});

})();



(function() {
Ember.Validations.patterns = Ember.Namespace.create({
  numericality: /^(-|\+)?(?:\d+|\d{1,3}(?:,\d{3})+)(?:\.\d*)?$/,
  blank: /^\s*$/
});

})();



(function() {
Ember.Validations.validators        = Ember.Namespace.create();
Ember.Validations.validators.local  = Ember.Namespace.create();
Ember.Validations.validators.remote = Ember.Namespace.create();

})();



(function() {
Ember.Validations.validators.local.reopen({
  absence: function(model, property, options, deferredObject) {
    /*jshint expr:true*/
    if (options === true) {
      options = {};
    }

    if (options.message === undefined) {
      options.message = Ember.Validations.messages.render('present', options);
    }

    if (!Ember.Validations.Utilities.isBlank(model.get(property))) {
      model.errors.add(property, options.message);
    }

    deferredObject && deferredObject.resolve();
  }
});

})();



(function() {
Ember.Validations.validators.local.reopen({
  acceptance: function(model, property, options, deferredObject) {
    /*jshint expr:true*/
    if (options === true) {
      options = {};
    }

    if (options.message === undefined) {
      options.message = Ember.Validations.messages.render('accepted', options);
    }

    if (options.accept) {
      if (model.get(property) !== options.accept) {
        model.errors.add(property, options.message);
      }
    } else if (model.get(property) !== '1' && model.get(property) !== 1 && model.get(property) !== true) {
      model.errors.add(property, options.message);
    }
    deferredObject && deferredObject.resolve();
  }
});

})();



(function() {
Ember.Validations.validators.local.reopen({
  confirmation: function(model, property, options, deferredObject) {
    /*jshint expr:true*/
    if (options === true) {
      options = { attribute: property };
      options = { message: Ember.Validations.messages.render('confirmation', options) };
    }

    if (model.get(property) !== model.get('' + property + 'Confirmation')) {
      model.errors.add(property, options.message);
    }
    deferredObject && deferredObject.resolve();
  }
});

})();



(function() {
Ember.Validations.validators.local.reopen({
  exclusion: function(model, property, options, deferredObject) {
    /*jshint expr:true*/
    var message, lower, upper;

    if (options.constructor === Array) {
      options = { 'in': options };
    }

    if (options.message === undefined) {
      options.message = Ember.Validations.messages.render('exclusion', options);
    }

    if (Ember.Validations.Utilities.isBlank(model.get(property))) {
      if (options.allowBlank === undefined) {
        model.errors.add(property, options.message);
      }
    } else if (options['in']) {
      if (Ember.$.inArray(model.get(property), options['in']) !== -1) {
        model.errors.add(property, options.message);
      }
    } else if (options.range) {
      lower = options.range[0];
      upper = options.range[1];

      if (model.get(property) >= lower && model.get(property) <= upper) {
        model.errors.add(property, options.message);
      }
    }
    deferredObject && deferredObject.resolve();
  }
});

})();



(function() {
Ember.Validations.validators.local.reopen({
  format: function(model, property, options, deferredObject) {
    /*jshint expr:true*/
    var message;

    if (options.constructor === RegExp) {
      options = { 'with': options };
    }

    if (options.message === undefined) {
      options.message = Ember.Validations.messages.render('invalid', options);
    }

    if (Ember.Validations.Utilities.isBlank(model.get(property))) {
      if (options.allowBlank === undefined) {
        model.errors.add(property, options.message);
      }
    } else if (options['with'] && !options['with'].test(model.get(property))) {
      model.errors.add(property, options.message);
    } else if (options.without && options.without.test(model.get(property))) {
      model.errors.add(property, options.message);
    }

    deferredObject && deferredObject.resolve();
  }
});

})();



(function() {
Ember.Validations.validators.local.reopen({
  inclusion: function(model, property, options, deferredObject) {
    /*jshint expr:true*/
    var message, lower, upper;

    if (options.constructor === Array) {
      options = { 'in': options };
    }

    if (options.message === undefined) {
      options.message = Ember.Validations.messages.render('inclusion', options);
    }

    if (Ember.Validations.Utilities.isBlank(model.get(property))) {
      if (options.allowBlank === undefined) {
        model.errors.add(property, options.message);
      }
    } else if (options['in']) {
      if (Ember.$.inArray(model.get(property), options['in']) === -1) {
        model.errors.add(property, options.message);
      }
    } else if (options.range) {
      lower = options.range[0];
      upper = options.range[1];

      if (model.get(property) < lower || model.get(property) > upper) {
        model.errors.add(property, options.message);
      }
    }
    deferredObject && deferredObject.resolve();
  }
});

})();



(function() {
Ember.Validations.validators.local.reopen({
  length: function(model, property, options, deferredObject) {
    /*jshint expr:true*/
    var CHECKS, MESSAGES, allowBlankOptions, check, fn, message, operator, tokenizedLength, tokenizer, index, keys, key;

    CHECKS = {
      'is'      : '==',
      'minimum' : '>=',
      'maximum' : '<='
    };

    MESSAGES = {
      'is'      : 'wrongLength',
      'minimum' : 'tooShort',
      'maximum' : 'tooLong'
    };

    if (typeof(options) === 'number') {
      options = { 'is': options };
    }

    if (options.messages === undefined) {
      options.messages = {};
    }

    keys = Object.keys(MESSAGES);
    for (index = 0; index < keys.length; index++) {
      key = keys[index];
      if (options[key] !== undefined && options.messages[key] === undefined) {
        if (Ember.$.inArray(key, Object.keys(CHECKS)) !== -1) {
          options.count = options[key];
        }
        options.messages[key] = Ember.Validations.messages.render(MESSAGES[key], options);
        if (options.count !== undefined) {
          delete options.count;
        }
      }
    }

    tokenizer = options.tokenizer || 'split("")';
    tokenizedLength = new Function('value', 'return value.' + tokenizer + '.length')(model.get(property) || '');

    allowBlankOptions = {};
    if (options.is) {
      allowBlankOptions.message = options.messages.is;
    } else if (options.minimum) {
      allowBlankOptions.message = options.messages.minimum;
    }

    if (Ember.Validations.Utilities.isBlank(model.get(property))) {
      if (options.allowBlank === undefined) {
        model.errors.add(property, allowBlankOptions.message);
      }
    } else {
      for (check in CHECKS) {
        operator = CHECKS[check];
        if (!options[check]) {
          continue;
        }

        fn = new Function("return " + tokenizedLength + " " + operator + " " + options[check]);
        if (!fn()) {
          model.errors.add(property, options.messages[check]);
        }
      }
    }
    deferredObject && deferredObject.resolve();
  }
});

})();



(function() {
Ember.Validations.validators.local.reopen({
  numericality: function(model, property, options, deferredObject) {
    /*jshint expr:true*/
    var CHECKS, check, checkValue, fn, form, operator, val, index, keys, key;

    CHECKS = {
      equalTo              :'===',
      greaterThan          : '>',
      greaterThanOrEqualTo : '>=',
      lessThan             : '<',
      lessThanOrEqualTo    : '<='
    };

    if (options === true) {
      options = {};
    }

    if (options.messages === undefined) {
      options.messages = { numericality: Ember.Validations.messages.render('notANumber', options) };
    }

    if (options.onlyInteger !== undefined && options.messages.onlyInteger === undefined) {
      options.messages.onlyInteger = Ember.Validations.messages.render('notAnInteger', options);
    }

    keys = Object.keys(CHECKS).concat(['odd', 'even']);
    for(index = 0; index < keys.length; index++) {
      key = keys[index];
      if (options[key] !== undefined && options.messages[key] === undefined) {
        if (Ember.$.inArray(key, Object.keys(CHECKS)) !== -1) {
          options.count = options[key];
        }
        options.messages[key] = Ember.Validations.messages.render(key, options);
        if (options.count !== undefined) {
          delete options.count;
        }
      }
    }

    if (Ember.Validations.Utilities.isBlank(model.get(property))) {
      if (options.allowBlank === undefined) {
        model.errors.add(property, options.messages.numericality);
      }
    } else if (!Ember.Validations.patterns.numericality.test(model.get(property))) {
      model.errors.add(property, options.messages.numericality);
    } else if (options.onlyInteger === true && !(/^[+\-]?\d+$/.test(model.get(property)))) {
      model.errors.add(property, options.messages.onlyInteger);
    } else if (options.odd  && parseInt(model.get(property), 10) % 2 === 0) {
      model.errors.add(property, options.messages.odd);
    } else if (options.even && parseInt(model.get(property), 10) % 2 !== 0) {
      model.errors.add(property, options.messages.even);
    } else {

      for (check in CHECKS) {
        operator = CHECKS[check];

        if (options[check] === undefined) {
          continue;
        }

        if (!isNaN(parseFloat(options[check])) && isFinite(options[check])) {
          checkValue = options[check];
        } else if (model.get(options[check]) !== undefined) {
          checkValue = model.get(options[check]);
        } else {
          deferredObject && deferredObject.resolve();
          return;
        }

        fn = new Function('return ' + model.get(property) + ' ' + operator + ' ' + checkValue);

        if (!fn()) {
          model.errors.add(property, options.messages[check]);
        }
      }
    }
    deferredObject && deferredObject.resolve();
  }
});

})();



(function() {
Ember.Validations.validators.local.reopen({
  presence: function(model, property, options, deferredObject) {
    /*jshint expr:true*/
    if (options === true) {
      options = {};
    }

    if (options.message === undefined) {
      options.message = Ember.Validations.messages.render('blank', options);
    }

    if (Ember.Validations.Utilities.isBlank(model.get(property))) {
      model.errors.add(property, options.message);
    }

    deferredObject && deferredObject.resolve();
  }
});

})();



(function() {
Ember.Validations.validators.local.reopen({
  uniqueness: function(model, property, options) {
  }
});

})();



(function() {

})();



(function() {
// this is fugly, I know but no other way to get these from what I can see
// var states = (new DS.StateManager).states;
// var validating = DS.State.extend({
  // enter: function(manager) {

  // }
// });

// states.rootState.get('loaded.created').reopen({
  // validating: validating
// });

// states.rootState.get('loaded.updated').reopen({
  // validating: validating
// });

// DS.StateManager.reopen({
  // states: states
// });

})();



(function() {
Ember.Validations.Utilities = {
  isBlank: function(value) {
    return value !== 0 && (!value || /^\s*$/.test(''+value));
  }
};

})();



(function() {

})();
