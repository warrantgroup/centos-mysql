Base docker image to run a MySQL database server

Usage
-----

To create the image `warrantgroup/mysql`, execute the following ;

        docker build -t warrantgroup/mysql

To run the image and bind to port 3306:

        docker run -d -p 3306:3306 --name mysql warrantgroup/mysql

The first time that you run your container, a new user `admin` with all privileges 
will be created in MySQL with a random password. To get the password, check the logs
of the container by running:

        docker logs <CONTAINER_ID>

You can now test your deployment:

        mysql -uadmin -p

Setting a specific password for the admin account
-------------------------------------------------

If you want to use a preset password instead of a random generated one, you can
set the environment variable `MYSQL_PASS` to your specific password when running the container:

        docker run -d -p 3306:3306 -e MYSQL_PASS="password" warrantgroup/mysql

You can now test your deployment:

        mysql -uadmin -p"mypass"

The admin username can also be set via the `MYSQL_USER` environment variable.


Mounting the database file volume
---------------------------------

In order to persist the database data, you can mount a local folder from the host 
on the container to store the database files. To do so:

        docker run -d -v /path/host:/var/lib/mysql warrantgroup/mysql /bin/bash -c "/usr/bin/mysql_install_db"

This will mount the local folder `/path/host` inside the docker in `/var/lib/mysql` (where MySQL will store the database files by default). `mysql_install_db` creates the initial database structure.

Remember that this will mean that your host must have `/path/host` available when you run your docker image

After this you can start your MySQL image, but this time using `/path/host` as the database folder:

        docker run -d -p 3306:3306 -v /path/host:/var/lib/mysql warrantgroup/mysql


Migrating an existing MySQL Server
----------------------------------

In order to migrate your current MySQL server, perform the following commands from your current server:

To dump your databases structure:

        mysqldump -u<user> -p --opt -d -B <database name(s)> > /tmp/dbserver_schema.sql

To dump your database data:

        mysqldump -u<user> -p --quick --single-transaction -t -n -B <database name(s)> > /tmp/dbserver_data.sql

To import a SQL backup which is stored for example in the folder `/tmp` in the host, run the following:

        sudo docker run -d -v /tmp:/tmp tutum/mysql /bin/bash -c "/import.sh <user> <pass> /tmp/<dump.sql>"

Also, you can start the new database initializing it with the SQL file:

        sudo docker run -d -v /path/in/host:/var/lib/mysql -e STARTUP_SQL="/tmp/<dump.sql>" warrantgroup/mysql

Where `<user>` and `<pass>` are the database username and password set earlier and `<dump.sql>` is the name of the SQL file to be imported.

Environment variables
---------------------

`MYSQL_USER`: Set a specific username for the admin account (default 'admin').

`MYSQL_PASS`: Set a specific password for the admin account.

`STARTUP_SQL`: Defines one or more SQL scripts separated by spaces to initialize the database. Note that the scripts must be inside the container, so you may need to mount them.
