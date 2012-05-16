<?php
class IndexController extends WebpageController {
	public function __construct() {
		parent::__construct();
	}

	/**
	 * index view for the user.
	 */
	public function actionIndex() {
		$this -> loadView('index');
	}
}
?>