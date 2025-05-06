import { Controller } from "@hotwired/stimulus";
import { get, post } from "@rails/request.js";

export default class extends Controller {
  CALCULATE_PRICES_URL = '/backoffice/catalogs_management/products/calculate_prices';
  CALCULATE_PROFIT_PRICE_URL = '/backoffice/catalogs_management/products/{0}/calculate_profit_price/{1}';
  CONTENT_TYPE = 'application/json';
  RESPONSE_KIND = 'json';

  static targets = [
    "productElement",
    "checkboxElement",
    "suggestedPriceElement",
    "basePriceElement",
    "stockElement",
    "profitRateElement",
    "totalItemsElement",
    "quantityElement",
    "unitElement"]

  connect() {
    this.element.addEventListener("turbo:before-fetch-response", () => {
      const TIMER = 500;
      setTimeout(async () => this.calculatePrices(), TIMER);
    })
  }

  async calculatePrices() {
    if (this.isInvalidToProceed()) {
      return;
    }

    const response = await this.getCalculatedPrices();

    this.suggestedPriceElementTarget.value = response.suggested_price;
    this.basePriceElementTarget.value = response.cost_price;
  }

  async calculateProfitPrice() {
    if (!this.hasCheckboxTarget) {
      return
    }

    for (let index = 0; index < this.checkboxTargets.length; index++) {
      const checkBoxValue = this.checkboxTargets[index].checked;
      const profitRateValue = Number(this.profitRateElementTargets[index].value);
      const productValue = Number(this.productElementTargets[index].value);

      if ((profitRateValue === 0 || productValue === 0) && !checkBoxValue) {
        return
      }

      const calculatedPrice = await this.getProfitPrice(productValue, profitRateValue);

      this.suggestedPriceElementTargets[index].value = calculatedPrice.price;
    }
  }

  async getProfitPrice(productValue, profitRateValue) {
    const response = await get(this.format(this.CALCULATE_PROFITS_PRICE_URL, productValue, profitRateValue), {
      contentType: this.CONTENT_TYPE,
      responseKind: this.RESPONSE_KIND,
    });

    if (!response.ok) {
      console.error("An error happens during the request processing", await response.text);
      return '0';
    }

    return await response.json;
  }

  async getCalculatedPrices() {
    const body = this.buildRequest();

    const response = await post(this.CALCULATE_PRICES_URL, {
      contentType: this.CONTENT_TYPE,
      responseKind: this.RESPONSE_KIND,
      body: body
    });

    if (!response.ok) {
      console.error("An error happens during the request processing", await response.text);
      return { suggested_price: '0', cost_price: '0' }
    }

    return await response.json;
  }

  isInvalidToProceed() {
    return !this.hasProfitRateElementTarget ||
      !this.hasTotalItemsElementTarget ||
      !this.stockElementTargets.every(si => si.value) ||
      !this.quantityElementTargets.every(si => si.value) ||
      !this.unitElementTargets.every(si => si.value)
  }

  buildRequest() {
    const items = [];

    for (let index = 0; index < this.stockElementTargets.length; index++) {
      items.push({
        stock_id: Number(this.stockElementTargets[index].value),
        measure: {
          quantity: Number(this.quantityElementTargets[index].value),
          unit_id: Number(this.unitElementTargets[index].value)
        }
      });
    }

    return {
      product: {
        profit_rate: Number(this.profitRateElementTarget.value),
        total_items: Number(this.totalItemsElementTarget.value),
        items: items
      }
    };
  }

  format(template, ...args) {
    return template.replace(/{(\d+)}/g, (match, index) => {
      return typeof args[index] !== 'undefined' ? args[index] : match;
    });
  }
}