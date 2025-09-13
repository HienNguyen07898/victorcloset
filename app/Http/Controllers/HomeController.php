<?php

namespace App\Http\Controllers;

class HomeController extends Controller
{
    /**
     * Product Constructor
     */
    public function __construct()
    {

    }

    /**
     * Index page.
     *
     * @return View
     */
    public function index()
    {
        echo'Day la home';
    }
}
