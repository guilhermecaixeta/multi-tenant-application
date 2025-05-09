/* global coreui */

/**
 * --------------------------------------------------------------------------
 * CoreUI Boostrap Admin Template popovers.js
 * Licensed under MIT (https://github.com/coreui/coreui-free-bootstrap-admin-template/blob/main/LICENSE)
 * --------------------------------------------------------------------------
 */
class Popovers {}
for (const element of document.querySelectorAll('[data-coreui-toggle="popover"]')) {
  // eslint-disable-next-line no-new
  new coreui.Popover(element);
}

export default Popovers;
//# sourceMappingURL=popovers.js.map