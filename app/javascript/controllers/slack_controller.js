import { Controller } from "@hotwired/stimulus";

export default class Slack extends Controller {

    static get targets() {
      return ['search', 'channel', 'message']
    }

	connect() {}

  channel_search(channel){
    axios.get("/apps/channel_search.json", { params: {channel_params: channel}})
    .then(response => {

      this.searchTarget.innerHTML = ""

      let values = response.data

    })
  }

  sendMessage(event) {
    event.preventDefault();
    if (event.target.value.includes("@") ) {

    }
    console.log(event.keyCode)
    // else if (event.keyCode === 13) {
    //   event.target.closest('form').submit();
    // }

  }
}
