// Driftiq site interactions
(function () {
  const header = document.querySelector('.site-header');
  const onScroll = () => {
    if (window.scrollY > 24) header.classList.add('scrolled');
    else header.classList.remove('scrolled');
  };
  // Subpages with a light hero keep the solid header always "scrolled"
  if (header && header.dataset.solid === 'true') {
    header.classList.add('scrolled');
  } else if (header) {
    window.addEventListener('scroll', onScroll, { passive: true });
    onScroll();
  }

  // Mobile nav toggle
  const toggle = document.querySelector('.nav-toggle');
  const links = document.querySelector('.nav-links');
  if (toggle && links) {
    toggle.addEventListener('click', () => {
      links.classList.toggle('open');
    });
    links.querySelectorAll('a').forEach((a) =>
      a.addEventListener('click', () => links.classList.remove('open'))
    );
  }

  // Contact form (static demo)
  const form = document.querySelector('#contact-form');
  if (form) {
    form.addEventListener('submit', (e) => {
      e.preventDefault();
      const status = form.querySelector('.form-status');
      if (status) {
        status.textContent = 'Tack! Vi hör av oss inom kort. (Demo — formuläret skickas inte.)';
        status.style.color = '#2e7d4f';
      }
      form.reset();
    });
  }
})();
