<?php

namespace App\Controllers\Api;

use App\Controllers\BaseController;
use App\Models\KegiatanModel;

class Kegiatan extends BaseController
{
    public function index()
    {
        $model = new KegiatanModel();

        $data = $model->orderBy('id', 'DESC')->findAll();
        return $this->response->setJSON($data);
    }

    public function store()
    {
        $data = $this->request->getJSON(true);

        $model = new KegiatanModel();
        $model->insert($data);

        return $this->response->setJSON([
            'status' => true,
            'message' => 'Data berhasil ditambahkan'
        ]);
    }
}
