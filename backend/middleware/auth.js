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

function requireMedecin(req, res, next) {
  if (req.session.user && req.session.user.role === 'medecin') next();
  else res.status(403).send('Accès réservé aux médecins');
}

module.exports = { requireAuth, requireAdmin, requireMedecin };