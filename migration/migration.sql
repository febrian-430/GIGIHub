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
    user_id int references users(id),
    body text(1000) not null,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP ON UPDATE CURRENT_TIMESTAMP 
);

create table comments (
    id int auto_increment primary key,
    post_id int references posts(id),
    user_id int references users(id),
    body varchar(1000) not null,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP ON UPDATE CURRENT_TIMESTAMP 
);

create table post_attachments (
    id int auto_increment primary key,
    post_id int references posts(id),
    file_path varchar(255) not null
);

create table tags (
    id int auto_increment primary key,
    name varchar(255) not null unique,
    created_at timestamp default current_timestamp 
);

create table post_tags (
    post_id int references posts(id),
    tag_id int references tags(id),
    created_at timestamp default current_timestamp,

    primary key(tag_id, post_id)
);

create table comment_tags (
    comment_id int references comments(id),
    tag_id int references tags(id),
    created_at timestamp default current_timestamp,

    primary key(tag_id, comment_id)
);

insert into users(username, email, bio_description) values
('dummy', 'dummy@dummy.com', 'im a dummi1'), ('dummy2', 'dummy2@dummy.com', 'im a dummy two');

insert into posts(user_id, body) values(1, 'generasi #gigih lets goooo #gobeyond'), (2, 'Generasi #gigih 2021'), (1, '#gobeyond');

insert into comments(post_id, user_id, body) values(1, 2, 'hello #gigih fellow'), (2, 1, '#gobeyond');

insert into tags(name) values('#gigih'), ('#gobeyond');

insert into post_tags(post_id, tag_id) values(1, 1), (1, 2), (2, 2), (3, 2);

insert into comment_tags(comment_id, tag_id) values(1, 1), (2, 2);

select id, name, sum(count)
from (
    select t.id, t.name, count(pt.post_id) as count
    from tags t join post_tags pt on t.id = pt.tag_id
    group by t.id
    union all
    select t.id, t.name, count(ct.comment_id) as count
    from tags t join comment_tags ct on t.id = ct.tag_id
    group by t.id
) tag_counts
group by id, name
order by sum(count) desc