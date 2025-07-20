import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "customField"]

  connect() {
    this.toggleCustomField()
  }

  change() {
    this.toggleCustomField()
  }

  toggleCustomField() {
    const isCustom = this.selectTarget.value === "custom"
    if (isCustom) {
      this.customFieldTarget.classList.remove("hidden")
    } else {
      this.customFieldTarget.classList.add("hidden")
    }
  }
}
