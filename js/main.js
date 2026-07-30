/* ==========================================================================
   Driftiq, interaktion
   Håller sig avsiktligt liten: sticky-tillstånd, mobilmeny, avslöjande vid
   scroll, årtal i sidfot och validering av kontaktformuläret.
   ========================================================================== */
(function () {
  'use strict';

  var reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  /* ---------------------------------------------------------------- Sidhuvud */
  var hdr = document.querySelector('.hdr');
  if (hdr) {
    var setStuck = function () {
      hdr.classList.toggle('is-stuck', window.scrollY > 8);
    };
    setStuck();
    window.addEventListener('scroll', setStuck, { passive: true });
  }

  /* -------------------------------------------------------------- Mobilmeny */
  var burger = document.querySelector('.burger');
  var sheet = document.querySelector('.sheet');

  if (burger && sheet) {
    var closeSheet = function () {
      burger.setAttribute('aria-expanded', 'false');
      burger.setAttribute('aria-label', 'Öppna meny');
      sheet.classList.remove('is-open');
      document.body.classList.remove('is-locked');
    };

    burger.addEventListener('click', function () {
      var open = burger.getAttribute('aria-expanded') === 'true';
      if (open) {
        closeSheet();
      } else {
        burger.setAttribute('aria-expanded', 'true');
        burger.setAttribute('aria-label', 'Stäng meny');
        sheet.classList.add('is-open');
        document.body.classList.add('is-locked');
      }
    });

    sheet.addEventListener('click', function (e) {
      if (e.target.closest('a')) closeSheet();
    });

    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape' && burger.getAttribute('aria-expanded') === 'true') {
        closeSheet();
        burger.focus();
      }
    });

    window.addEventListener('resize', function () {
      if (window.innerWidth >= 960) closeSheet();
    });
  }

  /* -------------------------------------------------- Avslöjande vid scroll */
  var targets = document.querySelectorAll('.rv');

  if (!targets.length) {
    /* inget att göra */
  } else if (reduceMotion || !('IntersectionObserver' in window)) {
    Array.prototype.forEach.call(targets, function (el) {
      el.classList.add('is-in');
    });
  } else {
    var io = new IntersectionObserver(
      function (entries) {
        entries.forEach(function (entry) {
          if (!entry.isIntersecting) return;
          entry.target.classList.add('is-in');
          io.unobserve(entry.target);
        });
      },
      { rootMargin: '0px 0px -12% 0px', threshold: 0.08 }
    );

    /* Trappa fördröjningen inom varje grupp av syskon. */
    Array.prototype.forEach.call(targets, function (el) {
      if (!el.style.getPropertyValue('--d') && el.parentElement) {
        var group = el.parentElement.children;
        var index = 0;
        for (var i = 0; i < group.length; i++) {
          if (group[i] === el) break;
          if (group[i].classList.contains('rv')) index++;
        }
        if (index > 0 && index <= 5) {
          el.style.setProperty('--d', index * 70 + 'ms');
        }
      }
      io.observe(el);
    });
  }

  /* ----------------------------------------------------------- År i sidfot */
  Array.prototype.forEach.call(document.querySelectorAll('[data-year]'), function (el) {
    el.textContent = String(new Date().getFullYear());
  });

  /* ------------------------------------------------------ Kontaktformulär
     Sajten är statisk. Sätt data-endpoint på <form> när ni har en mottagare
     (Formspree, Netlify Forms, egen funktion). Utan endpoint öppnas
     e-postklienten med ifyllt innehåll i stället, så inget svar tappas.
  ------------------------------------------------------------------------- */
  var form = document.querySelector('#kontaktformular');
  if (!form) return;

  var msg = form.querySelector('.form__msg');
  var endpoint = form.getAttribute('data-endpoint');
  var mailTo = form.getAttribute('data-mailto') || 'info@driftiq.se';

  var say = function (text, state) {
    if (!msg) return;
    msg.textContent = text;
    if (state) {
      msg.setAttribute('data-state', state);
    } else {
      msg.removeAttribute('data-state');
    }
  };

  var mark = function (field, invalid) {
    if (!field) return;
    if (invalid) {
      field.setAttribute('data-invalid', '');
    } else {
      field.removeAttribute('data-invalid');
    }
  };

  form.addEventListener('input', function (e) {
    var field = e.target.closest('.field');
    if (field && field.hasAttribute('data-invalid') && e.target.checkValidity()) {
      mark(field, false);
    }
  });

  form.addEventListener('submit', function (e) {
    e.preventDefault();

    var controls = form.querySelectorAll('input, textarea, select');
    var firstBad = null;

    Array.prototype.forEach.call(controls, function (el) {
      var ok = el.checkValidity();
      mark(el.closest('.field'), !ok);
      if (!ok && !firstBad) firstBad = el;
    });

    if (firstBad) {
      say('Kontrollera de markerade fälten.', 'err');
      firstBad.focus();
      return;
    }

    var data = new FormData(form);
    var get = function (k) {
      return String(data.get(k) || '').trim();
    };

    if (endpoint) {
      say('Skickar.');
      fetch(endpoint, {
        method: 'POST',
        headers: { Accept: 'application/json' },
        body: data
      })
        .then(function (res) {
          if (!res.ok) throw new Error(String(res.status));
          form.reset();
          say('Tack. Vi svarar inom en arbetsdag.', 'ok');
        })
        .catch(function () {
          say('Något gick fel. Mejla oss på ' + mailTo + ' i stället.', 'err');
        });
      return;
    }

    var lines = [
      'Namn: ' + get('namn'),
      'Företag: ' + get('foretag'),
      'Roll: ' + get('roll'),
      'E-post: ' + get('epost'),
      'Telefon: ' + get('telefon'),
      'Typ av behov: ' + get('behov'),
      '',
      get('meddelande')
    ];

    var href =
      'mailto:' +
      mailTo +
      '?subject=' +
      encodeURIComponent('Förfrågan via driftiq.se: ' + (get('foretag') || get('namn'))) +
      '&body=' +
      encodeURIComponent(lines.join('\n'));

    window.location.href = href;
    say('Din e-postklient öppnas med meddelandet ifyllt.', 'ok');
  });
})();
