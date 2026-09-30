# Portfolio Reinaldy Zulfananda Arkaan

Situs statis (HTML, CSS, JS). Tidak perlu build.

## Deploy ke Vercel
1. Upload folder ini ke repo GitHub baru (misalnya `portfolio`).
2. Buka vercel.com, pilih Add New > Project, lalu import repo tersebut.
3. Framework Preset: Other. Build Command dan Output Directory dikosongkan.
4. Klik Deploy.

Cara lain lewat terminal: `npm i -g vercel` lalu jalankan `vercel` di folder ini.

## Yang perlu diubah
Link GitHub untuk proyek SQL dan Python masih mengarah ke profil.
Ganti di file berikut (cari `github.com/ReinaldyZA`):
projects/revogrocers-sales-sql.html
projects/revobank-customer-segmentation.html
projects/berka-credit-risk.html

Link JakU ada di index.html dan projects/jaku-thesis.html.

## Struktur
index.html              halaman utama
projects/               halaman case study per proyek
assets/css, js, img     gaya, script, gambar
files/                  deck (PDF, PPTX), workbook, SQL, notebook
