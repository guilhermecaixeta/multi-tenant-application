import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    Array.from(document.querySelectorAll('[data-coreui="navigation"]')).forEach(
      (node) => coreui.Navigation.navigationInterface(node)
    );
  }

  disconnect() {
    Array.from(document.querySelectorAll('[data-coreui="navigation"]')).forEach(
      (node) => coreui.Navigation.getOrCreateInstance(node).dispose()
    );
  }
}
