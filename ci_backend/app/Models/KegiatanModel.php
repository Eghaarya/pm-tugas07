<?php

namespace App\Models;

use CodeIgniter\Model;

class KegiatanModel extends Model
{
    protected $table = 'kegiatan';
    protected $primaryKey = 'id';
    protected $allowedFields = ['nama_kegiatan', 'deskripsi', 'tanggal'];

    // Aktifkan timestamps
    protected $useTimestamps = true;

    // Field untuk created_at & updated_at
    protected $createdField  = 'created_at';
    protected $updatedField  = 'updated_at';
}
