-- creating database for the Olym
create table if not exists Country(
    country_id int not null auto_increment,
    country_name varchar(225),
    country_code char(3),
    primary key(country_id)
);

create table if not exists Sports(
    sports_id int not null auto_increment,
    sports_name varchar(225)
)engine = innodb;

create table if not exists Athlete
    (athlete_id int not null auto_increment,
     first_name varchar(225),
     middle_name varchar(225),
     last_name varchar(225),
     sports_id int,
     country_id int,
    primary key(athlete_id),

    constraint fk_sports foreign key (sports_id) references Sports(sports_id)
    on delete cascade on update cascade,

    constraint fk_country foreign key (country_id)  references Country(country_id)
    on delete cascade on update cascade
    )ENGINE =innodb;

create table if not exists Event(
    event_id int primary key not null auto_increment,
    event_name varchar(225),
    sport_id int,
    constraint fk_sport foreign key (sport_id) references Sports(sports_id)
        on delete cascade on update cascade
)engine = innodb;

create table if not exists Venue(
    venue_id int primary key not null auto_increment,
    venue_name varchar(225),
    location varchar(225)
);

create table if not exists Schedule(
    schedule_id int primary key not null auto_increment,
    event_id int,
    venue_id int,
    start_date date,
    end_date date,
    constraint fk_event foreign key(event_id) references Event(event_id)
    on delete cascade on update cascade,
    constraint fk_venue foreign key(venue_id) references Venue(venue_id)
    on delete cascade on update cascade
    );

create table if not exists Result(
    result_id int primary key not null auto_increment,
    athlete_id int,
    event_id int,
    result_value varchar(50),
    constraint fk_athlete foreign key (athlete_id) references Athlete(athlete_id) on delete cascade on update cascade,
    constraint  fk_event foreign key (event_id) references Event(event_id) on delete cascade on update cascade                              
);

-- from the livedb --