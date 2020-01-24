#!/bin/bash
set -e

## Execute a command as user pdns
exec_as_pdns() {
  sudo -HEu pdns "$@"
}

[[ -n $DEBUG_ENTRYPOINT ]] && set -x

PDNS_BACKEND=${PDNS_BACKEND:-none}

MYSQL_HOST=${MYSQL_HOST:-localhost}
MYSQL_PORT=${MYSQL_PORT:-3306}
MYSQL_USER=${MYSQL_USER:-dbuser}
MYSQL_NAME=${MYSQL_NAME:-powerdns}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-}

SQLITE3_PATH=${SQLITE3_PATH:-/var/lib/powerdns/pdns.db}

PDNS_CONFIG_FILE=/etc/powerdns/pdns.conf
PDNS_API_KEY=${PDNS_API_KEY:-none}

case ${PDNS_API_KEY} in
	none)
		echo "No API";
		;;
	*)
		echo "API Key used";

		grep -q "^api=" ${PDNS_CONFIG_FILE} || echo "api=\n" | tee --append ${PDNS_CONFIG_FILE};
 		sed -i -E "s/(^api=)(.*)/\1yes/g" ${PDNS_CONFIG_FILE};
		grep -q "^api-key=" ${PDNS_CONFIG_FILE} || echo "api-key=\n" | tee --append ${PDNS_CONFIG_FILE};
 		sed -i -E "s/(^api-key=)(.*)/\1${PDNS_API_KEY}/g" ${PDNS_CONFIG_FILE};

		grep -q "^webserver=" ${PDNS_CONFIG_FILE} || echo "webserver=\n" | tee --append ${PDNS_CONFIG_FILE};
 		sed -i -E "s/(^webserver=)(.*)/\1yes/g" ${PDNS_CONFIG_FILE};

		grep -q "^webserver-address=" ${PDNS_CONFIG_FILE} || echo "webserver-address=\n" | tee --append ${PDNS_CONFIG_FILE};
 		sed -i -E "s/(^webserver-address=)(.*)/\10\.0\.0\.0/g" ${PDNS_CONFIG_FILE};

		grep -q "^webserver-port=" ${PDNS_CONFIG_FILE} || echo "webserver-port=\n" | tee --append ${PDNS_CONFIG_FILE};
 		sed -i -E "s/(^webserver-port=)(.*)/\18081/g" ${PDNS_CONFIG_FILE};

		grep -q "^webserver-allow-from=" ${PDNS_CONFIG_FILE} || echo "webserver-allow-from=\n" | tee --append ${PDNS_CONFIG_FILE};
 		sed -i -E "s/(^webserver-allow-from=)(.*)/\10\.0\.0\.0\/0/g" ${PDNS_CONFIG_FILE};


	;;
esac


case ${PDNS_BACKEND} in
  mysql)
    echo "MySQL backend, configuring...";
		
		grep -q "^launch=" ${PDNS_CONFIG_FILE} || echo "launch=\n" | tee --append ${PDNS_CONFIG_FILE};
 		sed -i -E "s/(^launch=)(.*)/\1g${PDNS_BACKEND}/g" ${PDNS_CONFIG_FILE};

		grep -q "^gmysql-host=" ${PDNS_CONFIG_FILE} || echo "gmysql-host=\n" | tee --append ${PDNS_CONFIG_FILE};
 		sed -i -E "s/(^gmysql-host=)(.*)/\1${MYSQL_HOST}/g" ${PDNS_CONFIG_FILE};
		grep -q "^gmysql-port=" ${PDNS_CONFIG_FILE} || echo "gmysql-port=\n" | tee --append ${PDNS_CONFIG_FILE};
 		sed -i -E "s/(^gmysql-port=)(.*)/\1${MYSQL_PORT}/g" ${PDNS_CONFIG_FILE};
		grep -q "^gmysql-user=" ${PDNS_CONFIG_FILE} || echo "gmysql-user=\n" | tee --append ${PDNS_CONFIG_FILE};
 		sed -i -E "s/(^gmysql-user=)(.*)/\1${MYSQL_USER}/g" ${PDNS_CONFIG_FILE};
		grep -q "^gmysql-dbname=" ${PDNS_CONFIG_FILE} || echo "gmysql-dbname=\n" | tee --append ${PDNS_CONFIG_FILE};
 		sed -i -E "s/(^gmysql-dbname=)(.*)/\1${MYSQL_NAME}/g" ${PDNS_CONFIG_FILE};
		grep -q "^gmysql-password=" ${PDNS_CONFIG_FILE} || echo "gmysql-password=\n" | tee --append ${PDNS_CONFIG_FILE};
 		sed -i -E "s/(^gmysql-password=)(.*)/\1${MYSQL_PASSWORD}/g" ${PDNS_CONFIG_FILE};


    ;;
  sqlite3)
    echo "SQLite3 backend, configuring...";

		grep -q "^launch=" ${PDNS_CONFIG_FILE} || echo "launch=\n" | tee --append ${PDNS_CONFIG_FILE};
 		sed -i -E "s/(^launch=)(.*)/\1g${PDNS_BACKEND}/g" ${PDNS_CONFIG_FILE};

		grep -q "^gsqlite3-database=" ${PDNS_CONFIG_FILE} || echo "gsqlite3-database=\n" | tee --append ${PDNS_CONFIG_FILE};
 		sed -i -E "s/(^gsqlite3-database=)(.*)/\1${SQLITE3_PATH}/g" ${PDNS_CONFIG_FILE};

    ;;   
  *)
		echo "No backend or backend not supported, please mount your own pdns.conf";
    ;;
esac



#ZAMMAD_SERVER_NAME=${ZAMMAD_SERVER_NAME:-}

#POSTFIX_MYHOSTNAME=${POSTFIX_MYHOSTNAME:-}
#POSTFIX_RELAY_HOST=${POSTFIX_RELAY_HOST:-}
#POSTFIX_RELAY_USER=${POSTFIX_RELAY_USER:-}
#POSTFIX_RELAY_PASSWORD=${POSTFIX_RELAY_PASSWORD:-}

#sudo -HEu zammad sed 's,{{DB_HOST}},'"${DB_HOST}"',g' -i config/database.yml
#sudo -HEu zammad sed 's,{{DB_USER}},'"${DB_USER}"',g' -i config/database.yml
#sudo -HEu zammad sed 's,{{DB_NAME}},'"${DB_NAME}"',g' -i config/database.yml
#sudo -HEu zammad sed 's,{{DB_PASSWORD}},'"${DB_PASSWORD}"',g' -i config/database.yml
#sed 's,{{ZAMMAD_SERVER_NAME}},'"${ZAMMAD_SERVER_NAME}"',g' -i /etc/nginx/sites-available/zammad.conf

#if [ -n "${POSTFIX_RELAY_USER}" ] &&  [ -n "${POSTFIX_RELAY_PASSWORD}" ] ; then
#    echo "${POSTFIX_RELAY_HOST}		${POSTFIX_RELAY_USER}:${POSTFIX_RELAY_PASSWORD}" > /etc/postfix/sasl/saslpass
#    cd /etc/postfix/sasl/
#    postmap saslpass
#    postconf -e "smtp_sasl_password_maps = hash:/etc/postfix/sasl/saslpass"
#fi

#if [ -n "${POSTFIX_MYHOSTNAME}" ]; then
#    postconf -e "myhostname = ${POSTFIX_MYHOSTNAME}"
#fi

#if [ -n "${POSTFIX_RELAY_HOST}" ]; then
#    postconf -e "relayhost = ${POSTFIX_RELAY_HOST}"
#fi

#postconf -e "smtp_sasl_auth_enable = yes"
#postconf -e "smtp_sasl_security_options = noanonymous"
#postconf -e "smtp_use_tls = yes"



appStart () {
    
  # start Powerdns
  echo "Starting PowerDNS Server..."
	#exec /bin/bash 
  #exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
	case ${PDNS_BACKEND} in
		mysql)
			echo "MySQL backend, starting PowerDNS server...";
			/app/wait-for-it.sh -t 30 ${MYSQL_HOST}:${MYSQL_PORT} 
			if [ $? -ne 0 ]; then
  			echo "Error by connecting MySQL database, could not start PowerDNS."
			else
				echo "start PowerDNS..."
				exec /usr/sbin/pdns_server --daemon=no --guardian=no --loglevel=9
			fi
		
			;;
		sqlite3)
			echo "SQLite3 backend, starting PowerDNS server...";

		
			;;   
		*)
			echo "No backend or backend not supported, doing nothing...";
			;;
	esac
}


appInit () {
  echo "Initializing PowerDNS, create tables..."
	#/usr/share/pdns-backend-sqlite3# less schema/schema.sqlite3.sql
	#/usr/share/pdns-backend-mysql/schema# less schema.mysql.sql
#root@2f1ccd683ad5:/app# ./wait-for-it.sh -h moabit.geschke.net -p 3306
#wait-for-it.sh: waiting 15 seconds for moabit.geschke.net:3306
#wait-for-it.sh: moabit.geschke.net:3306 is available after 0 seconds
#root@2f1ccd683ad5:/app# ./wait-for-it.sh -h moabit.geschke.net -p 3307 -t 10
#wait-for-it.sh: waiting 10 seconds for moabit.geschke.net:3307
#wait-for-it.sh: timeout occurred after waiting 10 seconds for moabit.geschke.net:3307
#root@2f1ccd683ad5:/app# echo $?
#124
#root@2f1ccd683ad5:/app# ./wait-for-it.sh -h moabit.geschke.net -p 3306
#wait-for-it.sh: waiting 15 seconds for moabit.geschke.net:3306
#wait-for-it.sh: moabit.geschke.net:3306 is available after 0 seconds
#root@2f1ccd683ad5:/app# echo $?
#0

	case ${PDNS_BACKEND} in
		mysql)
			echo "MySQL backend, initializing...";
			/app/wait-for-it.sh -t 30 ${MYSQL_HOST}:${MYSQL_PORT} 
			if [ $? -ne 0 ]; then
  			echo "Error by connecting MySQL database, could not initialize."
			else
				/usr/bin/mysql --host="${MYSQL_HOST}" --user="${MYSQL_USER}" --password="${MYSQL_PASSWORD}" --port=${MYSQL_PORT} < /usr/share/pdns-backend-mysql/schema/schema.mysql.sql
				echo "ok? :";
				echo $?
			fi
		
			;;
		sqlite3)
			echo "SQLite3 backend, initializing...";

		
			;;   
		*)
			echo "No backend or backend not supported, doing nothing...";
			;;
	esac



   #exec_as_zammad /bin/bash -c "cd /opt/zammad && source /opt/zammad/.rvm/scripts/rvm && /init.sh"
  
}


appHelp () {
  echo "Available options:"
  echo " app:start          - Starts Powerdns Server (default)"
  echo " app:init           - Initialize Database"
  echo " [command]          - Execute the specified linux command eg. bash."
}


case ${1} in
  app:start)
    appStart
    ;;
	app:init)
		appInit	
		;;
  app:help)
    appHelp
    ;;   
  *)
    if [[ -x $1 ]]; then
      $1
    else
      prog=$(which $1)
      if [[ -n ${prog} ]] ; then
        shift 1
        $prog $@
      else
        appHelp
      fi
    fi
    ;;
esac

exit 0