/* global coreui */

/**
 * --------------------------------------------------------------------------
 * CoreUI Boostrap Admin Template tooltips.js
 * Licensed under MIT (https://github.com/coreui/coreui-free-bootstrap-admin-template/blob/main/LICENSE)
 * --------------------------------------------------------------------------
 */
class Tooltips {}

for (const element of document.querySelectorAll('[data-coreui-toggle="tooltip"]')) {
  // eslint-disable-next-line no-new
  new coreui.Tooltip(element);
}

export default Tooltips;
//# sourceMappingURL=tooltips.js.map