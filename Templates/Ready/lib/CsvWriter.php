<?php
class csvWriter {

    private $columns;
    private $fh;
    private $values;
    
    
    /* Class constructor
     * Vult de volgende variablen:
     * columns -> een array met de columns die de tabel bevat.
     * values -> bevat een array met query waardes.
     */
    public function __construct($columns,$values) {
        $this->columns = $columns;
        $this->values = $values;
    }
    
    /* Hoofdfunctie
     * Deze functie kan van buiten het object worden aangeroepen.
     * Hier worden de functies aangeroepen die het csv bestand samenstelt
     * en vervolgens naar de gebruiker verstuurd.
     */
    public function createFile(){
        $myFile = "csv/".date('His-jmy').".csv";
        $this->fh = fopen($myFile, 'w') or die("can't open file");
        $this->createHeader();
        $this->createContent();
        $this->send($myFile);
        fclose($this->fh);
        unlink($myFile);

    }
   
    
    /* Bouwt de header op van het csv bestand. Hier
     * maakt hij gebruik van de array columns.
     */
    private function createHeader(){
        
        $header = "";
        foreach ($this->columns as $key => $value) {
            $header.= $key.";";
        }
        fwrite($this->fh,$header."\n");
    }
   
    /* Deze functie bouwt de content tabel op die onder de header van het
     * csv bestand komt te staan. Hier worden de meegegeven query resultaten
     * verwerkt. 
     */
    private function createContent(){
        $content = "";
        foreach ($this->values as $key => $value) {
            $content = "";
            $tempval = $value;
            foreach($tempval as $key => $value) {
                $content.= $value.";";
            }
            fwrite($this->fh,$content."\n");
        }
        
        
    }
    
    /*
     * Verstuurd het bestand naar de browser
     */
    private function send($filename)
        {
            if (file_exists($filename)) {
            header('Content-Description: File Transfer');
            header('Content-Type: application/octet-stream');
            header('Content-Disposition: attachment; filename='.basename($filename));
            header('Content-Transfer-Encoding: binary');
            header('Expires: 0');
            header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
            header('Pragma: public');
            header('Content-Length: ' . filesize($filename));
            ob_clean();
            flush();
            readfile($filename);
            }
        }
}
?>
