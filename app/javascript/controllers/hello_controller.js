import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static get targets() {
    return ['name', 'output']
  }

  initialize() {
    console.log("Hello Controller Initialized!");
  }

  greet() {
    alert(`Hello, ${this.nameTarget.value}!`);
  }
}
