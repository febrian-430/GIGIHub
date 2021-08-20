# GIGIHub
GIGIHub is a REST API-only social media application created as a final project in Generasi GIGIH 2021.

## Features and Endpoints
| URL | Function | Request Params| Note |
| --- | --- | --- | --- |
| `POST` /users | Create a user | `body`<ul><li>`username`: String</li><li>`email`: String</li><li>`bio_description`: String</li></ul> | <ul><li>Returns `201` if successful</li><li>Returns `400` when email or username is empty, email already exists, or username already exists</li><li>Returns `500` if an unknown error occured</li></ul> |
|`GET` /users/:username|Get a user detail|`path parameter`<ul><li>`username`: String</li></ul>|<ul><li>Returns `200` with `user` containing the user detail</li><li>Returns `404` if given `username` does not exist in database</li><li>Returns `500` if an unknown error occured</li></ul>|
|`POST` /posts|Create a post|`body`<ul><li>`user_id`: User ID (positive int)</li><li>`body`: String</li><li>`attachments`: Files</li></ul>| <ul><li>Returns `201` if successful</li><li>Returns `400` when body has more than 1000 characters</li><li>Returns `404` when `user_id` does not exist in database</li><li>Returns `500` if an unknown error occured</li></ul> |
|`GET` /posts|Get an array of posts sorted by latest post|`query parameter`<ul><li>`tag`: optional, to filter posts by tag</li></ul>|<ul><li>Returns `200` with `posts` as the result</li><li>Returns `500` if an unknown error occured</li></ul>|
|`GET` /posts/:id|Get a post detail|`path parameter` <ul><li>`id`: Post ID (positive int)</li></ul>|<ul><li>Returns `200` with `post` containing the post detail</li><li>Returns `404` if given `id` does not exist in database</li><li>Returns `500` if an unknown error occured</li></ul>|
|`POST` /comments|Create a comment on a post|`body` <ul><li>`user_id`: User ID (positive int)</li><li>`post_id`: Post ID (positive int)</li><li>`body`: String</li><li>`attachment`: a file</li></ul>|<ul><li>Returns `201` if succcessful</li><li>Returns `400` if `user_id` or `post_id` is empty</li><li>Returns `404` if given `user_id` or `post_id` does not exist in database</li><li>Returns `500` if an unknown error occured|
|`GET` /tags/trending|Get top 5 most frequent tags mentioned within the last 24 hour||<ul><li>Returns `200` with `tags` containing the result</li><li>Returns `500` if an unknown error occured</li></ul>|

## Prerequisite
To run this application on your local machine, first thing first you can `clone` this repository

	git clone https://github.com/febrian-430/GIGIHub.git

and install the following
- `Ruby ver 3.0.2` 
	- <a href="https://github.com/rbenv/rbenv"> rbenv</a> (preferred)
	- <a href="https://www.ruby-lang.org/en/downloads/"> Official Ruby download page</a>
- <a href="https://dev.mysql.com/downloads/installer/"> `MySQL Server`</a>

Note: make sure that `Ruby` and `MySQL` are installed, and `MySQL` is running. 

<b>Next</b>, we need to install these ruby `gems`

	gem install sinatra puma sinatra-contrib dotenv rspec simplecov mysql2
When installing `mysql2`, you might encounter an error. In that case, you can read <a href="https://github.com/brianmario/mysql2#installing"> here </a> about how to properly install it depending on your machine.

<b>After installing the dependencies, make sure that MySQL server is running</b>. If you are on Ubuntu, you can check it by 
	
	sudo service mysql status
if it is stopped, then

	sudo service mysql start

<b>After starting the MySQL server, run the migration file</b>
		
	mysql -u your_mysql_user [-p if the user has password] < ./migration/migration.sql
You may need to change the database credential in the `.env` file, and fill it according to your MySQL credentials.
Note: if you want to change the  `DB_NAME` as well, you have to change the database name in the migration file, and rerun the above command.

<b>Finally</b>,  assuming you are on the app directory, run the application
	
	ruby main.rb

The server should be listening on `localhost:4567` by default.
## Test
To run the unit tests, firstly move to the app directory, or:
		
	cd ./GIGIHub 
and then run this command to test all unit tests

	rspec spec/
or 
	
	rspec spec/models
to test the models only

	rspec spec/controllers
to test the controllers only
