<?php
require_once ('firephp/FirePHP.class.php');
ob_start();

class DBController {
	private $DBH;
	private $firephp;

	/**
	 * Connect with a database.
	 * @param string $connectionstring PDO Connectionstring
	 * @param string $user             username
	 * @param string $pass             password
	 * @example
	 * "sqlite:my/database/path/database.db"
	 * "mysql:host=$host;dbname=$dbname"
	 * "sybase:host=$host;dbname=$dbname"
	 * "mssql:host=$host;dbname=$dbname"
	 */
	public function __construct($connectionstring, $user, $pass) {
		if (isset($user) && isset($pass)) {
			try {
				$this -> DBH = new PDO($connectionstring, $user, $pass);
			} catch(PDOException $e) {
				echo $e -> getMessage();
			}
		} else {
			try {
				$this -> DBH = new PDO($connectionstring);
			} catch(PDOException $e) {
				echo $e -> getMessage();
			}
		}
		$this -> DBH -> setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

		if (FirePHP == true) {
			$this -> firephp = FirePHP::getInstance(true);
		}
	}

	/**
	 * Query. (insert,update,delete)
	 * @param  string $query Insert sql query.
	 * @param array $data Array with insert values.
	 * @return boolean        Insert succesfull?
	 */
	public function query($query, $data) {
		try {
			$STH = $this -> DBH -> prepare($query);
			$STH -> execute($data);
			return true;
		} catch(Exception $e) {
			return $STH->errorInfo();
		}
	}

	/**
	 * Select query.
	 * @param  string $query Select sql query.
	 * @param  array $data Values for sql statement.
	 * @return array        Database returnvalues.
	 */
	public function select($query, $data, $limit = DefaultLimit, $offset = DefaultOffset) {
		try {
			$STH = $this -> DBH -> prepare($query);
			foreach($data as $key=>$value){
				$STH->bindValue(':'.$key, $value);
			}
			$STH->bindValue(':limit', (int) $limit, PDO::PARAM_INT);	
			$STH->bindValue(':offset', (int) $offset, PDO::PARAM_INT);
		    $STH -> execute();
		} catch (PDOException $e) {
		    return array("code"=>0,"message"=>$e->getMessage(),"data"=>$data,"query"=>$query);
		}
		$data = array();
		while ($row = $STH -> fetch(PDO::FETCH_ASSOC)) {
			$data[] = $row;
		}
		if(count($data) == 1){
			$data = $data[0];
		}
		return $data;
	}

	public function selectWithoutParameters($query) {
		$STH = $this -> DBH -> query($query);
		$result = $STH -> fetchAll(PDO::FETCH_ASSOC);
		//$this -> firephp -> log($result);
		return $result;
	}

	/**
	 * Get last inserted id.
	 * @return string last inserted id.
	 */
	public function lastInsertedId() {
		return $this -> DBH -> lastInsertId();
	}

	/**
	 * Close the database connection.
	 */
	public function closeConnection() {
		$this -> DBH = null;
	}

	/**
	 * Get Errors
	 */
	public function showErrors(){
		print_r($this -> DBH -> errorInfo());
	}
}
?>