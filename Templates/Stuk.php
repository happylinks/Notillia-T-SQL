<?php
class StukController extends WebpageController{

	public function __construct() {
		parent::__construct();
	}

	public function actionIndex() {
		$this -> loadView( '{{TableName}}/index' );
	}

	public function actionRecord() {
		if ( isset( $_POST ) ) {
			$page = ( isset( $_POST['page'] ) && is_numeric( $_POST['page'] ) ) ? $_POST['page'] : 1;
			$limit = ( isset( $_POST['limit'] ) && is_numeric( $_POST['limit'] ) ) ? $_POST['limit'] : DefaultLimit;
			$offset = ( $page-1 )*$limit;
			$data = array();

			$query = "SELECT `stuknr`, `componistId`, `titel`, `stuknrOrigineel`, `genrenaam`, `niveaucode`, `speelduur`, `jaartal`,
					  (SELECT COUNT(`stuknr`) FROM `Stuk`) as 'notillia.totalrecords'
					  FROM `Stuk` ";
			// Parameter "navigation" indicates which record is requested:
			// -2 = first record in table
			// -1 = previous record (with a where clause)
			//  1 = next record (with a where clause)
			//  2 = last record in table
			//  NaN = get record from Where clause

			switch ( @$_POST['navigation'] ) {
			case -2:
				$query .= "ORDER BY `stuknr` ASC";
				$offset = 0;
				break;
			case -1:
				if ( isset( $_POST['where'] ) && is_array( $_POST['where'] ) ) {
					$query .= "WHERE `stuknr` <= :column_stuknr ORDER BY  `Stuknr` DESC";
					$data = $this -> createPKColumnArray( $_POST['where'] );
					$offset = 1;
				}
				break;
			case 1:
				if ( isset( $_POST['where'] ) && is_array( $_POST['where'] ) ) {
					$query .= "WHERE `stuknr` >= :column_stuknr ORDER BY  `Stuknr` ASC";
					$data = $this -> createPKColumnArray( $_POST['where'] );
					$offset = 1;
				}
				break;
			case 2:
				$query .= "ORDER BY `stuknr` DESC ";
				$offset = 0;
				break;
			default:
				// Invalid number specified
				if ( isset( $_POST['where'] ) && is_array( $_POST['where'] ) ) {
					$query .= "WHERE `stuknr` = :column_stuknr ORDER BY  `Stuknr` ASC";
					$data = $this -> createPKColumnArray( $_POST['where'] );
				}
				break;
			}
			$query .= " LIMIT :limit OFFSET :offset";

			$result = $this -> DB -> select( $query, $data, $limit, $offset );

			$this -> setVar( 'data', $this -> giveJSONRecordData( $result, $limit ) );
		} else {
			$this -> setVar( 'data', false );
		}
		$this -> loadView( 'json' );
	}

	public function actionChildGrid() {
		if ( isset( $_POST ) ) {
			$page = ( isset( $_POST['page'] ) && is_numeric( $_POST['page'] ) ) ? $_POST['page'] : 1;
			$limit = ( isset( $_POST['limit'] ) && is_numeric( $_POST['limit'] ) ) ? $_POST['limit'] : DefaultLimit;
			$offset = ( $page-1 )*$limit;
			$child = @$_POST['child'];
			$data = array();
			switch ( $child ) {
			case 'stuk':
				$query = "SELECT s2.`stuknr`, s2.`componistId`, s2.`titel`, s2.`stuknrOrigineel`, s2.`genrenaam`, s2.`niveaucode`, s2.`speelduur`, s2.`jaartal`, (
										SELECT COUNT(*) FROM (
											SELECT 1
											FROM `Stuk` s3
											INNER JOIN `Stuk` s4 ON s3.`stukNrOrigineel` = s4.`stuknr`
											";
				if ( isset( $_POST['where'] ) && is_array( $_POST['where'] ) ) {
					$query .= "WHERE s4.`stuknr` = :column_stuknrOrigineel ";
					$data = $this -> createFKColumnArray( $_POST['where'], $child );
				}
				$query .= "
						  					GROUP BY s4.`stuknr`
						  				) AS subQuery
									) AS 'notillia.totalrecords'
							FROM `Stuk` s
    						INNER JOIN `Stuk` s2
    						ON s.`stukNrOrigineel` = s2.`stuknr`";
				if ( isset( $_POST['where'] ) && is_array( $_POST['where'] ) ) {
					$query .= "WHERE s2.`stuknr` = :column_stuknrOrigineel ";
					$data = $this -> createFKColumnArray( $_POST['where'], $child );
				}
				$query .= "GROUP BY s2.`Stuknr`
						  	LIMIT :limit
						  	OFFSET :offset";
				break;
			case 'bezettingsregel':
				$query = "SELECT b.`stuknr`, b.`instrumentnaam`, b.`toonhoogte`, b.`aantal`, (
									SELECT COUNT(*)
									FROM(
										SELECT 1
										FROM `Bezettingsregel` b
										INNER JOIN `Stuk` s
										ON b.`stuknr` = s.`stuknr`";
				if ( isset( $_POST['where'] ) && is_array( $_POST['where'] ) ) {
					$query .= "WHERE s.`stuknr` = :column_stuknr ";
					$data = $this -> createFKColumnArray( $_POST['where'], $child );
				}
				$query .= "GROUP BY b.`stuknr`,b.`instrumentnaam`,b.`toonhoogte`
									) AS subQuery
								) AS 'notillia.totalrecords'
							FROM `Bezettingsregel` b
							INNER JOIN `Stuk` s
							ON b.`stuknr` = s.`stuknr`";
				if ( isset( $_POST['where'] ) && is_array( $_POST['where'] ) ) {
					$query .= "WHERE s.`stuknr` = :column_stuknr ";
					$data = $this -> createFKColumnArray( $_POST['where'], $child );
				}
				$query .= "GROUP BY b.`stuknr`,b.`instrumentnaam`,b.`toonhoogte`
							ORDER BY b.`stuknr`,b.`instrumentnaam`,b.`toonhoogte` ASC
						  	LIMIT :limit
						  	OFFSET :offset";
				break;
			default:
				// give JSON and abort function call
				$this -> setVar( 'data', false );
				$this -> loadView( 'json' );
				return false;
				break;
			}
			$result = $this -> DB -> select( $query, $data, $limit, $offset );

			$this -> setVar( 'data', $this -> giveJSONRecordData( $result, $limit ) );
		} else {
			$this -> setVar( 'data', false );
		}
		$this -> loadView( 'json' );
	}
	/**
	 * Function that processes the raw SQL data to a JSON message for the client.
	 * Also cuts of the total records of the table, and sends it a seperate variable.
	 *
	 * @param Array   $result SQL array from PDO
	 */
	private function giveJSONRecordData( $result, $limit ) {
		if ( !empty( $result ) ) {
			if ( isset( $result[0] ) && is_array( $result[0] ) ) {
				foreach ( $result as $row ) {
					if ( is_array( $row ) ) {
						$totalrecords = $row['notillia.totalrecords'];
						unset( $row['notillia.totalrecords'] );
					}
					$return[] = $row;
				}
			}else { //If one row.
				$totalrecords = $result['notillia.totalrecords'];
				unset( $result['notillia.totalrecords'] );
				$return[0] = $result;
			}

			$maxpage = ceil( $totalrecords/$limit );
			$return['maxpage'] = $maxpage;
			return $return;
		}else {
			return false;
		}
	}

	/**
	 * Action is called by Ajax /insert. Inserts a new record in this table.
	 */
	public function actionInsert() {
		if ( isset( $_POST['stuknr'] ) && isset( $_POST['componistId'] ) && isset( $_POST['titel'] ) && isset( $_POST['stuknrOrigineel'] ) && isset( $_POST['genrenaam'] ) && isset( $_POST['niveaucode'] ) && isset( $_POST['speelduur'] ) && isset( $_POST['jaartal'] ) ) {
			$data = $this -> createColumnArray( $_POST );
			$query = "INSERT INTO `Stuk`
					  (`stuknr`, `componistId`, `titel`, `stuknrOrigineel`, `genrenaam`, `niveaucode`, `speelduur`, `jaartal`) VALUES
					  (:column_stuknr, :column_componistId, :column_titel, :column_stuknrOrigineel, :column_genrenaam, :column_niveaucode, :column_speelduur, :column_jaartal)";
			$statement = $this -> DB -> query( $query, $data );
			if ( !is_array( $statement ) ) {
				$this -> giveJSONmessage( true, 'Record is inserted.' );
			} else {
				$this -> giveJSONmessage( false, $statement[2] );
			}
		} else {
			$this -> giveJSONmessage( false, 'Parameters are incorrect.' );
		}
		$this -> loadView( 'json' );
	}
	/**
	 * Action is called by Ajax /update. Updates a record with parameters (old(only primary keys), new)
	 */
	public function actionUpdate() {
		if ( isset( $_POST['old']['stuknr'] ) &&
			/* All columns of the table. */
			isset( $_POST['new']['stuknr'] ) && isset( $_POST['new']['componistId'] ) && isset( $_POST['new']['titel'] ) && isset( $_POST['new']['stuknrOrigineel'] ) && isset( $_POST['new']['genrenaam'] ) && isset( $_POST['new']['niveaucode'] ) && isset( $_POST['new']['speelduur'] ) && isset( $_POST['new']['jaartal'] ) ) {
			$data_old = $this -> addArrayPrefix( $this -> createPKColumnArray( $_POST['old'] ), 'old_' );
			$data_new = $this -> addArrayPrefix( $this -> createColumnArray( $_POST['new'] ), 'new_' );
			$data = array_merge( $data_old, $data_new );

			$query = "UPDATE `Stuk`
					  SET `stuknr` = :new_column_stuknr,
					  	  `componistId` = :new_column_componistId,
					  	  `titel` = :new_column_titel,
					  	  `stuknrOrigineel` = :new_column_stuknrOrigineel,
					  	  `genrenaam` = :new_column_genrenaam,
					  	  `niveaucode` = :new_column_niveaucode,
					  	  `speelduur` = :new_column_speelduur,
					  	  `jaartal` = :new_column_jaartal
					  WHERE `stuknr` = :old_column_stuknr";
			$statement = $this -> DB -> query( $query, $data );
			if ( !is_array( $statement ) ) {
				$this -> giveJSONmessage( true, 'Record is updated.' );
			} else {
				$this -> giveJSONmessage( false, $statement[2] );
			}
		} else {
			$this -> giveJSONmessage( false, 'Parameters are incorrect.' );
		}
		$this -> loadView( 'json' );
	}
	/**
	 * Action is called by Ajax /delete. Deletes a record in the database.
	 */
	public function actionDelete() {
		if ( isset( $_POST['stuknr'] ) ) {
			$data = $this -> createPKColumnArray( $_POST );
			$query = "DELETE FROM `Stuk`
					  WHERE `stuknr` = :column_stuknr";
			$statement = $this -> DB -> query( $query, $data );
			if ( !is_array( $statement ) ) {
				$this -> giveJSONmessage( true, 'Record is deleted.' );
			} else {
				$this -> giveJSONmessage( false, $statement[2] );
			}
		} else {
			$this -> giveJSONmessage( false, 'Parameters are incorrect.' );
		}
		$this -> loadView( 'json' );
	}
	/**
	 * Create an column array for the PDO.
	 *
	 * @param Array   $data Array that contains the data
	 * @return Array       Array with column prefix and filtered array.
	 */
	private function createColumnArray( $data ) {
		$return = array();

		$return['column_stuknr'] = @$data['stuknr'];
		$return['column_componistId'] = @$data['componistId'];
		$return['column_titel'] = @$data['titel'];
		if ( isset( $data['stuknrOrigineel'] ) && $data['stuknrOrigineel'] == '' ) {
			$return['column_stuknrOrigineel'] = null;
		} else {
			$return['column_stuknrOrigineel'] = @$data['stuknrOrigineel'];
		}
		$return['column_genrenaam'] = @$data['genrenaam'];
		if ( isset( $data['null_niveaucode'] ) && $data['null_niveaucode'] == 'true' ) {
			$return['column_niveaucode'] = null;
		} else {
			$return['column_niveaucode'] = @$data['niveaucode'];
		}
		if ( isset( $data['speelduur'] ) &&  $data['speelduur'] == '' ) {
			$return['column_speelduur'] = null;
		} else {
			$return['column_speelduur'] = @$data['speelduur'];
		}
		$return['column_jaartal'] = @$data['jaartal'];

		return $return;
	}
	/**
	 * Create an Primary key column array for the PDO.
	 *
	 * @param Array   $data Array that contains the data
	 * @return Array       Array with column prefix and filtered array.
	 */
	private function createPKColumnArray( $data ) {
		$return = array();
		$return['column_stuknr'] = @$data['stuknr'];

		return $return;
	}
	/**
	 * Create an Foreign key column array for the PDO.
	 *
	 * @param Array   $data Array that contains the data
	 * @return Array       Array with column prefix and filtered array.
	 */
	private function createFKColumnArray( $data, $child ) {
		$return = array();
		switch ( $child ) {
		case 'stuk':
			$return['column_stuknrOrigineel'] = @$data['stuknrOrigineel'];
			break;
		case 'bezettingsregel':
			$return['column_stuknr'] = @$data['stuknr'];
			break;
		}
		return $return;
	}
	/**
	 * Give a message that will indicate if the process is succeeded.
	 *
	 * @param boolean $code    succeeded
	 * @param String  $message Message to be displayed.
	 */
	private function giveJSONmessage( $code, $message ) {
		$this -> setVar( 'data', array( 'code' => (int)$code,
				'message' => $message ) );
	}
}
?>
