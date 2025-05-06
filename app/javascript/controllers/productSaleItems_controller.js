import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["element", "checkBox"]

    connect() {
        this.onCheckBoxChange();
    }

    onCheckBoxChange() {
        if (!this.hasCheckBoxTarget) {
            return
        }

        if (this.checkBoxTarget.checked) {
            this.elementTargets.forEach(element => {
                element.style.display = 'none';
                element.value = null;
            });
            return;
        }

        this.elementTargets.forEach(element => {
            element.style.display = 'block';
        });
    }
}