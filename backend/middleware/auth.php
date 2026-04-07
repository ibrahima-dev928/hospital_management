function requireAuth(req, res, next) {
    if (req.session && req.session.user) {
        next();
    } else {
        res.redirect('/login?redirect=' + encodeURIComponent(req.originalUrl));
    }
}

function requireAdmin(req, res, next) {
    if (req.session && req.session.user && req.session.user.role === 'admin') {
        next();
    } else {
        res.redirect('/login?error=Accès administrateur requis');
    }
}

module.exports = { requireAuth, requireAdmin };