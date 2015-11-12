(function (root, factory) {
  if (typeof define === 'function') {
    define(['lodash'], factory);
  } else if (typeof exports === 'object') {
    module.exports = factory();
  } else {
    if (typeof root['snackkModule'] === 'undefined') {
        root['snackkModule'] = {
            'user': factory()
        };
    }
  }
}(this, function () {