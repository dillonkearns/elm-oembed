customElements.define(
  "oembed-element",
  class extends HTMLElement {
    connectedCallback() {
      let shadow = this.attachShadow({ mode: "closed" });
      const urlAttr = this.getAttribute("url");
      let urlToEmbed;
      if (urlAttr) {
        renderOembed(shadow, urlAttr, {
          maxwidth: this.getAttribute("maxwidth"),
          maxheight: this.getAttribute("maxheight")
        });
      } else {
        const discoverUrl = this.getAttribute("discover-url");
        if (discoverUrl) {
          const discoveredUrl = getDiscoverUrl(discoverUrl, function(
            discoveredUrl
          ) {
            renderOembed(shadow, discoveredUrl);
          });
        }
      }
    }
  }
);

function renderOembed(shadow, urlToEmbed, options) {
  let apiUrl = new URL(`https://cors-anywhere.herokuapp.com/${urlToEmbed}`);
  if (options && options.maxwidth) {
    apiUrl.searchParams.set("maxwidth", options.maxwidth);
  }
  if (options && options.maxheight) {
    apiUrl.searchParams.set("maxheight", options.maxheight);
  }
  apiUrl = apiUrl.toString();
  httpGetAsync(apiUrl, rawResponse => {
    response = JSON.parse(rawResponse);

    let iframe;
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

function createIframe(response) {
  let iframe = document.createElement("iframe");
  iframe.setAttribute("border", "0");
  iframe.setAttribute("frameborder", "0");
  iframe.setAttribute("height", (response.height || 500) + 20);
  iframe.setAttribute("width", (response.width || 500) + 20);
  iframe.srcdoc = response.html;
  return iframe;
}

function getDiscoverUrl(url, callback) {
  let apiUrl = new URL(`https://cors-anywhere.herokuapp.com/${url}`);
  apiUrl = apiUrl.toString();
  httpGetAsync(apiUrl, function(response) {
    let dom = document.createElement("html");
    dom.innerHTML = response;
    const oembedUrl = dom.querySelector('link[type="application/json+oembed"]')
      .href;
    callback(oembedUrl);
  });
}

function httpGetAsync(theUrl, callback) {
  var xmlHttp = new XMLHttpRequest();
  xmlHttp.onreadystatechange = function() {
    if (xmlHttp.readyState == 4 && xmlHttp.status == 200)
      callback(xmlHttp.responseText);
  };
  xmlHttp.open("GET", theUrl, true); // true for asynchronous
  xmlHttp.send(null);
}
