<?php

use CodeIgniter\Router\RouteCollection;

/**
 * @var RouteCollection $routes
 */
$routes->get('/', 'Home::index');

$routes->group('api', function ($routes) {
    $routes->get('kegiatan', 'Api\Kegiatan::index');
    $routes->post('kegiatan', 'Api\Kegiatan::store');
});
