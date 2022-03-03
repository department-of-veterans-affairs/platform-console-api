import { Controller } from "@hotwired/stimulus"

export default class extends Controller {


  connect() {
    if(this.data.get('callback') == 'true') {
      this.close()
    } else {
      this.oauth_url = this.data.get('oauth-url')
    }
   }

  open() {
    window.open(this.oauth_url,
                'popUpWindow',
                'height=700,width=500,left=200,top=300,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no, status=yes')
  }

  close() {
    window.opener.location.reload()
    window.close();
  }
}
