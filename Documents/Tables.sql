CREATE TABLE "chat" 
  ( 
     "chat_id" SERIAL NOT NULL PRIMARY KEY, 
     NAME      VARCHAR(20) NOT NULL 
  ); 

CREATE TABLE "device" 
  ( 
     "device_id" SERIAL PRIMARY KEY, 
     NAME        VARCHAR(20) NOT NULL 
  ); 

CREATE TABLE "hashtag" 
  ( 
     "text"        VARCHAR(255) NOT NULL PRIMARY KEY, 
     "num_of_post" INTEGER NOT NULL DEFAULT(0) 
  ); 

CREATE TABLE "userr" 
  ( 
     "username"  VARCHAR(50) NOT NULL, 
     "is_active" BOOLEAN NOT NULL DEFAULT(true), 
     PRIMARY KEY(username) 
  ); 

CREATE TABLE "device_user" 
  ( 
     "device_id" INTEGER REFERENCES device(device_id) ON DELETE CASCADE ON 
     UPDATE 
     CASCADE NOT NULL, 
     "username"  VARCHAR(50) REFERENCES userr(username) ON DELETE CASCADE ON 
     UPDATE 
     CASCADE NOT NULL, 
     PRIMARY KEY(device_id, username) 
  ); 

CREATE TABLE "account_information" 
  ( 
     "username_id"     VARCHAR(50) NOT NULL PRIMARY KEY REFERENCES userr( 
     username) ON 
     DELETE CASCADE ON UPDATE 
     CASCADE, 
     "privacy"         BOOLEAN NOT NULL DEFAULT(true), 
     "picture"         VARCHAR(100), 
     "name"            VARCHAR(50), 
     "email"           VARCHAR(254) NOT NULL UNIQUE, 
     "facebook"        VARCHAR(50), 
     "follower_count"  INTEGER NOT NULL DEFAULT(0), 
     "following_count" INTEGER NOT NULL DEFAULT(0), 
     "req_count"       INTEGER NOT NULL DEFAULT(0), 
     "bio"             VARCHAR(250), 
     "password"        VARCHAR(50) NOT NULL, 
     "website"         VARCHAR(50) NULL, 
     "gender"          BOOLEAN NOT NULL DEFAULT(true), 
     "mobile"          VARCHAR(15) NULL 
  ); 

CREATE TABLE "block" 
  ( 
     "username1_id" VARCHAR(50) NOT NULL REFERENCES userr(username) ON DELETE 
     CASCADE 
     ON UPDATE CASCADE, 
     "username2_id" VARCHAR(50) NOT NULL REFERENCES userr(username) ON DELETE 
     CASCADE 
     ON UPDATE CASCADE, 
     PRIMARY KEY(username1_id, username2_id) 
  ); 

CREATE TABLE "request" 
  ( 
     username1 VARCHAR(50) NOT NULL REFERENCES userr(username) ON DELETE CASCADE 
     ON 
     UPDATE CASCADE, 
     username2 VARCHAR(50) NOT NULL REFERENCES userr(username) ON DELETE CASCADE 
     ON 
     UPDATE CASCADE, 
     notif_id  SERIAL NOT NULL, 
     "date"    TIMESTAMP WITH time zone NOT NULL, 
     PRIMARY KEY(username1, username2) 
  ); 

CREATE TABLE "follow" 
  ( 
     username1 VARCHAR(50) NOT NULL REFERENCES userr(username) ON DELETE CASCADE 
     ON 
     UPDATE CASCADE, 
     username2 VARCHAR(50) NOT NULL REFERENCES userr(username) ON DELETE CASCADE 
     ON 
     UPDATE CASCADE, 
     notif_id  SERIAL NOT NULL, 
     "date"    TIMESTAMP WITH time zone NOT NULL, 
     PRIMARY KEY(username1, username2) 
  ); 

CREATE TABLE "chat_message" 
  ( 
     sender_user  VARCHAR(50) REFERENCES userr(username) ON DELETE CASCADE ON 
     UPDATE 
     CASCADE, 
     "chat_id_id" INTEGER NOT NULL REFERENCES chat(chat_id) ON DELETE CASCADE ON 
     UPDATE CASCADE, 
     "message_id" SERIAL NOT NULL, 
     "text"       VARCHAR(255) NOT NULL, 
     "date"       TIMESTAMP WITH time zone NOT NULL, 
     PRIMARY KEY(sender_user, chat_id_id, message_id) 
  ); 

CREATE TABLE "chat_account_message" 
  ( 
     sender_user  VARCHAR(50) REFERENCES userr(username) ON DELETE CASCADE ON 
     UPDATE 
     CASCADE, 
     "chat_id_id" INTEGER NOT NULL REFERENCES chat(chat_id) ON DELETE CASCADE ON 
     UPDATE CASCADE, 
     "message_id" SERIAL NOT NULL, 
     username     VARCHAR(50) REFERENCES userr(username) ON DELETE CASCADE ON 
     UPDATE CASCADE, 
     "date"       TIMESTAMP WITH time zone NOT NULL,
     PRIMARY KEY(sender_user, chat_id_id, message_id) 
  ); 

CREATE TABLE "post" 
  ( 
     "username_id"  VARCHAR(50) NOT NULL REFERENCES userr(username) ON DELETE 
     CASCADE 
     ON UPDATE CASCADE, 
     "post_id"      SERIAL NOT NULL, 
     "date"         TIMESTAMP WITH time zone NOT NULL, 
     "num_of_cms"   INTEGER NOT NULL DEFAULT(0), 
     "location"     VARCHAR(50) NOT NULL, 
     "num_of_likes" INTEGER NOT NULL DEFAULT(0), 
     "caption"      TEXT NOT NULL, 
     PRIMARY KEY(username_id, post_id) 
  ); 

CREATE TABLE "chat_post_message" 
  ( 
     sender_user  VARCHAR(50) REFERENCES userr(username) ON DELETE CASCADE ON 
     UPDATE 
     CASCADE, 
     "chat_id_id" INTEGER NOT NULL REFERENCES chat(chat_id) ON DELETE CASCADE ON 
     UPDATE CASCADE, 
     "message_id" SERIAL NOT NULL, 
     username     VARCHAR(50) REFERENCES userr(username) ON DELETE CASCADE ON 
     UPDATE 
     CASCADE, 
     post_id      INTEGER NOT NULL, 
     "date"       TIMESTAMP WITH time zone NOT NULL,
     PRIMARY KEY(sender_user, chat_id_id, message_id), 
     FOREIGN KEY(username, post_id) REFERENCES post(username_id, post_id) ON 
     DELETE CASCADE ON UPDATE CASCADE 
  ); 

CREATE TABLE "story" 
  ( 
     "username_id"  VARCHAR(50) NOT NULL REFERENCES userr(username) ON DELETE 
     CASCADE 
     ON UPDATE CASCADE, 
     "story_id"     SERIAL NOT NULL, 
     "date"         TIMESTAMP WITH time zone NOT NULL, 
     "num_of_views" INTEGER NOT NULL DEFAULT(0), 
     "location"     VARCHAR(50), 
     "text"         TEXT, 
     handed_text    VARCHAR(100), 
     PRIMARY KEY(username_id, story_id) 
  ); 

CREATE TABLE "chat_story_reply" 
  ( 
     sender_user  VARCHAR(50) REFERENCES userr(username) ON DELETE CASCADE ON 
     UPDATE 
     CASCADE, 
     "chat_id_id" INTEGER NOT NULL REFERENCES chat(chat_id) ON DELETE CASCADE ON 
     UPDATE CASCADE, 
     "message_id" SERIAL NOT NULL, 
     username     VARCHAR(50) REFERENCES userr(username) ON DELETE CASCADE ON 
     UPDATE 
     CASCADE, 
     story_id     INTEGER NOT NULL, 
     "date"       TIMESTAMP WITH time zone NOT NULL,
	 "text"       TEXT not null,
     PRIMARY KEY(sender_user, chat_id_id, message_id), 
     FOREIGN KEY(username, story_id) REFERENCES story(username_id, story_id) ON 
     DELETE CASCADE ON UPDATE CASCADE 
  ); 

CREATE TABLE "comment" 
  ( 
     "sender_user"  VARCHAR(50) NOT NULL REFERENCES userr(username) ON DELETE 
     CASCADE 
     ON UPDATE CASCADE, 
     "cm_id"        SERIAL NOT NULL, 
     "rec_user"     VARCHAR(50) NOT NULL REFERENCES userr(username) ON DELETE 
     CASCADE ON 
     UPDATE CASCADE, 
     "post_id"      INTEGER NOT NULL, 
     "notif_id"     SERIAL NOT NULL, 
     "date"         TIMESTAMP WITH time zone NOT NULL, 
     "num_of_likes" INTEGER NOT NULL DEFAULT(0), 
     "text"         TEXT NOT NULL, 
     PRIMARY KEY(sender_user, cm_id), 
     FOREIGN KEY(rec_user, post_id) REFERENCES post(username_id, post_id) ON 
     DELETE CASCADE ON UPDATE CASCADE 
  ); 

CREATE TABLE "comment_settings" 
  ( 
     "username_id" VARCHAR(50) NOT NULL REFERENCES userr(username) ON DELETE 
     CASCADE 
     ON UPDATE CASCADE PRIMARY 
     KEY, 
     "filter_flag" BOOLEAN NOT NULL DEFAULT(false) 
  ); 

CREATE TABLE "comment_settings_2" 
  ( 
     "username_id" VARCHAR(50) NOT NULL REFERENCES userr(username) ON DELETE 
     CASCADE 
     ON UPDATE CASCADE, 
     "key"         VARCHAR(50) NOT NULL, 
     PRIMARY KEY(username_id, "key") 
  ); 

CREATE TABLE "story_permission" 
  ( 
     "username_id" VARCHAR(50) NOT NULL REFERENCES userr(username) ON DELETE 
     CASCADE 
     ON UPDATE CASCADE, 
     "username_p"  VARCHAR(50) NOT NULL REFERENCES userr(username) ON DELETE 
     CASCADE 
     ON UPDATE CASCADE, 
     PRIMARY KEY(username_id, username_p) 
  ); 

CREATE TABLE "story_settings" 
  ( 
     "username_id" VARCHAR(50) NOT NULL REFERENCES userr(username) ON DELETE 
     CASCADE 
     ON UPDATE CASCADE PRIMARY 
     KEY, 
     "camera_flag" BOOLEAN NOT NULL DEFAULT(true) 
  ); 

CREATE TABLE "general_settings" 
  ( 
     "username_id"    VARCHAR(50) NOT NULL REFERENCES userr(username) ON DELETE 
     CASCADE 
     ON UPDATE CASCADE PRIMARY 
     KEY, 
     "video_save"     BOOLEAN NOT NULL, 
     "upload_quality" BOOLEAN NOT NULL, 
     "image_save"     BOOLEAN NOT NULL, 
     "cell_date"      BOOLEAN NOT NULL, 
     "language"       VARCHAR(20) NOT NULL DEFAULT('en') 
  ); 

CREATE TABLE "report" 
  ( 
     "username1_id" VARCHAR(50) NOT NULL REFERENCES userr(username) ON DELETE 
     CASCADE 
     ON UPDATE CASCADE, 
     "username2_id" VARCHAR(50) NOT NULL REFERENCES userr(username) ON DELETE 
     CASCADE 
     ON UPDATE CASCADE, 
     reason         TEXT NOT NULL, 
     PRIMARY KEY(username1_id, username2_id) 
  ); 

CREATE TABLE "notif_settings" 
  ( 
     "username_id" VARCHAR(50) NOT NULL REFERENCES userr(username) ON DELETE 
     CASCADE 
     ON UPDATE CASCADE, 
     "type"        VARCHAR (10) NOT NULL, 
     "from"        VARCHAR(10) NOT NULL, 
     on_off        BOOLEAN NOT NULL, 
     "display"     VARCHAR(10) NOT NULL, 
     PRIMARY KEY(username_id, "type") 
  ); 

CREATE TABLE hashtag_post 
  ( 
     "text"        VARCHAR(20) NOT NULL REFERENCES hashtag("text"), 
     "username_id" VARCHAR(50) NOT NULL REFERENCES userr(username) ON DELETE 
     CASCADE 
     ON UPDATE CASCADE, 
     post_id       INTEGER NOT NULL, 
     PRIMARY KEY("text", username_id, post_id), 
     FOREIGN KEY(username_id, post_id) REFERENCES post(username_id, post_id) ON 
     DELETE CASCADE ON UPDATE CASCADE 
  ); 

CREATE TABLE like_post 
  ( 
     "liker_user" VARCHAR(50) NOT NULL REFERENCES userr(username) ON DELETE 
     CASCADE 
     ON UPDATE CASCADE, 
     "rec_user"   VARCHAR(50) NOT NULL REFERENCES userr(username) ON DELETE 
     CASCADE ON 
     UPDATE CASCADE, 
     post_id      INTEGER NOT NULL, 
     notif_id     SERIAL NOT NULL, 
     "date"       TIMESTAMP WITH time zone NOT NULL, 
     PRIMARY KEY("liker_user", rec_user, post_id), 
     FOREIGN KEY(rec_user, post_id) REFERENCES post(username_id, post_id) ON 
     DELETE CASCADE ON UPDATE CASCADE 
  ); 

CREATE TABLE like_cm 
  ( 
     "liker_user" VARCHAR(50) NOT NULL REFERENCES userr(username) ON DELETE 
     CASCADE 
     ON UPDATE CASCADE, 
     "rec_user"   VARCHAR(50) NOT NULL REFERENCES userr(username) ON DELETE 
     CASCADE ON 
     UPDATE CASCADE, 
     cm_id        INTEGER NOT NULL, 
     notif_id     SERIAL NOT NULL, 
     "date"       TIMESTAMP WITH time zone NOT NULL, 
     PRIMARY KEY("liker_user", rec_user, cm_id), 
     FOREIGN KEY(rec_user, cm_id) REFERENCES "comment"(sender_user, cm_id) ON 
     DELETE CASCADE ON UPDATE CASCADE 
  ); 

CREATE TABLE tag_post 
  ( 
     "tagged_user"    VARCHAR(50) NOT NULL REFERENCES userr(username) ON DELETE 
     CASCADE 
     ON UPDATE CASCADE, 
     "ownerpost_user" VARCHAR(50) NOT NULL REFERENCES userr(username) ON DELETE 
     CASCADE ON UPDATE CASCADE, 
     post_id          INTEGER NOT NULL, 
     notif_id         SERIAL NOT NULL, 
     "date"           TIMESTAMP WITH time zone NOT NULL, 
     PRIMARY KEY("tagged_user", ownerpost_user, post_id), 
     FOREIGN KEY(ownerpost_user, post_id) REFERENCES post(username_id, post_id) 
     ON DELETE CASCADE ON UPDATE CASCADE 
  ); 

CREATE TABLE tag_cm 
  ( 
     "tagged_user"  VARCHAR(50) NOT NULL REFERENCES userr(username) ON DELETE 
     CASCADE 
     ON UPDATE CASCADE, 
     "ownercm_user" VARCHAR(50) NOT NULL REFERENCES userr(username) ON DELETE 
     CASCADE 
     ON UPDATE CASCADE, 
     cm_id          INTEGER NOT NULL, 
     notif_id       SERIAL NOT NULL, 
     "date"         TIMESTAMP WITH time zone NOT NULL, 
     PRIMARY KEY("tagged_user", ownercm_user, cm_id), 
     FOREIGN KEY(ownercm_user, cm_id) REFERENCES "comment"(sender_user, cm_id) 
     ON DELETE CASCADE ON UPDATE CASCADE 
  ); 

CREATE TABLE seen_story 
  ( 
     "seen_user" VARCHAR(50) NOT NULL REFERENCES userr(username) ON DELETE 
     CASCADE ON 
     UPDATE CASCADE, 
     "rec_user"  VARCHAR(50) NOT NULL REFERENCES userr(username) ON DELETE 
     CASCADE ON 
     UPDATE CASCADE, 
     story_id    INTEGER NOT NULL, 
     PRIMARY KEY("seen_user", rec_user, story_id), 
     FOREIGN KEY(rec_user, story_id) REFERENCES "story"(username_id, story_id) 
     ON DELETE CASCADE ON UPDATE CASCADE 
  ); 

CREATE TABLE "notification" 
  ( 
     "notif_id"      SERIAL NOT NULL, 
     "type"          INTEGER NOT NULL DEFAULT(0), 
     PRIMARY KEY("notif_id", "type") 
  ); 
  
CREATE TABLE tag_story 
  ( 
     "tagged_user"  VARCHAR(50) NOT NULL REFERENCES userr(username) ON DELETE 
     CASCADE 
     ON UPDATE CASCADE, 
     "ownerst_user" VARCHAR(50) NOT NULL REFERENCES userr(username) ON DELETE 
     CASCADE 
     ON UPDATE CASCADE, 
     story_id       INTEGER NOT NULL, 
     notif_id       SERIAL NOT NULL, 
     PRIMARY KEY("tagged_user", ownerst_user, story_id), 
     FOREIGN KEY(ownerst_user, story_id) REFERENCES "story"(username_id, 
     story_id) ON DELETE CASCADE ON UPDATE CASCADE 
  ); 

CREATE TABLE "user_chat" 
  ( 
     "chat_id_id" INTEGER NOT NULL REFERENCES chat(chat_id) ON DELETE CASCADE ON 
     UPDATE CASCADE, 
     username_id  VARCHAR(50) REFERENCES userr(username) ON DELETE CASCADE ON 
     UPDATE 
     CASCADE, 
     "mute"       BOOLEAN NOT NULL, 
     PRIMARY KEY(chat_id_id, username_id) 
  ); 