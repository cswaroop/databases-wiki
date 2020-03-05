#Postgres Object Relational Map System

###Usage
In order to use any of the functionality provided by this project you must setup your `postgresql.conf` file to include:
```
  plv8.start_proc = 'xt.js_init'
```
That will ensure that any time a plv8 function is ran, the xTuple javascript environment is initialized for the connection.

The main purpose of this project is to provide an Object Relational Map (ORM) structure and APIs to retrieve and manipulate records as json objects, and to make function calls on the database.
