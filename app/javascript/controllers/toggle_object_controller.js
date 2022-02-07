import { Controller } from "@hotwired/stimulus"

export default class ToggleObject extends Controller {
  static get targets() {
    return ['object']
  }

  toggle(event) {
    this.objectTarget.classList?.toggle('hidden')
  }
}
