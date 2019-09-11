
customElements.define(
  "oembed-element",
  class extends HTMLElement {
    constructor() {
      super();

    }

    connectedCallback() {
      // console.log('url', this.getAttribute('url'));
      const urlAttr = this.getAttribute('url')
      const maxwidth = this.getAttribute('maxwidth')
      const maxheight = this.getAttribute('maxheight')
      console.log('url', urlAttr);
      let shadow = this.attachShadow({ mode: "closed" });

      let apiUrl =
      new URL(
        `https://cors-anywhere.herokuapp.com/${urlAttr}`)
        if (maxwidth) {
          apiUrl.searchParams.set('maxwidth', maxwidth);
        }
        if (maxheight) {
          apiUrl.searchParams.set('maxheight', maxheight);
        }
      apiUrl = apiUrl.toString()
      let xmlHttp = new XMLHttpRequest();
      xmlHttp.open("GET", apiUrl, false);
      xmlHttp.send(null);
      const response = JSON.parse(xmlHttp.responseText);
      console.log('RESPONSE!', response);



      let iframe;
      switch (response.type) {
        case 'rich':
        iframe = createIframe(response);
        shadow.appendChild(iframe);

        setTimeout(() => {
          if (!response.height) {
            shadow.querySelector('iframe').setAttribute('height', iframe.contentWindow.document.body.scrollHeight + 10)
          }
          if (!response.width) {
            shadow.querySelector('iframe').setAttribute('width', iframe.contentWindow.document.body.scrollWidth + 10)
          }
        }, 1000)
          break;
        case 'video':
          iframe = createIframe(response)
          shadow.appendChild(iframe);

          setTimeout(() => {
            if (!response.height) {
              // console.log('VIDEO', iframe.contentWindow.document.body.scrollHeight + 110)
              shadow.querySelector('iframe').setAttribute('height', iframe.contentWindow.document.body.scrollHeight + 10)
            }
            if (!response.width) {
              shadow.querySelector('iframe').setAttribute('width', iframe.contentWindow.document.body.scrollWidth + 10)
            }
          }, 1000)
          break;
        case 'photo':
          let img = document.createElement("img");
          img.setAttribute('src', response.url)
          img.setAttribute('style', `max-width: ${maxwidth}px; max-height: ${maxheight}px;`)
          shadow.appendChild(img)
        break;
        default:
        break;

      }


    }
  }
);

function createIframe(response) {
  let iframe = document.createElement("iframe");
  iframe.setAttribute('border', '0')
  iframe.setAttribute('frameborder', '0')
  iframe.setAttribute('height', (response.height || 500) + 20)
  iframe.setAttribute('width', (response.width || 500) + 20)
  iframe.srcdoc = response.html;
  return iframe;
}
