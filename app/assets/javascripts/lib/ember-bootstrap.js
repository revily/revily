(function() {
var Bootstrap = window.Bootstrap = Ember.Namespace.create();

})();



(function() {
var get = Ember.get;
var Bootstrap = window.Bootstrap;
var jQuery = window.jQuery;

var modalPaneTemplate = [
'<div class="modal-header">',
'  <a href="#" class="close" rel="close">&times;</a>',
'  {{view view.headerViewClass}}',
'</div>',
'<div class="modal-body">{{view view.bodyViewClass}}</div>',
'<div class="modal-footer">',
'  {{view view.footerViewClass}}',
'</div>'].join("\n");

var footerTemplate = [
'{{#if view.parentView.secondary}}<a href="#" class="btn btn-secondary" rel="secondary">{{view.parentView.secondary}}</a>{{/if}}',
'{{#if view.parentView.primary}}<a href="#" class="btn btn-primary" rel="primary">{{view.parentView.primary}}</a>{{/if}}'].join("\n");

var modalPaneBackdrop = '<div class="modal-backdrop"></div>';

Bootstrap.ModalPane = Ember.View.extend({
  classNames: 'modal',
  defaultTemplate: Ember.Handlebars.compile(modalPaneTemplate),
  heading: null,
  message: null,
  primary: null,
  secondary: null,
  showBackdrop: true,
  headerViewClass: Ember.View.extend({
    tagName: 'h3',
    template: Ember.Handlebars.compile('{{view.parentView.heading}}')
  }),
  bodyViewClass: Ember.View.extend({
    tagName: 'p',
    template: Ember.Handlebars.compile('{{{view.parentView.message}}}')
  }),
  footerViewClass: Ember.View.extend({
    template: Ember.Handlebars.compile(footerTemplate)
  }),

  didInsertElement: function() {
    if (get(this, 'showBackdrop')) this._appendBackdrop();
    this._setupDocumentKeyHandler();
  },

  willDestroyElement: function() {
    if (this._backdrop) this._backdrop.remove();
    this._removeDocumentKeyHandler();
  },

  keyPress: function(event) {
    if (event.keyCode === 27) {
      this._triggerCallbackAndDestroy({ close: true }, event);
    }
  },

  click: function(event) {
    var target = event.target,
        targetRel = target.getAttribute('rel');

    if (targetRel === 'close') {
      this._triggerCallbackAndDestroy({ close: true }, event);
      return false;

    } else if (targetRel === 'primary') {
      this._triggerCallbackAndDestroy({ primary: true }, event);
      return false;

    } else if (targetRel === 'secondary') {
      this._triggerCallbackAndDestroy({ secondary: true }, event);
      return false;
    }
  },

  _appendBackdrop: function() {
    var parentLayer = this.$().parent();
    this._backdrop = jQuery(modalPaneBackdrop).appendTo(parentLayer);
  },

  _setupDocumentKeyHandler: function() {
    var cc = this,
        handler = function(event) {
          cc.keyPress(event);
        };
    jQuery(window.document).bind('keyup', handler);
    this._keyUpHandler = handler;
  },

  _removeDocumentKeyHandler: function() {
    jQuery(window.document).unbind('keyup', this._keyUpHandler);
  },

  _triggerCallbackAndDestroy: function(options, event) {
    var destroy;
    if (this.callback) {
      destroy = this.callback(options, event);
    }
    if (destroy === undefined || destroy) this.destroy();
  }
});

Bootstrap.ModalPane.reopenClass({
  rootElement: ".ember-application",
  popup: function(options) {
    var modalPane, rootElement;
    if (!options) options = {};
    modalPane = this.create(options);
    rootElement = get(this, 'rootElement');
    modalPane.appendTo(rootElement);
    return modalPane;
  }
});


})();



(function() {
var get = Ember.get, set = Ember.set;
var Bootstrap = window.Bootstrap;

Bootstrap.TypeSupport = Ember.Mixin.create({
  baseClassName: Ember.required(String),
  classNameBindings: ['typeClass'],
  type: null, // success, warning, error, info || inverse
  typeClass: Ember.computed(function() {
    var type = get(this, 'type'),
        baseClassName = get(this, 'baseClassName');
    return type ? baseClassName + '-' + type : null;
  }).property('type').cacheable()
});

})();



(function() {
var get = Ember.get;
var Bootstrap = window.Bootstrap;

Bootstrap.AlertMessage = Ember.View.extend(Bootstrap.TypeSupport, {
  classNames: ['alert', 'alert-message'],
  baseClassName: 'alert',
  template: Ember.Handlebars.compile('<a class="close" rel="close" href="#">&times;</a>{{{view.message}}}'),
  message: null,
  removeAfter: null,

  didInsertElement: function() {
    var removeAfter = get(this, 'removeAfter');
    if (removeAfter > 0) {
      Ember.run.later(this, 'destroy', removeAfter);
    }
  },

  click: function(event) {
    var target = event.target,
        targetRel = target.getAttribute('rel');

    if (targetRel === 'close') {
      this.destroy();
      return false;
    }
  }
});

})();



(function() {
var Bootstrap = window.Bootstrap;

Bootstrap.BlockAlertMessage = Bootstrap.AlertMessage.extend({
  classNames: ['alert', 'alert-block']
});

})();



(function() {
var get = Ember.get;
var Bootstrap = window.Bootstrap;

Bootstrap.ItemViewValueSupport = Ember.Mixin.create({
  value: Ember.computed(function() {
    var parentView = get(this, 'parentView'),
        content, valueKey;
    if (!parentView) return null;
    content = get(this, 'content');
    valueKey = get(parentView, 'itemValueKey') || 'value';
    return get(content, valueKey) || content;
  }).property('content').cacheable()
});

})();



(function() {
var get = Ember.get, 
    Bootstrap = window.Bootstrap;

Bootstrap.ItemViewTitleSupport = Ember.Mixin.create({
  title: Ember.computed(function() {
    var parentView = get(this, 'parentView'),
        content, 
        titleKey;

    content = get(this, 'content');
    if (parentView) {
      titleKey = get(parentView, 'itemTitleKey') || 'title';

      return get(content, titleKey) || content;
    }

    return content;
  }).property('content').cacheable()
});

})();



(function() {
var get = Ember.get, set = Ember.set;
var Bootstrap = window.Bootstrap;

Bootstrap.ItemSelectionSupport = Ember.Mixin.create(Bootstrap.ItemViewValueSupport, Bootstrap.ItemViewTitleSupport, {
  classNameBindings: ["isActive:active"],
  allowsEmptySelection: false,

  isActive: Ember.computed(function() {
    var parentView = get(this, 'parentView'),
    selection, value;
    if (!parentView) return false;
    selection = get(parentView, 'selection');
    value = get(this, 'value');
    return selection === value;
  }).property('parentView.selection', 'value').cacheable(),

  click: function(event) {
    var value = get(this, 'value'),
    parentView = get(this, 'parentView'),
    allowsEmptySelection = get(parentView, 'allowsEmptySelection'),
    selection = get(parentView, 'selection');
    if (allowsEmptySelection === true && selection === value) {
      value = null;
    }
    set(parentView, 'selection', value);
    return true;
  }
});

})();



(function() {
var get = Ember.get;
var Bootstrap = window.Bootstrap;

Bootstrap.ItemViewHrefSupport = Ember.Mixin.create({
  href: Ember.computed(function() {
    var parentView = get(this, 'parentView'),
        content, hrefKey;
    content = get(this, 'content');
    if (parentView) {
      hrefKey = get(parentView, 'itemHrefKey') || 'link';
      return get(content, hrefKey) || '#';
    }
    return content;
  }).property('content').cacheable()
});

})();



(function() {
var Bootstrap = window.Bootstrap;
Bootstrap.PillItem = Ember.View.extend(Bootstrap.ItemSelectionSupport, Bootstrap.ItemViewHrefSupport, {
  template: Ember.Handlebars.compile('{{view view.item}}'),

  item: Ember.View.extend({
    tagName: 'a',
    template: Ember.Handlebars.compile('{{view.parentView.title}}'),
    attributeBindings: ['href'],
    hrefBinding: 'parentView.href'
  })
});

})();



(function() {
var Bootstrap = window.Bootstrap;
Bootstrap.Pills = Ember.CollectionView.extend({
  classNames: ['nav', 'nav-pills'],
  classNameBindings: ['isStacked:nav-stacked'],
  tagName: 'ul',
  itemViewClass: Bootstrap.PillItem,
  selection: null
});

})();



(function() {
var Bootstrap = window.Bootstrap;
Bootstrap.Tabs = Ember.CollectionView.extend({
  classNames: ['nav', 'nav-tabs'],
  classNameBindings: ['isStacked:nav-stacked'],
  tagName: 'ul',
  itemViewClass: Bootstrap.PillItem,
  selection: null
});

})();



(function() {
var Bootstrap = window.Bootstrap;
Bootstrap.NavList = Ember.CollectionView.extend({
  classNames: ['nav', 'nav-list'],
  tagName: 'ul',
  itemViewClass: Bootstrap.PillItem,
  selection: null
});

})();



(function() {
var get = Ember.get;
var fmt = Ember.String.fmt;
var Bootstrap = window.Bootstrap;

Bootstrap.ProgressBar = Ember.View.extend({
  classNames: ['progress'],
  classNameBindings: ['isStriped:progress-striped', 'isAnimated:active'],
  template: Ember.Handlebars.compile('<div class="bar" {{bindAttr style="view.style"}}></div>'),
  isAnimated: false,
  isStriped: false,
  progress: 0,

  style: Ember.computed(function() {
    var progress = get(this, 'progress');
    
    return fmt('width:%@%;', [progress]);
  }).property('progress').cacheable()
});

})();



(function() {
var Bootstrap = window.Bootstrap;
Bootstrap.Badge = Ember.View.extend(Bootstrap.TypeSupport, {
  tagName: 'span',
  classNames: ['badge'],
  baseClassName: 'badge',
  template: Ember.Handlebars.compile('{{view.content}}')
});

})();



(function() {
var Bootstrap = window.Bootstrap;

Bootstrap.Label = Ember.View.extend(Bootstrap.TypeSupport, {
  tagName: 'span',
  classNames: ['label'],
  baseClassName: 'label',
  template: Ember.Handlebars.compile('{{view.content}}')
});

})();



(function() {
var get = Ember.get;
var Bootstrap = window.Bootstrap;

Bootstrap.Well = Ember.View.extend({
  template: Ember.Handlebars.compile('{{view.content}}'),
  classNames: 'well',
  content: null
});

})();



(function() {
var get = Ember.get, set = Ember.set, A = Ember.A;
var Bootstrap = window.Bootstrap;

Bootstrap.Pagination = Ember.CollectionView.extend({
  tagName: 'ul',
  classNames: ['pagination'],
  itemTitleKey: 'title',
  itemHrefKey: 'href',
  init: function() {
    this._super();
    if (!this.get('content')) {
      this.set('content', new A([]));
    }
  },
  itemViewClass: Ember.View.extend(Bootstrap.ItemSelectionSupport, Bootstrap.ItemViewHrefSupport, {
    classNameBindings: ['content.disabled'],
    template: Ember.Handlebars.compile('<a {{bindAttr href="view.href"}}>{{view.title}}</a>')
  })
});

})();



(function() {
var Bootstrap = window.Bootstrap;
Bootstrap.Pager = Ember.CollectionView.extend({
  tagName: 'ul',
  classNames: ['pager'],
  itemTitleKey: 'title',
  itemHrefKey: 'href',
  init: function() {
    this._super();
    if (!this.get('content')) {
      this.set('content', Ember.A([
                                  Ember.Object.create({ title: '&larr;' }), 
                                  Ember.Object.create({ title: '&rarr;' })
      ]));
    }
  },
  itemViewClass: Ember.View.extend(Bootstrap.ItemViewTitleSupport, Bootstrap.ItemViewHrefSupport, {
    classNameBindings: ['content.next', 'content.previous', 'content.disabled'],
    template: Ember.Handlebars.compile('<a {{bindAttr href="view.href"}}>{{{view.title}}}</a>')
  }),
  arrayDidChange: function(content, start, removed, added) {
    if (content) {
      Ember.assert('content must always has at the most 2 elements', content.get('length') <= 2);
    }
    return this._super(content, start, removed, added);
  }
});

})();



(function() {
var get = Ember.get;
var Bootstrap = window.Bootstrap;

Bootstrap.FirstLastViewSupport = Ember.Mixin.create({
  createChildView: function(view, attrs) {
    var content;

    if (attrs) {
      content = get(this, 'content');

      if (attrs.contentIndex === 0) {
        view = get(this, 'firstItemViewClass') || view;
      }
      if (attrs.contentIndex === (get(content, 'length') - 1)) {
        view = get(this, 'lastItemViewClass') || view;
      }
    }
    return this._super(view, attrs);
  }
});

})();



(function() {
var get = Ember.get;
var Bootstrap = window.Bootstrap;

Bootstrap.Breadcrumb = Ember.CollectionView.extend(Bootstrap.FirstLastViewSupport, {
  tagName: 'ul',
  classNames: ['breadcrumb'],
  divider: '/',
  arrayDidChange: function(content, start, removed, added) {
    var view, 
        index, 
        length,
        item,
        lastItemViewClass = get(this, 'lastItemViewClass'),
        itemViewClass = get(this, 'itemViewClass'),
        lastView;

    this._super.apply(this, arguments);

    if (!content)
      return;

    length = get(content, 'length');

    if (removed) {
      lastView = get(this, 'childViews.lastObject');

      if (lastItemViewClass.detectInstance(lastView))
        return;

      index = length - 1;

      view = this.createChildView(lastItemViewClass, {
        content: content[index],
        contentIndex: index
      });

      this.replace(index, 1, [view]);
    }

    if (added) {
      get(this, 'childViews').forEach(function(childView, index) {
        if (lastItemViewClass.detectInstance(childView) && index !== length - 1) {
          view = this.createChildView(itemViewClass, {
            content: content[index],
            contentIndex: index
          });

          this.replace(index, 1, [view]);
        }
      }, this);

    }

  },
  itemViewClass: Ember.View.extend(Bootstrap.ItemViewTitleSupport, {
    template: Ember.Handlebars.compile('<a href="#">{{view.title}}</a><span class="divider">{{view.parentView.divider}}</span>')
  }),
  lastItemViewClass: Ember.View.extend(Bootstrap.ItemViewTitleSupport, {
    classNames: ['active'],
    template: Ember.Handlebars.compile('{{view.title}}')
  })
});

// 1 2 3 
// 1 2 3 4 5 6
// [] 3 0 3

// 1 2 3 
// 1 2 3 4
// [] 3 0 1





})();



(function() {
window.Bootstrap.Forms = Ember.Namespace.create({

  human: function(value) {
    if (value === undefined || value === false)
      return;

    // Underscore string
    value = Ember.String.decamelize(value);
    // Replace all _ with spaces
    value = value.replace(/_/g, " ");
    // Capitalize the first letter of every word
    value = value.replace(/(^|\s)([a-z])/g, function(m,p1,p2){ return p1+p2.toUpperCase(); });
    return value;
  }
});

})();



(function() {
var Bootstrap = window.Bootstrap;
Bootstrap.Forms.Field = Ember.View.extend({
  tagName: 'div',
  classNames: ['control-group'],
  labelCache: undefined,
  help: undefined,
  template: Ember.Handlebars.compile([
    '{{view view.labelView viewName="labelView"}}',
    '<div class="controls">',
    '  {{view view.inputField viewName="inputField"}}',
    '  {{view view.errorsView}}',
    '  {{view view.helpView}}',
    '</div>'].join("\n")),

  label: Ember.computed(function(key, value) {
    if(arguments.length === 1){
      if(this.get('labelCache') === undefined){
        var path = this.get('valueBinding._from');
        if (path) {
          path = path.split(".");
          return path[path.length - 1];
        }
      } else {
        return this.get('labelCache');
      }
    } else {
      this.set('labelCache', value);
      return value;
    }
  }).property(),

  labelView: Ember.View.extend({
    tagName: 'label',
    classNames: ['control-label'],
    template: Ember.Handlebars.compile('{{view.value}}'),

    value: Ember.computed(function(key, value) {
      var parent = this.get('parentView');

      if (value && value !== parent.get('label')) {
        parent.set('label', value);
      } else {
        value = parent.get('label');
      }

      // If the labelCache property is present on parent, then the
      // label was set manually, and there's no need to humanise it.
      // Otherwise, it comes from the binding and needs to be
      // humanised.
      return parent.get('labelCache') === undefined || parent.get('labelCache') === false ?
        Bootstrap.Forms.human(value) : value;
    }).property('parentView.label'),

    inputElementId: 'for',
    forBinding: 'inputElementId',
    attributeBindings: ['for']
  }),

  inputField: Ember.View.extend({
    classNames: ['ember-bootstrap-extend'],
    tagName: 'div',
    template: Ember.Handlebars.compile('This class is not meant to be used directly, but extended.')
  }),

  errorsView: Ember.View.extend({
    tagName: 'div',
    classNames: ['errors', 'help-inline'],

    _updateContent: Ember.observer(function() {
      var parent = this.get('parentView');

      if (parent !== null) {
        var binding = parent.get('valueBinding._from');
        var fieldName = null;
        var object = null;

        if (binding) {
          binding = binding.replace("_parentView.", "").split(".");
          fieldName = binding[binding.length - 1];
          object = parent.get(binding.slice(0, binding.length-1).join('.'));
        } else {
          fieldName = parent.get('label');
          object = parent.get('context');
        }

        if (object && !object.get('isValid')) {
          var errors = object.get('errors');

          if (errors && fieldName in errors && !Ember.isEmpty(errors[fieldName])) {
            parent.$().addClass('error');
            this.$().html(errors[fieldName].join(', '));
          } else {
            parent.$().removeClass('error');
            this.$().html('');
          }
        } else {
          parent.$().removeClass('error');
          this.$().html('');
        }
      }
    }, 'parentView.context.isValid', 'parentView.label')
  }),

  helpView: Ember.View.extend({
    tagName: 'div',
    classNames: ['help-block'],
    template: Ember.Handlebars.compile('{{view.content}}'),
    contentBinding: 'parentView.help'
  }),

  didInsertElement: function() {
    this.set('labelView.inputElementId', this.get('inputField.elementId'));
  }
});

})();



(function() {
var Bootstrap = window.Bootstrap;

Bootstrap.Forms.Select = Bootstrap.Forms.Field.extend({
  optionLabelPath: 'content',
  optionValuePath: 'content',

  inputField: Ember.Select.extend({
    contentBinding:         'parentView.content',

    optionLabelPathBinding: 'parentView.optionLabelPath',
    optionValuePathBinding: 'parentView.optionValuePath',

    valueBinding:           'parentView.value',
    selectionBinding:       'parentView.selection',
    promptBinding:          'parentView.prompt',
    multipleBinding:        'parentView.multiple',
    disabledBinding:        'parentView.disabled',
    classNameBindings:      ['parentView.inputClassNames'],
    name: Ember.computed(function() {
      return this.get('parentView.name') || this.get('parentView.label');
    }).property('parentView.name', 'parentView.label')    
  })
});

})();



(function() {
var get = Ember.get;
var Bootstrap = window.Bootstrap;

Bootstrap.TextSupport = Ember.Mixin.create({
  valueBinding: 'parentView.value',
  placeholderBinding: 'parentView.placeholder',
  disabledBinding: 'parentView.disabled',
  maxlengthBinding: 'parentView.maxlength',
  classNameBindings: 'parentView.inputClassNames',
  attributeBindings: ['name'],
  name: Ember.computed(function() {
    return get(this, 'parentView.name') || get(this, 'parentView.label');
  }).property('parentView.name', 'parentView.label').cacheable()
});

})();



(function() {
var Bootstrap = window.Bootstrap;
Bootstrap.Forms.TextArea = Bootstrap.Forms.Field.extend({

  inputField: Ember.TextArea.extend(Bootstrap.TextSupport, {
    rowsBinding: 'parentView.rows',
    colsBinding: 'parentView.cols' 
  })
});

})();



(function() {
var Bootstrap = window.Bootstrap;
Bootstrap.Forms.TextField = Bootstrap.Forms.Field.extend({
  type: 'text',

  inputField: Ember.TextField.extend(Bootstrap.TextSupport, {
    typeBinding: 'parentView.type',
    sizeBinding: 'parentView.size'
  })
});

})();



(function() {
var Bootstrap = window.Bootstrap;
Bootstrap.Forms.Checkbox = Bootstrap.Forms.Field.extend({

  inputField: Ember.Checkbox.extend({
    attributeBindings: ['name'],
    checkedBinding:   'parentView.checked',
    disabledBinding: 'parentView.disabled',
    classNameBindings: ['parentView.inputClassNames'],
    name: Ember.computed(function() {
      return this.get('parentView.name') || this.get('parentView.label');
    }).property('parentView.name', 'parentView.label')
  })
});
})();



(function() {
var Bootstrap = window.Bootstrap;
Bootstrap.Forms.UneditableInput = Bootstrap.Forms.Field.extend({

  inputField: Ember.View.extend({
    tagName: 'span',
    classNames: ['uneditable-input'],
    attributeBindings: ['name'],
    template: Ember.Handlebars.compile('{{view.value}}'),

    valueBinding:   'parentView.value',
    classNameBindings: ['parentView.inputClassNames'],
    name: Ember.computed(function() {
      return this.get('parentView.name') || this.get('parentView.label');
    }).property('parentView.name', 'parentView.label')
  })
});
})();



(function() {

})();

