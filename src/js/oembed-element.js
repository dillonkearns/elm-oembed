
customElements.define(
  "oembed-element",
  class extends HTMLElement {
    constructor() {
      super();

    }

    connectedCallback() {
      // console.log('url', this.getAttribute('url'));
      const urlAttr = this.getAttribute('url')
      console.log('url', urlAttr);
      let shadow = this.attachShadow({ mode: "closed" });

      const apiUrl =
        `https://cors-anywhere.herokuapp.com/${urlAttr}`
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
        if (!response.height) {
          shadow.querySelector('iframe').setAttribute('height', iframe.contentWindow.document.body.scrollHeight + 10)
        }
        if (!response.width) {
          shadow.querySelector('iframe').setAttribute('height', iframe.contentWindow.document.body.scrollWidth + 10)
        }
      }, 1000)

    }
  }
);
