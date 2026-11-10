## 7. Actividad 1 — Revisar la configuración de registro por defecto


## "log_connections"	        "off"	    "default"
## "log_directory"	            "log"	    "default"
## "log_disconnections"	        "off"	    "default"
## "log_filename"	            "postgresql""default"
## "log_line_prefix"	        "%t "	    "configuration file"
## "log_min_error_statement"	"error"	    "default"
## "log_statement"	            "none"	    "default"
## "log_timezone"	            "GMT"	    "default"
## "logging_collector"	        "on"	    "configuration file"

1. ¿Con esta configuración se registra quién se conecta?

No, porque log_connections está desactivado. Por lo tanto, no se registran las conexiones de los usuarios.

2. ¿Se registran las sentencias UPDATE?

No, porque log_statement tiene el valor none, por lo que no se registran las sentencias SQL normales.

3. ¿La línea de bitácora incluye el usuario o la dirección IP del cliente?

No, porque el prefijo %t solamente incluye la fecha y hora del evento. No muestra el usuario ni la dirección IP.

4. ¿En qué zona horaria se registran los eventos? ¿Por qué importa?

Los eventos se registran utilizando GMT. Esto es importante para ordenar y comparar los eventos correctamente al reconstruir una cronología.

5. Con logging_collector = off, ¿quién decide dónde termina la bitácora?

Cuando el colector está desactivado, PostgreSQL envía los mensajes a stderr y el mecanismo que ejecuta el servidor decide dónde almacenarlos. En mi instalación el colector está activado (on), por lo que PostgreSQL recopila los mensajes en archivos.
