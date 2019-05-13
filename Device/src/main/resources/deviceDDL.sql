drop database if exists CMPE273;
create database CMPE273;
use CMPE273;

create table device (
                        deviceId varchar(10),
                        modelYear varchar(10),
                        batteryLevel int,
                        registered boolean,
                        notify boolean,

                        primary key (deviceId)
);

create table record (
                        userId varchar(10),
                        recordId int,
                        deviceId varchar(10),
                        weight double,
                        time timestamp,

                        primary key (userId, recordId),
                        foreign key (deviceId) references device(deviceId) on delete cascade
);

create table bootstrap (
                           deviceId varchar(10),
                           bootstrap boolean,

                           primary key (deviceId)
);

insert into  device values('A1', 'M2016', 3, true, true);
insert into  device values('A2', 'M2017', 2, true, true);
insert into  record values('testUser', 1, 'A1', 70.2, current_timestamp());
insert into  record values('testUser', 2, 'A1', 71.1, current_timestamp());
insert into  record values('testUser2', 1, 'A2',71.1, current_timestamp());
insert into  record values('testUser2', 2, 'A2', 71.1, current_timestamp());

select * from device;
select * from record;
select * from bootstrap;
