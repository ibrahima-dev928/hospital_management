const multer = require('multer');
const path = require('path');
const fs = require('fs');
const Jimp = require('jimp');

const ensureDir = (dir) => {
  if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
};
ensureDir('uploads/patients');
ensureDir('uploads/medecins');
ensureDir('uploads/documents');

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    let folder = 'uploads/';
    if (req.baseUrl.includes('patients')) folder += 'patients/';
    else if (req.baseUrl.includes('medecins')) folder += 'medecins/';
    else folder += 'documents/';
    cb(null, folder);
  },
  filename: (req, file, cb) => {
    const unique = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, unique + path.extname(file.originalname));
  }
});

const fileFilter = (req, file, cb) => {
  if (file.mimetype.startsWith('image/')) cb(null, true);
  else cb(new Error('Seules les images sont autorisées'), false);
};

const upload = multer({ storage, limits: { fileSize: 10 * 1024 * 1024 }, fileFilter });

const optimizeImage = async (req, res, next) => {
  if (!req.file) return next();
  const originalPath = req.file.path;
  const ext = path.extname(originalPath);
  const optimizedPath = originalPath.replace(ext, '_thumb.jpg');
  try {
    const image = await Jimp.read(originalPath);
    await image
      .cover(300, 300) // redimensionne et rogne pour couvrir 300x300
      .quality(80)
      .writeAsync(optimizedPath);
    fs.unlinkSync(originalPath);
    req.file.path = optimizedPath;
    req.file.filename = path.basename(optimizedPath);
  } catch (err) {
    console.error('Erreur optimisation avec Jimp:', err);
  }
  next();
};

module.exports = { upload, optimizeImage };