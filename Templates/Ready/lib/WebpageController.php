<?php
require ('lib/DBController.php');
require ('lib/CsvWriter.php');
class WebpageController extends Lvc_PageController {
	protected $DB;
	protected $firephp;

	public function __construct() {
		$this -> DB = new DBController(DB_CONNECTIONSTRING, DB_USERNAME, DB_PASSWORD);

		if (FirePHP == true) {
			$this -> firephp = FirePHP::getInstance(true);
		}
	}

	/**
	 * The function buildOrderByOrder returns a valid ORDER BY ordermode (ASC or DESC).
	 * @param a String with the ordermode to order on; default = DESC.
	 * @return a String with a valid ordermode.
	 */
	protected function buildOrderByOrder($orderByOrder = 'ASC') {
		if ($this -> isValidOrder($orderByOrder)) {
			return $orderByOrder;
		} else {
			return 'ASC';
		}
	}

	/**
	 * The function isValidOrder checks if an ordermode is valid.
	 * @param a String with the ordermode to check.
	 * @return true if the ordermode is valid; false if the ordermode is not valid.
	 */
	protected function isValidOrder($order) {
		if (isset($order)) {
			$supportedOrderByOrders = array('DESC', 'ASC');
			if(in_array($order, $supportedOrderByOrders)) {
				return true;
			}
		}
		return false;
	}
	/**
	 * Add a prefix to every key of an array.
	 * @param Array $array  Array to be fixed with prefix
	 * @param String $prefix Prefix to be added.
	 */
	protected function addArrayPrefix($array, $prefix) {
		$return = array();
		foreach($array as $key => $value) {
			$return[$prefix . $key] = $value;
		}
		return $return;
	}
	/**
	 * Create a SQL Column string (used for Insert)
	 * @param  Array $array Array of fields
	 * @return String       String with Column names for SQL
	 */
	protected function createColumnsString($array) {
		if(!is_array($array)) { return ''; }
		$return = '';
		$i = 0;
		foreach($array as $key => $value) {
			$return .= '`'.$key.'`';
			if(count($array) != ($i + 1)) {
				$return .= ', ';
			}
			$i++;
		}
		return $return;
	}
	/**
	 * Create a SQL Value string (used for Insert)
	 * @param  Array $array Array of fields
	 * @return String       String with Column names for SQL
	 */
	protected function createValuesString($array) {
		if(!is_array($array)) { return ''; }
		$return = '';
		$i = 0;
		foreach($array as $key => $value) {
			$return .= ':'.$key;
			if(count($array) != ($i + 1)) {
				$return .= ', ';
			}
			$i++;
		}
		return $return;
	}
	/**
	 * The function getPageNumber checks if a pagenumber is valid and returns a valid pagenumber.
	 * @param int pagenumber.
	 * @return a valid pagenumber.
	 */
	protected function getPageNumber($pagenumber) {
		try {
			$pagenumber = (int)$pagenumber;
			if($pagenumber >= 1) { return $pagenumber; } else { return 1; }
		} catch (Exception $e) {
			return 1;
		}
	}

	/**
	 * The function getPageSize checks if a pagesize is valid and returns a valid pagesize.
	 * @param int the pagesize to check.
	 * @return a valid pagesize; default = DefaultLimit.
	 */
	protected function getPageSize($pagesize) {
		try {
			$pagesize = (int)$pagesize;
			if($pagesize >= 1) { return $pagesize; } else { return DefaultLimit; }
		} catch (Exception $e) {
			return DefaultLimit;
		}
	}

	/**
	 * The function getIndex checks if an specific index in an array is set.
	 * @param $array The array to check.
	 * @param $index The index number to check.
	 * @return true if the specific position in the array is set; false if the specific position isn't set.
	 */
	protected function getIndex($array, $index) {
		return isset($array[$index]) ? $array[$index] : null;
	}

	/**
	 * The function isAjaxRequest checks if the SERVER request is of a XMLHTTP format.
	 * @return true if it's an ajax request; false if it isn't an ajax request.
	 */
	protected function isAjaxRequest() {
		return (strcasecmp('XMLHttpRequest', @$_SERVER['HTTP_X_REQUESTED_WITH']) === 0);
	}

}
?>