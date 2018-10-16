insert into request (username1, username2, date)
values ('user1', 'user2', '2017-01-01');


insert into request (username1, username2, date)
values ('user2', 'user1', '2017-01-01');


insert into follow (username1, username2, date)
values ('user1', 'user3', '2017-01-01');

insert into follow (username1, username2, date)
values ('user4', 'user3', '2017-01-01');


insert into follow (username1, username2, date)
values ('user2', 'user4', '2017-01-01');


delete from request where username1='user2' and
username2='user1';


insert into block (username1_id, username2_id)
values ('user3', 'user4');


delete from block where username1_id='user3' and
username2_id='user4';


insert into post (username_id, date, num_of_cms, location, num_of_likes, caption)
values ('user3', '2017-01-01', 0, '', 0, 'hamin alan 1hoyi');


insert into post (username_id, date, num_of_cms, location, num_of_likes, caption)
values ('user3', '2017-01-01', 0, '', 0, 'hamin alan 2hoyi');


insert into post (username_id, date, num_of_cms, location, num_of_likes, caption)
values ('user4', '2017-01-01', 0, '', 0, 'hamoon alan 1hoyi');


insert into comment (sender_user, rec_user, post_id, date, num_of_likes, text)
values ('user3', 'user3', 1, '2017-01-03', 0, 'like be khodam');


insert into comment (sender_user, rec_user, post_id, date, num_of_likes, text)
values ('user1', 'user3', 1, '2017-01-03', 0, 'khafe show');


delete from comment where rec_user='user3';


insert into hashtag_post (text, username_id, post_id)
values ('#hello', 'user3', 2);


insert into hashtag_post (text, username_id, post_id)
values ('#hello', 'user3', 1);


insert into hashtag_post (text, username_id, post_id)
values ('#helloo', 'user3', 2);


insert into hashtag_post (text, username_id, post_id)
values ('#helloo', 'user4', 3);


insert into hashtag_post (text, username_id, post_id)
values ('#hello', 'user4', 3);


delete from hashtag_post where text='#hello' and username_id='user3'
and post_id='1';


insert into like_post (liker_user, rec_user, post_id, date)
values ('user2', 'user3', 2, '2017-03-05')


insert into like_post (liker_user, rec_user, post_id, date)
values ('user2', 'user3', 1, '2017-03-05')


insert into like_post (liker_user, rec_user, post_id, date)
values ('user3', 'user3', 2, '2017-03-05')


insert into like_post (liker_user, rec_user, post_id, date)
values ('user3', 'user4', 3, '2017-03-05')


delete from like_post where liker_user='user3' and
rec_user='user4' and post_id='3';


delete from like_post where liker_user='user2' and
rec_user='user3' and post_id='1';


delete from like_post where liker_user='user3' and
rec_user='user3' and post_id='2';


insert into like_cm (liker_user, rec_user, cm_id, date)
values ('user1', 'user2', 5, '2017-06-05');


insert into like_cm (liker_user, rec_user, cm_id, date)
values ('user3', 'user2', 5, '2017-06-05');


delete from like_cm where rec_user='user2';


insert into tag_post (tagged_user, ownerpost_user, post_id, date)
values ('user1', 'user3', 2, '2017-02-03');


insert into tag_post (tagged_user, ownerpost_user, post_id, date)
values ('user2', 'user3', 2, '2017-02-03');


insert into tag_post (tagged_user, ownerpost_user, post_id, date)
values ('user2', 'user4', 3, '2017-02-03');


delete from tag_post where ownerpost_user='user3';


insert into tag_cm (tagged_user, ownercm_user, cm_id, date)
values ('user1', 'user3',3, '2017-02-03');


insert into tag_cm (tagged_user, ownercm_user, cm_id, date)
values ('user2', 'user3', 3, '2017-02-03');


insert into tag_cm (tagged_user, ownercm_user, cm_id, date)
values ('user4', 'user1', 4, '2017-02-03');


delete from tag_cm where ownercm_user='user3';


insert into story (username_id, date, num_of_views, location, handed_text)
values ('user1', '2017-01-01', 0, '', 'traffic');


insert into story (username_id, date, num_of_views, location, handed_text)
values ('user2', '2017-01-01', 0, '', 'traffic');


insert into tag_story (tagged_user, ownerst_user, story_id)
values ('user1', 'user2', 2);


insert into tag_story (tagged_user, ownerst_user, story_id)
values ('user3', 'user2', 2);


delete from tag_story where ownerst_user='user2';


insert into seen_story (seen_user, rec_user, story_id)
values ('user1', 'user2', 3);


insert into seen_story (seen_user, rec_user, story_id)
values ('user4', 'user2', 3);

