exports.handler = async event => {
    if (event.httpMethod !== 'POST') {
        return {
            statusCode: 405,
            headers: { Allow: 'POST' },
            body: JSON.stringify({ success: false, message: 'Metoden stöds inte.' })
        };
    }

    const secret = process.env.TURNSTILE_SECRET_KEY;
    if (!secret) {
        console.error('TURNSTILE_SECRET_KEY is not configured.');
        return {
            statusCode: 500,
            body: JSON.stringify({ success: false, message: 'Captcha-kontrollen är inte konfigurerad ännu.' })
        };
    }

    let token;
    try {
        token = JSON.parse(event.body || '').token;
    } catch (error) {
        return {
            statusCode: 400,
            body: JSON.stringify({ success: false, message: 'Ogiltig captcha-begäran.' })
        };
    }

    if (typeof token !== 'string' || token.length === 0 || token.length > 2048) {
        return {
            statusCode: 400,
            body: JSON.stringify({ success: false, message: 'Captcha-token saknas eller är ogiltig.' })
        };
    }

    try {
        const verification = await fetch('https://challenges.cloudflare.com/turnstile/v0/siteverify', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams({ secret, response: token })
        });

        if (!verification.ok) {
            console.error('Cloudflare Siteverify returned HTTP', verification.status);
            return {
                statusCode: 502,
                body: JSON.stringify({ success: false, message: 'Captcha-kontrollen kunde inte genomföras. Försök igen.' })
            };
        }

        const result = await verification.json();
        if (!result.success || result.action !== 'contact') {
            return {
                statusCode: 400,
                body: JSON.stringify({ success: false, message: 'Captcha-kontrollen misslyckades. Försök igen.' })
            };
        }

        return {
            statusCode: 200,
            body: JSON.stringify({ success: true })
        };
    } catch (error) {
        console.error('Turnstile verification request failed:', error);
        return {
            statusCode: 502,
            body: JSON.stringify({ success: false, message: 'Captcha-kontrollen kunde inte nå Cloudflare. Försök igen senare.' })
        };
    }
};
