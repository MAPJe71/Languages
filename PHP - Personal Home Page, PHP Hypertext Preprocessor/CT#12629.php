<?php if (!defined(‘BASEPATH’)) exit(‘No direct script access allowed’);

class News_frontend extends MY_Controller
{
    function __construct()
    {
        parent::__construct();
        $this->load->helper(‘url’);
    }

    //News list
    public function news_content($alias){

        $data['news']=$this->f_homemodel->getItemByAlias('news',$alias);
        $title='Tin t?c | '.$data['news']->title;
        $keyword=$data['news']->keyword;
        $description=$data['news']->description;
        $this->load->view('news_content',$data);
    }

    private function admin_acc(){
        $description=$data['acc']->description;
        $this->load->view('admin_news',$data);
    }
}
