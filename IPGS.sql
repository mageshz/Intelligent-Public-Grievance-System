/* 
Doubts as of now:

1) not sure if the database overall uses the right design schema. Didn't make it totally normalized.(Not so sure :P)
2)Implemeting Blobs in image storage(Issues Table)
*/
DROP TABLE IF EXISTS Users Cascade ;
DROP TABLE IF EXISTS Issues Cascade;
DROP TABLE IF EXISTS Votes Cascade;
DROP TABLE IF EXISTS Comments Cascade;
DROP database IF EXISTS IPGS;

CREATE DATABASE IPGS;
\c IPGS;

CREATE TABLE Users(
	/*User ID, email, name, street address, city, pincode,  date of birth*/
	/* 255 varchar takes 1 byte of data*/
	 U_Id serial PRIMARY KEY ,
	 U_Email varchar(255) UNIQUE,
	 U_Name varchar(255) NOT NULL,
	 U_Gender varchar(10) NOT NULL,
	 U_StrAdr varchar(255),
	 U_City varchar(255) NOT NULL,
	 U_Pincode varchar(255) NOT NULL,
	 U_Dob date,
	 U_Admin boolean DEFAULT FALSE
	 /*will grant the user super powers basically cause mayhem at will. ONLY if set*/

);

CREATE TABLE Issues(
	/*Issue ID,Issue Aurthor, Issue Title, Content, Latitude, Longitude, Anonymous Flag, Issue Type, Timestamp with timezone */
	I_Id serial  PRIMARY KEY,
	I_Author serial references Users(U_Id) ON DELETE CASCADE ,
	I_Title varchar(80) NOT NULL,
	I_Content text NOT NULL,
	/* 6decimal places give precision of 0.111 m, hence using real*/
	I_Lat real NOT NULL,
	I_Lng real NOT NULL,
	I_Image varchar(255),
	/*image will be stored in a url for now*/
	/*C_Image image, Cant get this working now as I dont have that much 
	knowledge. However I understood this much PSQL has support for 
	Something called as blobs to store image ojects.
	link:http://www.postgresql.org/docs/9.1/static/lo.html*/
	I_AnonFlag boolean DEFAULT FALSE,
	/*0,False- non anonymous, 1,True- anonymous*/
	I_Type int NOT NULL,
	/*Number to identify the type of complain*/
	I_time timestamptz DEFAULT CURRENT_TIMESTAMP,
	I_Visible boolean DEFAULT TRUE
	/*True- visible false- NOT visible*/ 
);

CREATE TABLE Comments(
	/* Comment Author, Comment Content, Comment Time stamp with timezone, PRIMARY KEY[Comment ID, Comment Sequence Number]*/
	C_Id serial references Issues(I_Id) ON DELETE CASCADE,
	C_Author serial references Users(U_Id) ON DELETE CASCADE,
	C_Content text,
	/*Time stamp with timezone*/
	C_time timestamptz DEFAULT CURRENT_TIMESTAMP,
	C_SqNo serial,
	PRIMARY KEY (C_Id,C_Author,C_SqNo)
	


);

CREATE TABLE Votes(
	V_IssueId serial references Issues(I_Id) ON DELETE CASCADE,
	V_Author serial references Users(U_Id) ON DELETE CASCADE,
	V_Flag boolean,
	/*false-Dislike true- Like*/
	V_time timestamptz DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY(V_IssueId,V_Author)
);
