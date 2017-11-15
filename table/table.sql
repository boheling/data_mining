create table rating
(
    id                  integer not null auto_increment,
    user_id             integer,
    item_id             integer,
    rating              integer,
    primary key(id),
    index(user_id)
);

create table occupation
(
    occ_id                       integer not null auto_increment,
    occupation                   char(64), 
    primary key(occ_id),
    index(occupation)
);

create table user
(
    user_id                      integer,
    age                          char(16),
    gender                       char(16),
    occupation                   integer,
    zip_code                     char(16),
    primary key(user_id),
    index(occupation),
    index(occupation)
);

create table item
(
    item_id                      integer,
    movie_title                  char(64),
    release_date                 char(16), 
    video_release_date           char(64),  
    IMDb_URL                     char(64), 
    _unknown                     integer,
    _Action                      integer,
    Adventure                    integer,
    Animation                    integer,
    Children                     integer,
    Comedy                       integer,
    Crime                        integer,
    Documentary                  integer,
    Drama                        integer,
    Fantasy                      integer,
    Film_Noir                    integer,
    Horror                       integer,
    Musical                      integer,
    Mystery                      integer,
    Romance                      integer,
    Sci_Fi                       integer,
    Thriller                     integer,
    War                          integer,
    Western                      integer,
    primary key(item_id)
);

create table test
(
    test_id             integer not null auto_increment,
    user_id             integer,
    item_id             integer,
    primary key(test_id),
    index(user_id)
);
