
customElements.define(
  "oembed-element",
  class extends HTMLElement {
    constructor() {
      super();
      let shadow = this.attachShadow({ mode: "closed" });

      const apiUrl =
        "https://cors-anywhere.herokuapp.com/https://publish.twitter.com/oembed?url=https%3A%2F%2Ftwitter.com%2Fdillontkearns%2Fstatus%2F1105250778233491456";
      let xmlHttp = new XMLHttpRequest();
      xmlHttp.open("GET", apiUrl, false);
      xmlHttp.send(null);
      const response = JSON.parse(xmlHttp.responseText);
      console.log('RESPONSE!', response);

      let iframe = document.createElement("iframe");
      iframe.setAttribute('border', '0')
      iframe.setAttribute('frameborder', '0')
      iframe.setAttribute('height', response.height || 500)
      iframe.setAttribute('width', response.width || 500)
      window.iframe = iframe

      iframe.srcdoc = response.html;
      shadow.appendChild(iframe)
      setTimeout(() => {
        shadow.querySelector('iframe').setAttribute('height', iframe.contentWindow.document.body.scrollHeight + 10)
      }, 1000)

    }

    connectedCallback() {
    }
  }
);
