DROP DATABASE IF EXISTS GIGIHub;
CREATE DATABASE GIGIHub;

USE GIGIHub;

DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS post_tags;
DROP TABLE IF EXISTS comment_tags;
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS post_attachments;
DROP TABLE IF EXISTS tags;


create table users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username varchar(50) not null unique,
    email varchar(100) not null unique,
    -- password CHAR(60) BINARY not null,
    bio_description varchar(255) default '',
    join_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

create table posts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id int references users(id) ON DELETE CASCADE,
    body text(1000) not null,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP ON UPDATE CURRENT_TIMESTAMP 
);

create table comments (
    id int auto_increment primary key,
    post_id int references posts(id) ON DELETE CASCADE,
    user_id int references users(id) ON DELETE CASCADE,
    body varchar(1000) not null,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP ON UPDATE CURRENT_TIMESTAMP 
);

create table comment_attachments (
    id int auto_increment primary key,
    comment_id int references comments(id) on delete cascade,
    filename varchar(255) not null,
    mimetype varchar(100) not null
);

create table post_attachments (
    id int auto_increment primary key,
    post_id int references posts(id) ON DELETE CASCADE,
    filename varchar(255) not null,
    mimetype varchar(100) not null
);

create table tags (
    id int auto_increment primary key,
    name varchar(255) not null unique,
    created_at timestamp default current_timestamp 
);

create table post_tags (
    post_id int references posts(id) ON DELETE CASCADE,
    tag_id int references tags(id) ON DELETE CASCADE,
    created_at timestamp default current_timestamp,

    primary key(tag_id, post_id)
);

create table comment_tags (
    comment_id int references comments(id) ON DELETE CASCADE,
    tag_id int references tags(id) ON DELETE CASCADE,
    created_at timestamp default current_timestamp,

    primary key(tag_id, comment_id)
);

insert into users(username, email, bio_description) values
('dummy', 'dummy@dummy.com', 'im a dummi1'), ('dummy2', 'dummy2@dummy.com', 'im a dummy two');

insert into posts(user_id, body) values(1, 'generasi #gigih lets goooo #SurpassYourLimit'), (2, 'Generasi #gigih 2021'), (1, '#SurpassYourLimit');

insert into comments(post_id, user_id, body) values(1, 2, 'hello #gigih fellow'), (2, 1, '#SurpassYourLimit');

insert into tags(name) values('gigih'), ('SurpassYourLimit');

insert into post_tags(post_id, tag_id) values(1, 1), (1, 2), (2, 1), (3, 2);

insert into comment_tags(comment_id, tag_id) values(1, 1), (2, 2);

insert into post_attachments(post_id, filename, mimetype) values (1, 'dummy_post_1.png', 'image/png'), (1, 'dummy_post_2.png', 'image/png');

insert into comment_attachments(comment_id, filename, mimetype) values(1, 'dummy_comment_1.png', 'image/png');