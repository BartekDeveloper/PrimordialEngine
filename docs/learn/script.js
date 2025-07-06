
// docs/learn/script.js

document.addEventListener('DOMContentLoaded', () => {
    console.log('Documentation loaded!');

    // Example: Simple animation on scroll for sections
    const sections = document.querySelectorAll('.container h1, .container h2, .container h3');

    const observerOptions = {
        root: null,
        rootMargin: '0px',
        threshold: 0.1
    };

    const observer = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('is-visible');
            } else {
                entry.target.classList.remove('is-visible');
            }
        });
    }, observerOptions);

    sections.forEach(section => {
        observer.observe(section);
    });

    // Add a class to code blocks for styling or future JS enhancements
    document.querySelectorAll('pre code').forEach(block => {
        block.classList.add('code-block');
    });

    // Smooth scroll for anchor links (if any are added later)
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();

            document.querySelector(this.getAttribute('href')).scrollIntoView({
                behavior: 'smooth'
            });
        });
    });
});
