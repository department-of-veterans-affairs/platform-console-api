import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

    static get targets() {
      return ['item']
    }

	connect() {
	  this.class = this.hasHiddenClass ? this.hiddenClass : 'hidden'
	}

    toggleTargets() {
      this.itemTargets.forEach(item => {
        item.classList.toggle(this.class)
      });
    }
}
