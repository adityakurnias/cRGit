# cRGit

`cRGit` adalah sebuah sistem kontrol versi sederhana yang terinspirasi oleh Git dan ditulis dari awal menggunakan Ruby. Proyek ini dibuat untuk tujuan edukasi guna memahami cara kerja internal Git, mengikuti konsep dari seri Rebuilding Git in Ruby.
https://thoughtbot.com/blog/rebuilding-git-in-ruby

## Fitur

- Inisialisasi repositori baru.
- Menambahkan file ke _staging area_ (indeks).
- Melakukan _commit_ untuk perubahan yang sudah di-_stage_.
- Melihat status repositori.

## Prasyarat

- Ruby (dikembangkan dengan versi 3.x)

## Instalasi

1.  _Clone_ repositori ini:
    ```sh
    git clone <url-repositori-anda>
    cd cRGit
    ```
2.  Skrip dirancang untuk dijalankan secara langsung. Tidak ada langkah instalasi lebih lanjut yang diperlukan.

## Penggunaan

```bash
chmod +x bin/*

```

### Inisialisasi Repositori

Untuk membuat repositori `cRGit` baru di direktori saat ini, jalankan:

```sh
./bin/crgit.rb init
```

Perintah ini akan membuat direktori `.crgit`, tempat `cRGit` menyimpan semua datanya, termasuk objek dan referensi.

### Menambahkan File

Untuk menyiapkan file (_stage_) untuk _commit_ berikutnya, gunakan perintah `add`:

```sh
# Buat file baru
echo "hello world" > hello.txt

# Tambahkan ke indeks
./bin/crgit.rb add hello.txt
```

### Memeriksa Status

Untuk melihat file mana yang sudah di-_stage_ dan apa _commit_ saat ini, gunakan `status`:

```sh
./bin/crgit.rb status
```

### Melakukan Commit

Untuk menyimpan perubahan yang sudah di-_stage_ secara permanen, buat sebuah _commit_:

```sh
./bin/crgit.rb commit
```

Perintah ini akan membuka editor teks default Anda (`$EDITOR`, misal: `vi` atau `nano`) untuk menulis pesan _commit_. Setelah menyimpan dan menutup editor, sebuah objek _commit_ baru akan dibuat.

## Struktur Proyek

- `bin/`: Berisi skrip yang dapat dieksekusi untuk setiap perintah.
- `lib/`: Berisi kelas-kelas Ruby inti yang mengimplementasikan logika sistem kontrol versi.
  - `crgit/object.rb`: Menangani baca/tulis objek (blob, tree, commit).
  - `crgit/index.rb`: Mengelola _staging area_.
  - `crgit/repo.rb`: Mengelola struktur repositori dan referensi seperti `HEAD`.
  - `crgit/commit.rb`: Logika untuk membuat objek _commit_.
  - `crgit/tree.rb`: Logika untuk membuat objek _tree_ dari indeks.

## Cara Kerja

`cRGit` meniru model objek dasar Git:

1.  **Blob**: Saat Anda menjalankan `add`, konten file akan dikompresi, hash SHA-1-nya dihitung, dan disimpan sebagai objek "blob" di direktori `.crgit/objects`.
2.  **Indeks**: Perintah `add` juga mencatat path file dan hash SHA-1 blob-nya di dalam file `.crgit/index`. Ini berfungsi sebagai _staging area_.
3.  **Tree**: Saat Anda menjalankan `commit`, `cRGit` akan membangun objek "tree" dari indeks. Sebuah _tree_ merepresentasikan isi sebuah direktori, memetakan nama file/direktori ke hash SHA blob/tree.
4.  **Commit**: Sebuah objek "commit" kemudian dibuat, yang menunjuk ke hash SHA dari _root tree_ dan menyertakan metadata seperti penulis dan pesan _commit_.
5.  **HEAD**: Terakhir, referensi `HEAD` diperbarui untuk menunjuk ke hash SHA dari _commit_ baru, menjadikannya sebagai ujung dari _branch_ saat ini.
