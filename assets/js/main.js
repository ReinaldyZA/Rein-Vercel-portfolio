(function () {
  // Hero: daily ISPU strip (Jakarta, highest reading across five stations)
  var box = document.getElementById("airstrip");
  if (box && window.ISPU_DAILY) {
    var data = window.ISPU_DAILY;
    var W = 1000, H = 190, top = 12, bottom = 22, maxV = 210;
    var ns = "http://www.w3.org/2000/svg";
    var svg = document.createElementNS(ns, "svg");
    svg.setAttribute("viewBox", "0 0 " + W + " " + H);
    svg.setAttribute("preserveAspectRatio", "none");
    svg.setAttribute("role", "img");
    svg.setAttribute("aria-label", "Daily air quality index for Jakarta from January 2024 to November 2025. 14 good days, 524 moderate days, 162 unhealthy days.");
    var plotH = H - top - bottom;
    var y = function (v) { return top + plotH - (v / maxV) * plotH; };
    var bw = W / data.length;
    var color = function (v) { return v <= 50 ? "var(--green)" : v <= 100 ? "var(--blue)" : "var(--amber)"; };
    var label = function (v) { return v <= 50 ? "Good" : v <= 100 ? "Moderate" : "Unhealthy"; };

    [50, 100].forEach(function (t) {
      var l = document.createElementNS(ns, "line");
      l.setAttribute("x1", 0); l.setAttribute("x2", W);
      l.setAttribute("y1", y(t)); l.setAttribute("y2", y(t));
      l.setAttribute("class", "thr");
      l.setAttribute("vector-effect", "non-scaling-stroke");
      svg.appendChild(l);
    });

    var bars = [];
    data.forEach(function (d, i) {
      var r = document.createElementNS(ns, "rect");
      r.setAttribute("x", (i * bw).toFixed(2));
      r.setAttribute("width", Math.max(bw - 0.35, 0.6).toFixed(2));
      r.setAttribute("y", y(d[1]).toFixed(2));
      r.setAttribute("height", (top + plotH - y(d[1])).toFixed(2));
      r.setAttribute("fill", color(d[1]));
      r.setAttribute("class", "bar");
      svg.appendChild(r);
      bars.push(r);
    });

    var chart = box.querySelector(".airstrip-chart");
    [[50, "50"], [100, "100"]].forEach(function (t) {
      var s = document.createElement("span");
      s.className = "thr-label";
      s.style.top = ((y(t[0]) / H) * 100) + "%";
      s.textContent = t[1];
      chart.appendChild(s);
    });
    data.forEach(function (d, i) {
      if (d[0].slice(5) === "01-01") {
        var s = document.createElement("span");
        s.className = "year-label";
        s.style.left = ((i / data.length) * 100) + "%";
        s.textContent = d[0].slice(0, 4);
        chart.appendChild(s);
      }
    });

    chart.appendChild(svg);
    var tip = document.createElement("div");
    tip.className = "air-tip";
    chart.appendChild(tip);

    var fmt = new Intl.DateTimeFormat("en-GB", { day: "numeric", month: "short", year: "numeric" });
    var last = null;
    function show(clientX) {
      var rect = svg.getBoundingClientRect();
      var i = Math.min(data.length - 1, Math.max(0, Math.floor(((clientX - rect.left) / rect.width) * data.length)));
      if (last !== null) bars[last].classList.remove("on");
      bars[i].classList.add("on");
      last = i;
      var d = data[i];
      tip.textContent = fmt.format(new Date(d[0] + "T00:00:00")) + ", ISPU " + d[1] + ", " + label(d[1]);
      var x = ((i + 0.5) / data.length) * rect.width;
      x = Math.min(Math.max(x, 90), rect.width - 90);
      tip.style.left = x + "px";
      tip.classList.add("show");
    }
    function hide() {
      if (last !== null) bars[last].classList.remove("on");
      last = null;
      tip.classList.remove("show");
    }
    svg.addEventListener("pointermove", function (e) { show(e.clientX); });
    svg.addEventListener("pointerleave", hide);
  }

  // Project filter
  var filters = document.querySelectorAll(".filters button");
  var items = document.querySelectorAll(".work-item");
  filters.forEach(function (b) {
    b.addEventListener("click", function () {
      var f = b.getAttribute("data-filter");
      filters.forEach(function (o) { o.setAttribute("aria-pressed", o === b ? "true" : "false"); });
      items.forEach(function (it) {
        var tools = it.getAttribute("data-tools").split(" ");
        it.hidden = !(f === "all" || tools.indexOf(f) !== -1);
      });
    });
  });

  // Slide lightbox
  var dlg = document.querySelector("dialog.lightbox");
  if (dlg) {
    var img = dlg.querySelector("img");
    document.querySelectorAll(".gallery button").forEach(function (b) {
      b.addEventListener("click", function () {
        var src = b.querySelector("img");
        img.src = src.src;
        img.alt = src.alt;
        dlg.showModal();
      });
    });
    dlg.querySelector("button").addEventListener("click", function () { dlg.close(); });
    dlg.addEventListener("click", function (e) { if (e.target === dlg) dlg.close(); });
  }
})();
