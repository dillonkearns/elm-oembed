customElements.define(
  "oembed-element",
  class extends HTMLElement {
    connectedCallback() {
      let shadow = this.attachShadow({ mode: "closed" });
      const urlAttr = this.getAttribute("url");
      if (urlAttr) {
        renderOembed(shadow, urlAttr, {
          maxwidth: this.getAttribute("maxwidth"),
          maxheight: this.getAttribute("maxheight")
        });
      } else {
        const discoverUrl = this.getAttribute("discover-url");
        if (discoverUrl) {
          getDiscoverUrl(discoverUrl, function(discoveredUrl) {
            renderOembed(shadow, discoveredUrl, null);
          });
        }
      }
    }
  }
);

/**
 *
 * @param {ShadowRoot} shadow
 * @param {string} urlToEmbed
 * @param {{maxwidth: string?; maxheight: string?}?} options
 */
function renderOembed(shadow, urlToEmbed, options) {
  let apiUrlBuilder = new URL(
    `https://cors-anywhere.herokuapp.com/${urlToEmbed}`
  );
  if (options && options.maxwidth) {
    apiUrlBuilder.searchParams.set("maxwidth", options.maxwidth);
  }
  if (options && options.maxheight) {
    apiUrlBuilder.searchParams.set("maxheight", options.maxheight);
  }
  const apiUrl = apiUrlBuilder.toString();
  httpGetAsync(apiUrl, (/** @type {Object} */ rawResponse) => {
    const response = JSON.parse(rawResponse);

    /** @type {HTMLIFrameElement} */ let iframe;
    switch (response.type) {
      case "rich":
        iframe = createIframe(response);
        shadow.appendChild(iframe);

        setTimeout(() => {
          if (!response.height) {
            shadow
              .querySelector("iframe")
              .setAttribute(
                "height",
                iframe.contentWindow.document.body.scrollHeight + 10
              );
          }
          if (!response.width) {
            shadow
              .querySelector("iframe")
              .setAttribute(
                "width",
                iframe.contentWindow.document.body.scrollWidth + 10
              );
          }
        }, 1000);
        break;
      case "video":
        iframe = createIframe(response);
        shadow.appendChild(iframe);

        setTimeout(() => {
          if (!response.height) {
            shadow
              .querySelector("iframe")
              .setAttribute(
                "height",
                iframe.contentWindow.document.body.scrollHeight + 10
              );
          }
          if (!response.width) {
            shadow
              .querySelector("iframe")
              .setAttribute(
                "width",
                iframe.contentWindow.document.body.scrollWidth + 10
              );
          }
        }, 1000);
        break;
      case "photo":
        let img = document.createElement("img");
        img.setAttribute("src", response.url);
        if (options) {
          img.setAttribute(
            "style",
            `max-width: ${options.maxwidth}px; max-height: ${options.maxheight}px;`
          );
        }
        shadow.appendChild(img);
        break;
      default:
        break;
    }
  });
}

/**
 * @param {{ height: number?; width: number?; html: string; }} response
 */
function createIframe(response) {
  let iframe = document.createElement("iframe");
  iframe.setAttribute("border", "0");
  iframe.setAttribute("frameborder", "0");
  iframe.setAttribute("height", ((response.height || 500) + 20).toString());
  iframe.setAttribute("width", ((response.width || 500) + 20).toString());
  iframe.srcdoc = response.html;
  return iframe;
}

/**
 * @param {string} url
 * @param {{ (discoveredUrl: string): void;}} callback
 */
function getDiscoverUrl(url, callback) {
  let apiUrl = new URL(`https://cors-anywhere.herokuapp.com/${url}`).toString();
  httpGetAsync(apiUrl, function(response) {
    let dom = document.createElement("html");
    dom.innerHTML = response;
    const oembedUrl = dom.querySelector('link[type="application/json+oembed"]')
      .href;
    callback(oembedUrl);
  });
}

/**
 * @param {string} theUrl
 * @param {{ (rawResponse: string): void }} callback
 */
function httpGetAsync(theUrl, callback) {
  var xmlHttp = new XMLHttpRequest();
  xmlHttp.onreadystatechange = function() {
    if (xmlHttp.readyState == 4 && xmlHttp.status == 200)
      callback(xmlHttp.responseText);
  };
  xmlHttp.open("GET", theUrl, true); // true for asynchronous
  xmlHttp.send(null);
}
