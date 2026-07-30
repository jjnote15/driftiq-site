/* =============================================================
   DRIFTIQ — site behaviour
   No dependencies. Everything degrades gracefully without JS.
   ============================================================= */

(function () {
  'use strict';

  var reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  /* -----------------------------------------------------------
     1. Masthead — hairline appears once the page has scrolled
     ----------------------------------------------------------- */
  (function masthead() {
    var head = document.querySelector('.masthead');
    if (!head) return;

    var ticking = false;
    function apply() {
      head.classList.toggle('is-stuck', window.scrollY > 8);
      ticking = false;
    }
    window.addEventListener('scroll', function () {
      if (!ticking) { ticking = true; window.requestAnimationFrame(apply); }
    }, { passive: true });
    apply();
  })();

  /* -----------------------------------------------------------
     2. Mobile drawer
     ----------------------------------------------------------- */
  (function drawer() {
    var burger = document.querySelector('.burger');
    var panel = document.querySelector('.drawer');
    if (!burger || !panel) return;

    function setOpen(open) {
      document.body.classList.toggle('nav-open', open);
      document.body.style.overflow = open ? 'hidden' : '';
      burger.setAttribute('aria-expanded', String(open));
      burger.setAttribute('aria-label', open ? 'Stäng meny' : 'Öppna meny');
    }

    burger.addEventListener('click', function () {
      setOpen(!document.body.classList.contains('nav-open'));
    });

    panel.addEventListener('click', function (e) {
      if (e.target.closest('a')) setOpen(false);
    });

    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape' && document.body.classList.contains('nav-open')) {
        setOpen(false);
        burger.focus();
      }
    });

    // Close the drawer if the viewport grows back to desktop
    window.matchMedia('(min-width: 881px)').addEventListener('change', function (e) {
      if (e.matches) setOpen(false);
    });
  })();

  /* -----------------------------------------------------------
     3. Reveal on scroll
     ----------------------------------------------------------- */
  (function reveal() {
    var items = document.querySelectorAll('[data-reveal]');
    if (!items.length) return;

    if (reduceMotion || !('IntersectionObserver' in window)) {
      items.forEach(function (el) { el.classList.add('is-in'); });
      return;
    }

    var io = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (!entry.isIntersecting) return;
        entry.target.classList.add('is-in');
        io.unobserve(entry.target);
      });
    }, { rootMargin: '0px 0px -8% 0px', threshold: 0.08 });

    items.forEach(function (el, i) {
      // Stagger siblings that share a parent, capped so nothing feels slow
      var siblings = el.parentElement ? el.parentElement.querySelectorAll(':scope > [data-reveal]') : [];
      var index = Array.prototype.indexOf.call(siblings, el);
      el.style.setProperty('--d', Math.min(index < 0 ? i : index, 5) * 70 + 'ms');
      io.observe(el);
    });
  })();

  /* -----------------------------------------------------------
     4. Hero field
     A sparse dot grid with outward "ping" rings — a quiet nod to
     monitoring a distributed estate. Painted at device pixel
     ratio, paused when off-screen or when the tab is hidden.
     ----------------------------------------------------------- */
  (function heroField() {
    var canvas = document.querySelector('.hero__canvas');
    if (!canvas || reduceMotion) return;

    var ctx = canvas.getContext('2d');
    if (!ctx) return;

    var SPACING = 26;
    var dots = [];
    var pings = [];
    var w = 0, h = 0, dpr = 1;
    var raf = null;
    var visible = true;

    function build() {
      var rect = canvas.getBoundingClientRect();
      dpr = Math.min(window.devicePixelRatio || 1, 2);
      w = rect.width;
      h = rect.height;
      canvas.width = Math.round(w * dpr);
      canvas.height = Math.round(h * dpr);
      ctx.setTransform(dpr, 0, 0, dpr, 0, 0);

      dots = [];
      var cols = Math.ceil(w / SPACING) + 1;
      var rows = Math.ceil(h / SPACING) + 1;
      for (var y = 0; y < rows; y++) {
        for (var x = 0; x < cols; x++) {
          dots.push({ x: x * SPACING, y: y * SPACING });
        }
      }
    }

    function spawn() {
      if (pings.length > 3) return;
      pings.push({
        x: Math.random() * w,
        y: Math.random() * h,
        r: 0,
        max: Math.max(w, h) * (0.45 + Math.random() * 0.35),
        // one in four pings carries the signal colour
        hot: Math.random() < 0.25
      });
    }

    var last = 0;
    var nextSpawn = 600;

    function frame(now) {
      raf = window.requestAnimationFrame(frame);
      if (!visible) return;

      var dt = last ? Math.min(now - last, 48) : 16;
      last = now;

      nextSpawn -= dt;
      if (nextSpawn <= 0) {
        spawn();
        nextSpawn = 1400 + Math.random() * 1800;
      }

      ctx.clearRect(0, 0, w, h);

      // advance rings
      for (var p = pings.length - 1; p >= 0; p--) {
        pings[p].r += dt * 0.075;
        if (pings[p].r > pings[p].max) pings.splice(p, 1);
      }

      for (var i = 0; i < dots.length; i++) {
        var d = dots[i];
        var lit = 0;
        var hot = 0;

        for (var j = 0; j < pings.length; j++) {
          var ping = pings[j];
          var dist = Math.hypot(d.x - ping.x, d.y - ping.y);
          var band = Math.abs(dist - ping.r);
          if (band > 44) continue;
          var strength = (1 - band / 44) * (1 - ping.r / ping.max);
          if (strength <= lit) continue;
          lit = strength;
          hot = ping.hot ? strength : 0;
        }

        var radius = 1 + lit * 1.5;
        ctx.beginPath();
        ctx.arc(d.x, d.y, radius, 0, Math.PI * 2);
        if (hot > 0.12) {
          ctx.fillStyle = 'rgba(255, 90, 31, ' + (0.16 + hot * 0.72).toFixed(3) + ')';
        } else {
          ctx.fillStyle = 'rgba(20, 24, 29, ' + (0.11 + lit * 0.38).toFixed(3) + ')';
        }
        ctx.fill();
      }
    }

    build();
    raf = window.requestAnimationFrame(frame);

    var resizeTimer;
    window.addEventListener('resize', function () {
      window.clearTimeout(resizeTimer);
      resizeTimer = window.setTimeout(build, 180);
    });

    document.addEventListener('visibilitychange', function () {
      visible = !document.hidden;
      last = 0;
    });

    if ('IntersectionObserver' in window) {
      new IntersectionObserver(function (entries) {
        visible = entries[0].isIntersecting && !document.hidden;
        last = 0;
      }, { threshold: 0 }).observe(canvas);
    }
  })();

  /* -----------------------------------------------------------
     5. Contact form
     Static site: no backend is wired up, so the form hands the
     message over to the visitor's own mail client rather than
     pretending to have sent it.
     ----------------------------------------------------------- */
  (function contactForm() {
    var form = document.querySelector('#kontaktformular');
    if (!form) return;

    var status = form.querySelector('.formstatus');

    form.addEventListener('submit', function (e) {
      e.preventDefault();
      if (!form.reportValidity()) return;

      var data = new FormData(form);
      var get = function (k) { return (data.get(k) || '').toString().trim(); };

      var subject = 'Förfrågan från ' + (get('foretag') || get('namn') || 'webbplatsen');
      var body = [
        'Namn: ' + get('namn'),
        'Företag: ' + get('foretag'),
        'E-post: ' + get('epost'),
        'Telefon: ' + (get('telefon') || '—'),
        'Gäller: ' + get('arende'),
        '',
        get('meddelande')
      ].join('\n');

      window.location.href = 'mailto:info@driftiq.se'
        + '?subject=' + encodeURIComponent(subject)
        + '&body=' + encodeURIComponent(body);

      if (status) {
        status.setAttribute('data-state', 'ok');
        status.textContent = 'Ditt e-postprogram öppnas med meddelandet ifyllt. '
          + 'Går det inte att öppna — mejla oss direkt på info@driftiq.se.';
      }
    });
  })();

  /* -----------------------------------------------------------
     6. Current year in the footer
     ----------------------------------------------------------- */
  Array.prototype.forEach.call(document.querySelectorAll('[data-year]'), function (el) {
    el.textContent = String(new Date().getFullYear());
  });
})();
