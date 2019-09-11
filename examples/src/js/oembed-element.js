
customElements.define(
  "oembed-element",
  class extends HTMLElement {
    constructor() {
      super();

    }

    connectedCallback() {
      const urlAttr = this.getAttribute('url')
      let maxwidth = null;
      let maxheight = null;
      let urlToEmbed;
      if (urlAttr) {
        urlToEmbed = urlAttr;
        maxwidth = this.getAttribute('maxwidth')
        maxheight = this.getAttribute('maxheight')
      } else {
        const discoverUrl = this.getAttribute('discover-url')
        if (discoverUrl) {
          const discoveredUrl = getDiscoverUrl(discoverUrl);
          urlToEmbed = discoveredUrl;
        }
      }

      let shadow = this.attachShadow({ mode: "closed" });

      let apiUrl =
      new URL(
        `https://cors-anywhere.herokuapp.com/${urlToEmbed}`)
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

function getDiscoverUrl(url) {
  let apiUrl = new URL(
    `https://cors-anywhere.herokuapp.com/${url}`)
  apiUrl = apiUrl.toString()
  let xmlHttp = new XMLHttpRequest();
  xmlHttp.open("GET", apiUrl, false);
  xmlHttp.send(null);
  let dom = document.createElement('html')
  dom.innerHTML = xmlHttp.responseText;
  const oembedUrl = dom.querySelector('link[type="application/json+oembed"]').href
  return oembedUrl;

}
