# create database if not exists Music default character set utf8;
Use Music;
drop table if exists Artist;
drop table if exists album;
drop table if exists genre;
drop table if exists track;

create table Artist (
    artist_id integer not null auto_increment,
    name varchar(225),
    primary key(artist_id)
   ) Engine = innoDB;

   create table Album (
    album_id integer not null AUTO_INCREMENT,
	title varchar(225),
	artist_id integer,
	primary key(album_id),
	index using btree(title),

	constraint fk_artist foreign key (artist_id) references Artist (artist_id)
	 on delete cascade
	 on update cascade
   ) Engine = INNODB;

   create table Genre (
    genre_id integer not null AUTO_INCREMENT,
	name varchar(225),
	primary key(genre_id),
    index using btree (name)
   ) Engine = INNODB;

   create table Track (
    track_id integer not null AUTO_INCREMENT,
    title varchar (255),
    rating integer,
    len integer,
    count integer,
    album_id integer,
    genre_id integer,
    primary key(track_id),
	index using btree(title),

	constraint fk_album foreign key (album_id) references Album (album_id)
        on delete cascade on UPDATE cascade,
    constraint fk_gnere foreign key (genre_id) references Genre (genre_id)
   ) Engine = INNODB;

insert into Artist (name) VALUES ('Led Zepplin');
insert into Artist (name) VALUES ('AC/DC');
insert into Artist (name) VALUES ('DREAM');
INSERT INTO Artist (name) VALUES ('Pink Floyd');
INSERT INTO Artist (name) VALUES ('The Beatles');
INSERT INTO Artist (name) VALUES ('Metallica');
INSERT INTO Artist (name) VALUES ('Nirvana');
INSERT INTO Artist (name) VALUES ('Queen');
INSERT INTO Artist (name) VALUES ('Guns N\' Roses');
INSERT INTO Artist (name) VALUES ('Red Hot Chili Peppers');
INSERT INTO Artist (name) VALUES ('Linkin Park');
INSERT INTO Artist (name) VALUES ('U2');
INSERT INTO Artist (name) VALUES ('Radiohead');

insert into Genre (name) values ('Rock');
insert into Genre (name) values ('Metal');
INSERT INTO Genre (name) VALUES ('Pop');
INSERT INTO Genre (name) VALUES ('Hip Hop');
INSERT INTO Genre (name) VALUES ('Country');
INSERT INTO Genre (name) VALUES ('Jazz');
INSERT INTO Genre (name) VALUES ('Blues');
INSERT INTO Genre (name) VALUES ('Electronic');
INSERT INTO Genre (name) VALUES ('R&B');
INSERT INTO Genre (name) VALUES ('Classical');
INSERT INTO Genre (name) VALUES ('Reggae');
INSERT INTO Genre (name) VALUES ('Funk');

INSERT INTO Album (title, artist_id) VALUES ('ISTJ', 3);
INSERT INTO Album (title, artist_id) VALUES ('IV', 1);
INSERT INTO Album (title, artist_id) VALUES ('The Dark Side of the Moon', 4);
INSERT INTO Album (title, artist_id) VALUES ('Abbey Road', 5);
INSERT INTO Album (title, artist_id) VALUES ('Master of Puppets', 6);
INSERT INTO Album (title, artist_id) VALUES ('Nevermind', 7);
INSERT INTO Album (title, artist_id) VALUES ('A Night at the Opera', 8);
INSERT INTO Album (title, artist_id) VALUES ('Appetite for Destruction', 9);
INSERT INTO Album (title, artist_id) VALUES ('Californication', 10);
INSERT INTO Album (title, artist_id) VALUES ('Hybrid Theory', 11);
INSERT INTO Album (title, artist_id) VALUES ('The Joshua Tree', 12);
INSERT INTO Album (title, artist_id) VALUES ('OK Computer', 13);

insert into Track (title, rating, len, count, album_id, genre_id)
VALUES ('ISTJ', 10, 300, 5, 1, 3 );
insert into Track (title, rating, len, count, album_id, genre_id)
VALUES ('Stairway', 5, 482, 0, 2, 1 );
INSERT INTO Track (title, rating, len, count, album_id, genre_id)
VALUES ('Wish You Were Here', 9, 334, 8, 3, 1);
INSERT INTO Track (title, rating, len, count, album_id, genre_id)
VALUES ('Come Together', 7, 259, 3, 4, 1);
INSERT INTO Track (title, rating, len, count, album_id, genre_id)
VALUES ('Enter Sandman', 8, 332, 6, 5, 2);
INSERT INTO Track (title, rating, len, count, album_id, genre_id)
VALUES ('Smells Like Teen Spirit', 9, 274, 9, 6, 2);
INSERT INTO Track (title, rating, len, count, album_id, genre_id)
VALUES ('Bohemian Rhapsody', 10, 355, 12, 7, 1);
INSERT INTO Track (title, rating, len, count, album_id, genre_id)
VALUES ('Sweet Child o\' Mine', 8, 356, 7, 8, 1);
INSERT INTO Track (title, rating, len, count, album_id, genre_id)
VALUES ('Under the Bridge', 7, 263, 4, 9, 6);
INSERT INTO Track (title, rating, len, count, album_id, genre_id)
VALUES ('In the End', 9, 216, 10, 10, 6);
INSERT INTO Track (title, rating, len, count, album_id, genre_id)
VALUES ('With or Without You', 8, 296, 6, 11, 3);
INSERT INTO Track (title, rating, len, count, album_id, genre_id)
VALUES ('Paranoid Android', 9, 386, 7, 12, 5);

alter table Track add year date;

# update
select * from Album;
select * from Artist;
select * from Track;
select * from Genre;

select title from Album where title like 'A%';

select name from Artist where name like '%e%';

select album.title, Artist.name from Album join artist on
    Album.artist_id = Artist.artist_id;

select Artist.artist_id, Track.title as Song, Artist.name as Singer, Album.title as EP, Genre.name
from Track join Genre join Album join Artist on
Track.genre_id = Genre.genre_id and Track.album_id = Album.album_id
and Album.artist_id = Artist.artist_id
order by Artist.artist_id;


USE music;

DELIMITER //

CREATE PROCEDURE Details()
BEGIN
    SELECT Artist.artist_id, Track.title AS Song, Artist.name AS Singer, Album.title AS EP, Genre.name
    FROM Track
    JOIN Genre ON Track.genre_id = Genre.genre_id
    JOIN Album ON Track.album_id = Album.album_id
    JOIN Artist ON Album.artist_id = Artist.artist_id
    ORDER BY Artist.artist_id;
END //

DELIMITER;

CALL Details;

# use music;
DROP PROCEDURE IF EXISTS Track_Details;

DELIMITER //
Create Procedure Track_Details()
BEGIN
    SELECT Track.track_id, track.title, genre.name 
    from Track join genre 
    on track.genre_id = genre.genre_id 
    order by track.track_id;
END //
DELIMITER ;

CALL Track_Details;

create table Composer(
    composer_id integer not null auto_increment,
    name varchar(225),
    track_id integer,
    primary key (composer_id),
    index using btree (name),
     CONSTRAINT fk_track FOREIGN KEY (track_id) REFERENCES Track(track_id)
     on delete CASCADE on update CASCADE
) Engine = InnoDB;


INSERT INTO Composer (name, track_id) VALUES ('Moonshine', 1);
INSERT INTO Composer (name, track_id) VALUES ('Sunset', 2);
INSERT INTO Composer (name, track_id) VALUES ('Stardust', 3);
INSERT INTO Composer (name, track_id) VALUES ('Morning Breeze', 4);
INSERT INTO Composer (name, track_id) VALUES ('Twilight', 5);
INSERT INTO Composer (name, track_id) VALUES ('Midnight Sonata', 6);
INSERT INTO Composer (name, track_id) VALUES ('Daydream', 7);
INSERT INTO Composer (name, track_id) VALUES ('Harmony', 8);
INSERT INTO Composer (name, track_id) VALUES ('Melody', 9);
INSERT INTO Composer (name, track_id) VALUES ('Serenade', 10);

DELIMITER //
ALTER Procedure Track_details()
BEGIN
    SELECT track.track_id, track.title, genre.name, composer.name
    from Track Join Genre and Track join Composer
    on track.genre_id = genre.genre_id and track.track_id = composer.track_id
    order by track-id;
END //
DELIMITER;
