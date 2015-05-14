<?php


namespace visceral;


class Config {

    static function getDBHostConfig() {
        return array(
            'host' => 'DB_SERVER_ADRESS',
            'user' => 'USERNAME',
            'passwd' => 'PASSWORD',
            'database' => 'visceral_tickets_release'
        );
    }
	
    static function getSFTPHostConfig() {
        return array(
            'host' => 'SFTP_SERVER_ADRESS',
            'user' => 'USERNAME',
            'passwd' => 'PASSWORD'
        );
    }
	

} 
