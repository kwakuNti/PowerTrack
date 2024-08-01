<?php

require_once __DIR__ . '/model.php';

class Maintenance extends Model
{
    protected $table = 'maintenance_requests'; // Name of the maintenance table

    public function create($data)
    {
        return $this->insert($data);
    }

    public function find($id)
    {
        return $this->find('id', $id);
    }

    public function update($id, array $data)
    {
        return parent::update($id, $data);
    }

    public function delete($col, $val)
    {
        return parent::delete($col, $val);
    }

    public function all()
    {
        return parent::all();
    }
}
