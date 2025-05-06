import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js";

// Connects to data-controller="drop-downs"
export default class extends Controller {
  static targets = ["ddlUrlUpdate", "ddlDestinationElement", "ddlSourceElement"]
  RESPONSE_KIND = 'turbo-stream';

  connect() {
    const TIMER = 500;
    setTimeout(async () => this.onLoad(), TIMER);
  }

  onLoad() {
    if (!this.ddlUrlUpdateTarget.value) return;

    if (!this.hasDdlDestinationElementTarget) return;
    if (!this.hasDdlSourceElementTarget) return;

    for (let index = 0; index < this.ddlSourceElementTargets.length; index++) {
      const selectedValue = this.ddlSourceElementTargets[index].value;
      const destinationId = this.ddlDestinationElementTargets[index].id;
      const destinationName = this.ddlDestinationElementTargets[index].name;
      const destinationValue = this.ddlDestinationElementTargets[index].value ?? 0;

      this.getTurboStream(selectedValue, destinationId, destinationName, destinationValue);
    }
  }

  turboStreamUpdate(event) {
    if (!event) return;
    const selectedValue = event.srcElement.value;
    const destinationId = event.params.destinationId;
    const destinationName = event.params.destinationName;
    const destinationValue = this.getValueFromDestinationTargetsOrDefault(destinationId);

    this.getTurboStream(selectedValue, destinationId, destinationName, destinationValue);
  }

  getTurboStream(selectedValue, destinationId, destinationName, destinationValue) {
    if (!this.ddlUrlUpdateTarget.value) return;

    if (!selectedValue || selectedValue <= 0) return;

    if (!destinationId || !destinationName) throw new Error('No destination item was found -- ddl');

    get(this.ddlUrlUpdateTarget.value, {
      query: {
        source_value: selectedValue,
        destination_id: destinationId,
        destination_name: destinationName,
        destination_value: destinationValue,
      },
      responseKind: this.RESPONSE_KIND,
    });
  }

  getValueFromDestinationTargetsOrDefault(destinationId) {
    return this.ddlDestinationElementTargets.find(ddl => ddl.id === destinationId)?.value ?? 0;
  }
}

