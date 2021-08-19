# GIGIHub
GIGIHub is a REST API-only social media application created as a final project in Generasi GIGIH 2021.

Features and Endpoints
| URL | Function | Request Params| Note |
| --- | --- | --- | --- |
| `POST` /users | Create a user | `body`<ul><li>`username`: String</li><li>`email`: String</li><li>`bio_description`: String</li></ul> | <ul><li>Returns `201` when successful</li><li>Returns `400` when email or username is empty, email already exists, or username already exists</li><li>Returns `500` if an unknown error occured</li></ul> |
|`POST` /posts|Create a post|`body`<ul><li>`user_id`: User id (positive int)</li><li>`body`: String</li><li>`attachments`: Files</li></ul>| <ul><li>Returns `201` when successful</li><li>Returns `400` when body has more than 1000 characters</li><li>Returns `404` when `user_id` does not exist in database</li><li>Returns `500` if an unknown error occured</li></ul> |
|`GET` /posts|Get an array of posts sorted by latest post|`Query Parameter`<ul><li>`tag`: optional, to filter posts by tag</li></ul>|<ul><li>Returns `200` with `posts` as the result</li><li>Returns `500` if an unknown error occured</li></ul>|
|`GET` /posts/:id|Get a post detail|`Path Parameter` <ul><li>`id`: Post id (positive int)</li></ul>|<ul><li>Returns `200` with `post` containing the post detail</li><li>Returns `404` if given `id` does not exist in database</li><li>Returns `500` if an unknown error occured</li></ul>|


