<!DOCTYPE html>
<html lang="sv">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HEMSIDAN - NAMNET | Oljemåleri & Porträtt</title>
    <!-- Google Fonts för elegant galleristil -->
    <link rel="preconnect" href="https://googleapis.com">
    <link rel="preconnect" href="https://gstatic.com" crossorigin>
    <link href="https://googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,600;1,400&family=Inter:wght@300;400;500&display=swap" rel="stylesheet">
    <!-- Supabase JS CDN -->
    <script src="https://jsdelivr.net"></script>
    <!-- Cloudflare Turnstile Skript -->
    <script src="https://cloudflare.com" async defer></script>
    
    <style>
        :root {
            --bg-color: #f9f9f9;
            --text-color: #1a1a1a;
            --accent-color: #c5a880; /* Dämpad guld */
            --accent-hover: #a3875f;
            --card-bg: #ffffff;
            --font-serif: 'Cormorant Garamond', Georgia, serif;
            --font-sans: 'Inter', sans-serif;
            --gap-large: 4rem;
            --gap-medium: 2rem;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: var(--font-sans);
            background-color: var(--bg-color);
            color: var(--text-color);
            line-height: 1.6;
            overflow-x: hidden;
            position: relative;
        }

        /* Bakgrundsbild med 30% opacitet enligt krav */
        body::before {
            content: "";
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background-image: url('bakgrund.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            opacity: 0.3;
            z-index: -1;
        }

        h1, h2, h3, .logo {
            font-family: var(--font-serif);
            font-weight: 600;
            letter-spacing: 0.5px;
        }

        a {
            color: inherit;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        /* Header & Navigation */
        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1.5rem 5%;
            background-color: rgba(249, 249, 249, 0.9);
            position: sticky;
            top: 0;
            z-index: 100;
            border-bottom: 1px solid rgba(0,0,0,0.05);
        }

        .logo {
            font-size: 1.5rem;
            text-transform: uppercase;
        }

        .nav-links {
            display: flex;
            list-style: none;
            gap: 2rem;
        }

        .nav-links a:hover, .nav-links a.active {
            color: var(--accent-color);
        }

        /* Hamburger Menu (CSS Hack) */
        .menu-btn, #menu-toggle {
            display: none;
        }

        /* Sektioner Baslayout */
        section {
            padding: 5rem 5%;
            max-width: 1200px;
            margin: 0 auto;
            display: none; /* Styrs via JS flikar */
        }

        section.active-section {
            display: block;
            animation: fadeIn 0.5s ease forwards;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .section-title {
            font-size: 2.5rem;
            margin-bottom: var(--gap-medium);
            text-align: center;
            position: relative;
            padding-bottom: 0.5rem;
        }

        .section-title::after {
            content: "";
            position: absolute;
            bottom: 0; left: 50%;
            transform: translateX(-50%);
            width: 50px; height: 1px;
            background-color: var(--accent-color);
        }

        /* Meny: Hem & Om mig */
        .hero {
            text-align: center;
            padding: 3rem 0 var(--gap-large) 0;
        }

        .hero h1 { font-size: 4rem; line-height: 1.1; }
        .hero p { font-size: 1.5rem; color: #555; font-style: italic; margin-top: 0.5rem; }

        .about-container {
            display: flex;
            gap: var(--gap-large);
            align-items: center;
            margin-top: var(--gap-medium);
        }

        .about-text {
            flex: 1;
            font-size: 1.05rem;
            text-align: justify;
        }

        /* Meny: Beställa Porträtt */
        .order-container {
            max-width: 800px;
            margin: 0 auto;
            text-align: center;
        }
        .order-text {
            font-size: 1.15rem;
            margin-bottom: var(--gap-medium);
            text-align: justify;
        }
        .price-tag {
            display: inline-block;
            background-color: rgba(197, 168, 128, 0.1);
            border: 1px solid var(--accent-color);
            padding: 1rem 2rem;
            font-family: var(--font-serif);
            font-size: 1.3rem;
            font-weight: 600;
            margin-top: 1rem;
        }

        /* Galleri & Till Salu Layout (CSS Grid) */
        .gallery-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: var(--gap-medium);
            margin-top: var(--gap-medium);
        }

        .art-card {
            background-color: var(--card-bg);
            border: 1px solid rgba(0,0,0,0.05);
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0,0,0,0.02);
            transition: transform 0.4s cubic-bezier(0.16, 1, 0.3, 1), box-shadow 0.4s ease;
        }

        .art-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 20px rgba(0,0,0,0.08);
        }

        .art-img-wrapper {
            width: 100%;
            height: 350px;
            overflow: hidden;
            background-color: #eee;
        }

        .art-card img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.6s ease;
        }

        .art-card:hover img {
            transform: scale(1.03);
        }

        .art-info {
            padding: 1.5rem;
        }

        .art-info h3 {
            font-size: 1.4rem;
            margin-bottom: 0.3rem;
        }

        .art-meta {
            font-size: 0.9rem;
            color: #666;
            margin-bottom: 0.8rem;
        }

        .art-status-price {
            font-family: var(--font-serif);
            font-weight: 600;
            color: var(--accent-color);
            border-top: 1px solid #eee;
            padding-top: 0.8rem;
            display: flex;
            justify-content: space-between;
        }

        /* Kontaktformulär */
        .contact-form {
            max-width: 600px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.9);
            padding: 2.5rem;
            border-radius: 2px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.04);
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .form-group input, .form-group textarea {
            width: 100%;
            padding: 0.8rem;
            border: 1px solid #ddd;
            background-color: var(--bg-color);
            font-family: inherit;
            font-size: 1rem;
        }

        .form-group input:focus, .form-group textarea:focus {
            outline: none;
            border-color: var(--accent-color);
        }

        .btn {
            display: inline-block;
            background-color: var(--text-color);
            color: #fff;
            padding: 0.9rem 2rem;
            border: none;
            font-family: var(--font-sans);
            font-size: 1rem;
            cursor: pointer;
            width: 100%;
            transition: background-color 0.3s ease;
        }

        .btn:hover {
            background-color: var(--accent-color);
        }

        .turnstile-wrapper {
            margin: 1.5rem 0;
            display: flex;
            justify-content: center;
        }

        /* Footer & Dold Admin-länk */
        footer {
            text-align: center;
            padding: 4rem 5%;
            margin-top: var(--gap-large);
            font-size: 0.9rem;
            color: #666;
            border-top: 1px solid rgba(0,0,0,0.05);
        }

        .footer-links {
            margin-bottom: 1rem;
        }

        .footer-links a {
            margin: 0 1rem;
        }

        .admin-trigger {
            color: var(--bg-color); /* Helt osynlig mot bakgrunden */
            cursor: default;
            user-select: none;
            font-size: 1px;
            display: inline-block;
        }

        /* Modaler (Inloggning & Backend) */
        .modal {
            display: none;
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background-color: rgba(0,0,0,0.6);
            z-index: 1000;
            justify-content: center;
            align-items: center;
            padding: 1rem;
        }

        .modal-content {
            background: #fff;
            padding: 2.5rem;
            max-width: 500px;
            width: 100%;
            position: relative;
            box-shadow: 0 20px 40px rgba(0,0,0,0.2);
        }

        .modal-content-backend {
            max-width: 800px;
        }

        .close-modal {
            position: absolute;
            top: 1rem; right: 1rem;
            font-size: 1.5rem;
            cursor: pointer;
        }

        /* Responsivitet */
        @media (max-width: 768px) {
