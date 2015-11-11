(function (root, factory) {
  if (typeof define === 'function') {
    define(['server','lodash'], factory);
  } else if (typeof exports === 'object') {
    module.exports = factory();
  } else {
    root.user = factory();
  }
}(this, function () {