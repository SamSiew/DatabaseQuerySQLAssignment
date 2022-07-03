-- FIT DATABASE UNDERGRADUATE UNITS ASSIGNMENT 2 / S1 / 2019
-- FILL IN THE FOLLOWING:
--Unit Code: FIT3171
--Student ID: 28098552
--Student Full Name: Siew Ming Shern
--Student email:msie0001@student.monash.edu
--Tutor Name: Nursyarizan Mohd Akbar

/*  --- COMMENTS TO YOUR MARKER --------
Assumption: 
1) Information provided on Task may not shared with other Task unless specified.
2) Information provided on Task 3.1 may be shared with Task 3.2, Task 3.3, Task 3.4 but not other Task.
3) removing attribute or table given table in conceptual model will not be used to 
adhere Assignment requirement even if such action will improve current relational model.
4) TASK 1.2 will drop all table required from task 1 to task 4 inclusively.

*/

--Q1
/*
TASK 1.1 BELOW
*/
--vehicle_unit
CREATE TABLE vehicle_unit (
    garage_code             NUMBER(2) NOT NULL,
    vunit_id                NUMBER(6) NOT NULL,
    vunit_purchase_price    NUMBER(7,2) NOT NULL,
    vunit_exhibition_flag   CHAR(1) NOT NULL,
    vehicle_insurance_id    VARCHAR2(20 BYTE) NOT NULL,
    vunit_rego              VARCHAR2(8) NOT NULL
);

ALTER TABLE vehicle_unit ADD CONSTRAINT chk_vunit_price CHECK ( vunit_purchase_price >= 0 );

ALTER TABLE vehicle_unit
    ADD CHECK ( vunit_exhibition_flag  IN (
        'T',
        'F'
    ) );

COMMENT ON COLUMN vehicle_unit.vehicle_insurance_id IS
    'Vehicle insurance identifier - identifies a vehicle type as determined by insurer';

COMMENT ON COLUMN vehicle_unit.garage_code IS
    'Garage number ';

ALTER TABLE vehicle_unit ADD CONSTRAINT vehicle_unit_pk PRIMARY KEY ( vunit_id,
                                                                      garage_code );

ALTER TABLE vehicle_unit ADD CONSTRAINT vunit_rego_uniq UNIQUE ( vunit_rego );

ALTER TABLE vehicle_unit
    ADD CONSTRAINT garage_vunit FOREIGN KEY ( garage_code )
        REFERENCES garage ( garage_code );

ALTER TABLE vehicle_unit
    ADD CONSTRAINT vdetail_vunit FOREIGN KEY ( vehicle_insurance_id )
        REFERENCES vehicle_detail ( vehicle_insurance_id );

--reserve
CREATE TABLE reserve (
    garage_code                NUMBER(2) NOT NULL,
    vunit_id                   NUMBER(6) NOT NULL,
    reserve_date_time_placed   DATE NOT NULL,
    renter_no                  NUMBER(6) NOT NULL
);

COMMENT ON COLUMN reserve.renter_no IS
    'Renter identifier';

COMMENT ON COLUMN reserve.garage_code IS
    'Garage number ';

ALTER TABLE reserve
    ADD CONSTRAINT reserve_pk PRIMARY KEY ( reserve_date_time_placed,
                                            vunit_id,
                                            garage_code );
ALTER TABLE reserve
    ADD CONSTRAINT renter_reserve FOREIGN KEY ( renter_no )
        REFERENCES renter ( renter_no );

ALTER TABLE reserve
    ADD CONSTRAINT vunit_reserve FOREIGN KEY ( vunit_id,
                                               garage_code )
        REFERENCES vehicle_unit ( vunit_id,
                                  garage_code );
--loan
CREATE TABLE loan (
    garage_code               NUMBER(2) NOT NULL,
    vunit_id                  NUMBER(6) NOT NULL,
    loan_date_time            DATE NOT NULL,
    loan_due_date             DATE NOT NULL,
    loan_actual_return_date   DATE,
    renter_no                 NUMBER(6) NOT NULL
);

COMMENT ON COLUMN loan.renter_no IS
    'Renter identifier';

COMMENT ON COLUMN loan.garage_code IS
    'Garage number ';
    
ALTER TABLE loan ADD CONSTRAINT chk_loan_due_date CHECK ( loan_due_date >= loan_date_time  );

ALTER TABLE loan ADD CONSTRAINT chk_loan_return_date CHECK ( loan_actual_return_date  >= loan_date_time  );

ALTER TABLE loan
    ADD CONSTRAINT loan_pk PRIMARY KEY ( loan_date_time,
                                         vunit_id,
                                         garage_code );

ALTER TABLE loan
    ADD CONSTRAINT renter_loan FOREIGN KEY ( renter_no )
        REFERENCES renter ( renter_no );

ALTER TABLE loan
    ADD CONSTRAINT vunit_loan FOREIGN KEY ( vunit_id,
                                            garage_code )
        REFERENCES vehicle_unit ( vunit_id,
                                  garage_code );

     
/*
TASK 1.2 BELOW
 
*/

DROP TABLE vendor_vehicle PURGE;

DROP TABLE vendor PURGE;

DROP TABLE vehicle_feature PURGE;

DROP TABLE feature PURGE;

DROP TABLE loan PURGE;  

DROP TABLE reserve PURGE;

DROP TABLE renter PURGE;

DROP TABLE vehicle_unit PURGE;

DROP TABLE collection PURGE;

DROP TABLE garage PURGE;

DROP TABLE manager PURGE;

DROP TABLE vehicle_detail PURGE;

DROP TABLE manufacturer PURGE;

--Q2
/*
TASK 2.1 BELOW

*/

--vehicle-detail
INSERT INTO vehicle_detail VALUES (
    'sports-ute-449-12b',
    'Toyota Hilux SR Manual 4x2 MY14',
    'M',
    200,
    TO_DATE('2018','YYYY'),
    2.8,
    (select manufacturer_id from MANUFACTURER where manufacturer_name = 'Toyota')
);

INSERT INTO VEHICLE_FEATURE VALUES (
    (SELECT FEATURE_CODE FROM FEATURE WHERE feature_details = 'metallic silver' )
    ,'sports-ute-449-12b'
);

INSERT INTO VEHICLE_FEATURE VALUES (
    (SELECT FEATURE_CODE FROM FEATURE WHERE feature_details = 'aluminium tray' )
    ,'sports-ute-449-12b'
);

INSERT INTO vendor_vehicle VALUES (
    'sports-ute-449-12b',
    1
);

INSERT INTO vendor_vehicle VALUES (
    'sports-ute-449-12b',
    2
);

INSERT INTO vehicle_unit VALUES (
    (select GARAGE_CODE from GARAGE where 
	GARAGE_EMAIL = 'caulfield@rdbms.example.com'),
    (select garage_count_vehicles from GARAGE WHERE 
	GARAGE_EMAIL = 'caulfield@rdbms.example.com')+ 1,
    50000,
    'F',
    'sports-ute-449-12b',
    'RD3161'
);

update GARAGE
SET garage_count_vehicles = garage_count_vehicles  + 1
Where GARAGE_CODE = (select GARAGE_CODE from GARAGE 
where GARAGE_EMAIL = 'caulfield@rdbms.example.com');

INSERT INTO vehicle_unit VALUES (
    (select GARAGE_CODE from GARAGE 
    where GARAGE_EMAIL = 'southy@rdbms.example.com'),
    (select GARAGE_COUNT_VEHICLES from GARAGE 
    where GARAGE_EMAIL = 'southy@rdbms.example.com') + 1,
    50000,
    'F',
    'sports-ute-449-12b',
    'RD3141'
);

update GARAGE
SET garage_count_vehicles = garage_count_vehicles  + 1
Where GARAGE_CODE = (select GARAGE_CODE from GARAGE 
where GARAGE_EMAIL = 'southy@rdbms.example.com');

INSERT INTO vehicle_unit VALUES (
    (select GARAGE_CODE from GARAGE 
    where GARAGE_EMAIL = 'melbournec@rdbms.example.com'),
    (select GARAGE_COUNT_VEHICLES from GARAGE 
    where GARAGE_EMAIL = 'melbournec@rdbms.example.com') + 1,
    50000,
    'F',
    'sports-ute-449-12b',
    'RD3000'
);

update GARAGE
SET garage_count_vehicles = garage_count_vehicles  + 1
Where GARAGE_CODE = (select GARAGE_CODE from GARAGE 
where GARAGE_EMAIL = 'melbournec@rdbms.example.com');

COMMIT;

/*
TASK 2.2 BELOW

*/

CREATE SEQUENCE renter_renter_no_seq
START WITH    10
INCREMENT BY  1
NOCACHE
NOCYCLE;

/*
TASK 2.3 BELOW

*/

DROP SEQUENCE renter_renter_no_seq;


--Q3
/*
TASK 3.1 BELOW

*/

INSERT INTO RENTER VALUES (
    renter_renter_no_seq.nextval,
    'Van',
    'DIESEL',
    '10 Microsoft Way',
    'Microville',
    '3000',
    'vandiesel@google.example',
    '0499001245',
    (select GARAGE_CODE from GARAGE where GARAGE_NAME = 'Caulfield VIC' )
);

COMMIT;

/*
TASK 3.2 BELOW

*/

INSERT INTO RESERVE VALUES (
    (select GARAGE_CODE from GARAGE 
     where GARAGE_NAME = 'Melbourne Central VIC'),
    (select VUNIT_ID from VEHICLE_UNIT
     where GARAGE_CODE = (select GARAGE_CODE from GARAGE 
     where GARAGE_NAME = 'Melbourne Central VIC')
     and vehicle_insurance_id = 'sports-ute-449-12b'),
     to_date('04-May-2019 4:00:00 PM', 'dd-mon-yyyy HH:MI:SS AM'),
     renter_renter_no_seq.currval
);

COMMIT;

/*
TASK 3.3 BELOW
*/ 
INSERT INTO LOAN VALUES (
    (select GARAGE_CODE from GARAGE where GARAGE_NAME = 'Melbourne Central VIC'),
    
    (SELECT VUNIT_ID FROM VEHICLE_UNIT WHERE VEHICLE_INSURANCE_ID = 'sports-ute-449-12b' AND 
    GARAGE_CODE =(select GARAGE_CODE from GARAGE where GARAGE_NAME = 'Melbourne Central VIC') ),
     
     (select to_date('04-May-2019 4:00:00 PM', 'dd-mon-yyyy HH:MI:SS AM') - INTERVAL '2' HOUR + INTERVAL '7' DAY from dual),
     
     (select to_date('04-May-2019 4:00:00 PM', 'dd-mon-yyyy HH:MI:SS AM') - INTERVAL '2' HOUR  + INTERVAL '7' DAY + INTERVAL '7' DAY from dual),
     
     null,
     
     (select RENTER_NO from RENTER where RENTER_FNAME = 'Van' and RENTER_LNAME = 'DIESEL')
);

COMMIT;
 
/*
TASK 3.4 BELOW

*/

UPDATE LOAN 
SET LOAN_ACTUAL_RETURN_DATE = 
(select to_date('04-May-2019 4:00:00 PM', 'dd-mon-yyyy HH:MI:SS AM') - INTERVAL '2' HOUR  + INTERVAL '7' DAY + INTERVAL '7' DAY from dual)
WHERE RENTER_NO = (select RENTER_NO from RENTER where RENTER_FNAME = 'Van' and RENTER_LNAME = 'DIESEL' ) AND 
GARAGE_CODE = (select GARAGE_CODE from GARAGE where GARAGE_NAME = 'Melbourne Central VIC') AND 
LOAN_DATE_TIME = (select to_date('04-May-2019 4:00:00 PM', 'dd-mon-yyyy HH:MI:SS AM') - INTERVAL '2' HOUR + INTERVAL '7' DAY from dual) AND
VUNIT_ID = (SELECT VUNIT_ID FROM VEHICLE_UNIT WHERE VEHICLE_INSURANCE_ID = 'sports-ute-449-12b' 
AND GARAGE_CODE =(select GARAGE_CODE from GARAGE where GARAGE_NAME = 'Melbourne Central VIC') );

commit;

INSERT INTO LOAN VALUES (
	(select GARAGE_CODE from GARAGE where GARAGE_NAME = 'Melbourne Central VIC'),

    (SELECT VUNIT_ID FROM VEHICLE_UNIT WHERE VEHICLE_INSURANCE_ID = 'sports-ute-449-12b' AND GARAGE_CODE =(select GARAGE_CODE from GARAGE where GARAGE_NAME = 'Melbourne Central VIC') ),

	(select to_date('04-May-2019 4:00:00 PM', 'dd-mon-yyyy HH:MI:SS AM') - INTERVAL '2' HOUR  + INTERVAL '7' DAY + INTERVAL '7' DAY from dual),
		 
	(select to_date('04-May-2019 4:00:00 PM', 'dd-mon-yyyy HH:MI:SS AM') - INTERVAL '2' HOUR  + INTERVAL '7' DAY + INTERVAL '7' DAY + INTERVAL '7' DAY from dual),

	null,

	(select RENTER_NO from RENTER where RENTER_FNAME = 'Van' and RENTER_LNAME = 'DIESEL' )
);

COMMIT;

--Q4
/*
TASK 4.1 BELOW

*/

ALTER TABLE VEHICLE_UNIT 
ADD VEHICLE_CONDITION  CHAR(1) DEFAULT 'G' NOT NULL;

ALTER TABLE vehicle_unit
    ADD CHECK ( vehicle_condition IN (
        'G',
        'M',
        'W'
    ) );

/*
TASK 4.2 BELOW
*/


ALTER TABLE loan ADD return_garage_code NUMBER(2);

ALTER TABLE loan
    ADD CONSTRAINT loan_garage FOREIGN KEY ( return_garage_code )
        REFERENCES garage ( garage_code );
      
UPDATE LOAN 
SET return_garage_code  = GARAGE_CODE
where LOAN_ACTUAL_RETURN_DATE is not null;

COMMIT;

/*
TASK 4.3 BELOW
*/

CREATE TABLE collection (
    garage_code     NUMBER(2) NOT NULL,
    special_field   CHAR(1) NOT NULL,
    man_id          NUMBER(2) NOT NULL
);

ALTER TABLE collection ADD CONSTRAINT collection_pk PRIMARY KEY ( garage_code,special_field);

COMMENT ON COLUMN collection.special_field IS
    'Garage classification - (B)ike, regular (M)otorcar, (S)portscar, (F)ull Collection';

ALTER TABLE collection
    ADD CHECK ( special_field IN (
        'B',
        'M',
        'S',
        'F'
    ) );

COMMENT ON COLUMN collection.garage_code IS
    'Garage number ';

COMMENT ON COLUMN collection.man_id IS
    'Managers assigned identifier';

ALTER TABLE collection
    ADD CONSTRAINT collect_garage FOREIGN KEY ( garage_code )
        REFERENCES garage ( garage_code ) ON DELETE CASCADE;

ALTER TABLE collection
    ADD CONSTRAINT collect_man FOREIGN KEY ( man_id )
        REFERENCES manager ( man_id ) ON DELETE CASCADE;

INSERT INTO collection VALUES ((select GARAGE_CODE from GARAGE
where GARAGE_EMAIL = 'caulfield@rdbms.example.com'),'F',1);

INSERT INTO collection VALUES ((select GARAGE_CODE from GARAGE
where GARAGE_EMAIL = 'melbournec@rdbms.example.com'),'S',1);

COMMIT;

INSERT INTO collection VALUES ((select GARAGE_CODE from GARAGE
where GARAGE_EMAIL = 'southy@rdbms.example.com'),'F',2);

INSERT INTO collection VALUES ((select GARAGE_CODE from GARAGE
where GARAGE_EMAIL = 'melbournec@rdbms.example.com'),'B',2);

INSERT INTO collection VALUES ((select GARAGE_CODE from GARAGE
where GARAGE_EMAIL = 'melbournec@rdbms.example.com'),'M',2);

COMMIT;

ALTER TABLE GARAGE DROP CONSTRAINT manager_garage;

ALTER TABLE GARAGE DROP COLUMN man_id;














