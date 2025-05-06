import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static sidebar;

  initialize() {
    const siderbarSel = document.querySelector('.sidebar');
    if (siderbarSel) {
      this.sidebar = new coreui.Sidebar(document.querySelector('.sidebar'))
    }
  }

  toggle() {
    this.sidebar.toggle()
  }
}
