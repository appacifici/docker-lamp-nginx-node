#!/bin/bash

importDb() {
	echo "--------- START: IMPORT MYSQL DB $1 < $2 ---------"
	mysql -h$MYSQL_HOST -P$MYSQL_TCP_PORT -u$MYSQL_USER -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $1"
	mysql -h$MYSQL_HOST -P$MYSQL_TCP_PORT -u$MYSQL_USER -p$MYSQL_ROOT_PASSWORD $1 < $2
	echo "---------   END: IMPORT MYSQL DB $1 < $2 ---------"
}

init() {	
	cd project && symfony composer install
	echo "dipendenze installate . . . "

	sh /usr/local/bin/docker-php-entrypoint php-fpm	&

	mysql -h$MYSQL_HOST -P$MYSQL_TCP_PORT -u$MYSQL_USER -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE"		
	echo "mysql -h$MYSQL_HOST -P$MYSQL_TCP_PORT -u$MYSQL_USER -p$MYSQL_ROOT_PASSWORD -e 'CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE'"		

	ln -sf dump/* /mysql-dump/.
	echo "dump/* /mysql-dump/."

	chmod -R 777 /socket
	echo "chmod -R 777 /socket"

	chmod -R 777 var
	echo "chmod -R 777 var"
	
    #tail -f /var/www/html/project/$TAIL_FILE_DEBUG

	symfony console doctrine:migrations:migrate --no-interaction
	echo "symfony console doctrine:migrations:migrate --no-interaction"

	gulp --gulpfile=/gulp/gulpfile.js watchSass &	
	tail -f
}

execQuery() {
	mysql -h$MYSQL_HOST -P$MYSQL_TCP_PORT -u$MYSQL_USER -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE -e "$1"
}

case "$1" in	
	mostra)
			echo "==> $MYSQL_DATABASE ==> $MYSQL_ROOT_PASSWORD => $MYSQL_USER ==> $MYSQL_PASSWORD ==> $MYSQL_HOST ==> $MYSQL_TCP_PORT"
		;;
	execQuery)
		execQuery "$2"
		;;
	importDb)
		importDb "$2" "$3"
		;;

	init)
		init
		;;	

	psalm)
#		update_php_dependences

		cd project && ./vendor/bin/psalm
		;;

	cs)
#		update_php_dependences

		cd project && ./vendor/bin/phpcs --config-set show_warnings 0
		./vendor/bin/phpcs -n
		;;

	csgithub)
#		update_php_dependences

		cd project && ./vendor/bin/phpcs --report=summary -n -p
		;;

	cbf)
#		update_php_dependences

		cd project && ./vendor/bin/phpcbf
		;;

	pstan)
		cd project && ./vendor/bin/phpstan analyse
		;;

	bash)
		/bin/bash
		;;
	sh)
		/bin/sh
		;;

	*)
		echo "This container accepts the following commands:"
		echo "- importDb <name.sql>"
		echo "- Init"		
		echo "- psalm"
		echo "- cs (CodeSniffer phpcs)"
		echo "- cbf (CodeSniffer phpcbf)"
		echo "- pstan (PHPStan)"
		echo "- bash"
		echo "- sh"
		exit 1
esac