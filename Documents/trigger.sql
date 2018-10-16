CREATE OR REPLACE FUNCTION follow_p_a() returns trigger as $follow_p_a$
begin
	 insert into notification values (new.notif_id,0);
	
	update account_information set follower_count = (account_information.follower_count + 1)
	where account_information.username_id = new.username2;
	
	update account_information set following_count = (account_information.following_count + 1)
	where account_information.username_id = new.username1;
	
    return new;
end;
$follow_p_a$ language plpgsql;

create trigger follow_p_a
after insert on follow
for each row
execute procedure follow_p_a();

CREATE OR REPLACE FUNCTION follow_p_b() returns trigger as $follow_p_b$
begin
    if new.username1 in (select username2_id from block 
    where block.username1_id = new.username2) then
        return null;
    end if;

    return new;
end;
$follow_p_b$ language plpgsql;

create trigger follow_t
before insert on follow
for each row
execute procedure follow_p_b();



CREATE OR REPLACE FUNCTION request_p_a() returns trigger as $request_p_a$
begin
    insert into notification values (new.notif_id,1);
	
	update account_information set req_count = (account_information.req_count + 1)
	where account_information.username_id = new.username2;
	
    return new;
end;
$request_p_a$ language plpgsql;

create trigger request_p_a
after insert on request
for each row
execute procedure request_p_a();



CREATE OR REPLACE FUNCTION request_p_b() returns trigger as $request_p_b$
begin
	if new.username1 in (select username2_id from block 
    where block.username1_id = new.username2) then
        return null;
    end if;
    return new;
end;
$request_p_b$ language plpgsql;

create trigger request_t
before insert on request
for each row
execute procedure request_p_b();



CREATE OR REPLACE FUNCTION unfollow_p_a() returns trigger as $unfollow_p_a$
begin
   
	delete from notification where notification.notif_id=old.notif_id and notification."type"=0;
	update account_information set follower_count = (account_information.follower_count - 1)
	where account_information.username_id = old.username2;
	
	update account_information set following_count = (account_information.following_count - 1)
	where account_information.username_id = old.username1;
	
    return new;
end;
$unfollow_p_a$ language plpgsql;

create trigger unfollow_p_a
after delete on follow
for each row
execute procedure unfollow_p_a();



CREATE OR REPLACE FUNCTION unrequest_p_a() returns trigger as $unrequest_p_a$
begin
    
	delete from notification where notification.notif_id=old.notif_id and notification."type"=1;
	update account_information set req_count = (account_information.req_count - 1)
	where account_information.username_id = old.username2;
	
    return new;
end;
$unrequest_p_a$ language plpgsql;

create trigger unrequest_p_a
after delete on request
for each row
execute procedure unrequest_p_a();



CREATE OR REPLACE FUNCTION block_p_a() returns trigger as $block_p_a$
begin

    if new.username2_id in (select username2 from follow
    where follow.username1 = new.username1_id) then
		delete from follow where follow.username1=new.username1_id and follow.username2=new.username2_id;
    end if;
	
    if new.username1_id in (select username2 from follow
    where follow.username1 = new.username2_id) then
        delete from follow where follow.username1=new.username2_id and follow.username2=new.username1_id;
    end if;
	
    return new;
end;
$block_p_a$ language plpgsql;

create trigger block_p_a
after insert on block
for each row
execute procedure block_p_a();



CREATE OR REPLACE FUNCTION comment_p_a() returns trigger as $comment_p_a$
begin
    
	insert into notification values (new.notif_id,2);
	
    update post set num_of_cms=(post.num_of_cms + 1)
    where post.username_id = new.rec_user and
    post.post_id = new.post_id;
	
    return new;
end;
$comment_p_a$ language plpgsql;

create trigger comment_p_a
after insert on "comment"
for each row
execute procedure comment_p_a();



CREATE OR REPLACE FUNCTION uncomment_p_a() returns trigger as $uncomment_p_a$
begin
    
	delete from notification where notification.notif_id=old.notif_id and notification."type"=2;
	
    update post set num_of_cms=(post.num_of_cms - 1)
    where post.username_id = old.rec_user and
    post.post_id = old.post_id;
	
    return new;
end;
$uncomment_p_a$ language plpgsql;

create trigger uncomment_p_a
after delete on "comment"
for each row
execute procedure uncomment_p_a();



CREATE OR REPLACE FUNCTION hashtag_post_p_a() returns trigger as $hashtag_post_p_a$
begin
    if new.text not in (select text from hashtag) then
        insert into hashtag (text, num_of_post)
        values (new.text, 0);
    end if;
	
    update hashtag set num_of_post=(hashtag.num_of_post + 1)
    where hashtag.text = new.text;
	
    return new;
end;
$hashtag_post_p_a$ language plpgsql;

create trigger hashtag_post_p_a
after insert on hashtag_post
for each row
execute procedure hashtag_post_p_a();



CREATE OR REPLACE FUNCTION hashtag_post_p_b() returns trigger as $hashtag_post_p_b$
begin
    if new.text not in (select text from hashtag) then
        insert into hashtag (text, num_of_post)
        values (new.text, 0);
    end if;
	
    return new;
end;
$hashtag_post_p_b$ language plpgsql;

create trigger hashtag_post_p_b
before insert on hashtag_post
for each row
execute procedure hashtag_post_p_b();



CREATE OR REPLACE FUNCTION unhashtag_post_p_a() returns trigger as $unhashtag_post_p_a$
begin
    update hashtag set num_of_post=(hashtag.num_of_post - 1)
    where hashtag.text = old.text;
	
    return new;
end;
$unhashtag_post_p_a$ language plpgsql;

create trigger unhashtag_post_p_a
after delete on hashtag_post
for each row
execute procedure unhashtag_post_p_a();



CREATE OR REPLACE FUNCTION like_post_p_a() returns trigger as $like_post_p_a$
begin
    
	insert into notification values (new.notif_id,3);
	
	update post set num_of_likes=(post.num_of_likes + 1)
    where post.username_id = new.rec_user and
    post.post_id = new.post_id;
	
    return new;
end;
$like_post_p_a$ language plpgsql;

create trigger like_post_p_a
after insert on like_post
for each row
execute procedure like_post_p_a();



CREATE OR REPLACE FUNCTION unlike_post_p_a() returns trigger as $unlike_post_p_a$
begin
    
	delete from notification where notification.notif_id=old.notif_id and notification."type"=3;
	
	update post set num_of_likes=(post.num_of_likes - 1)
    where post.username_id = old.rec_user and
    post.post_id = old.post_id;
	
    return new;
end;
$unlike_post_p_a$ language plpgsql;

create trigger unlike_post_p_a
after delete on like_post
for each row
execute procedure unlike_post_p_a();



CREATE OR REPLACE FUNCTION like_cm_p_a() returns trigger as $like_cm_p_a$
begin
    insert into notification values (new.notif_id,4);
	
	update "comment" set num_of_likes=("comment".num_of_likes + 1)
    where "comment".sender_user = new.rec_user
    and "comment".cm_id = new.cm_id;
	
    return new;
end;
$like_cm_p_a$ language plpgsql;

create trigger like_cm_p_a
after insert on like_cm
for each row
execute procedure like_cm_p_a();



CREATE OR REPLACE FUNCTION unlike_cm_p_a() returns trigger as $unlike_cm_p_a$
begin
    delete from notification where notification.notif_id=old.notif_id and notification."type"=4;
	
	update "comment" set num_of_likes=("comment".num_of_likes - 1)
    where "comment".sender_user = old.rec_user
    and "comment".cm_id = old.cm_id;
	
    return new;
end;
$unlike_cm_p_a$ language plpgsql;

create trigger unlike_cm_p_a
after delete on like_cm
for each row
execute procedure unlike_cm_p_a();



CREATE OR REPLACE FUNCTION tag_post_p_a() returns trigger as $tag_post_p_a$
begin
    insert into notification values (new.notif_id,5);
	
    return new;
end;
$tag_post_p_a$ language plpgsql;

create trigger tag_post_p_a
after insert on tag_post
for each row
execute procedure tag_post_p_a();



CREATE OR REPLACE FUNCTION untag_post_p_a() returns trigger as $untag_post_p_a$
begin
    delete from notification where notification.notif_id=old.notif_id and notification."type"=5;
	
    return new;
end;
$untag_post_p_a$ language plpgsql;

create trigger untag_post_p_a
after delete on tag_post
for each row
execute procedure untag_post_p_a();



CREATE OR REPLACE FUNCTION tag_cm_p_a() returns trigger as $tag_cm_p_a$
begin
    insert into notification values (new.notif_id,6);
	
    return new;
end;
$tag_cm_p_a$ language plpgsql;

create trigger tag_cm_p_a
after insert on tag_cm
for each row
execute procedure tag_cm_p_a();



CREATE OR REPLACE FUNCTION untag_cm_p_a() returns trigger as $untag_cm_p_a$
begin
    delete from notification where notification.notif_id=old.notif_id and notification."type"=6;
    return new;
end;
$untag_cm_p_a$ language plpgsql;

create trigger untag_cm_p_a
after delete on tag_cm
for each row
execute procedure untag_cm_p_a();



CREATE OR REPLACE FUNCTION tag_story_p_a() returns trigger as $tag_story_p_a$
begin
    insert into notification values (new.notif_id,7);
	
    return new;
end;
$tag_story_p_a$ language plpgsql;

create trigger tag_story_p_a
after insert on tag_story
for each row
execute procedure tag_story_p_a();



CREATE OR REPLACE FUNCTION untag_story_p_a() returns trigger as $untag_story_p_a$
begin
      delete from notification where notification.notif_id=old.notif_id and notification."type"=7;
	
    return new;
end;
$untag_story_p_a$ language plpgsql;

create trigger untag_story_p_a
after delete on tag_story
for each row
execute procedure untag_story_p_a();



CREATE OR REPLACE FUNCTION seen_story_p_a() returns trigger as $seen_story_p_a$
begin
	update story set num_of_views = (story.num_of_views + 1)
	where story.username_id = new.rec_user
    and story.story_id=new.story_id;
	
    return new;
end;
$seen_story_p_a$ language plpgsql;

create trigger seen_story_p_a
after insert on seen_story
for each row
execute procedure seen_story_p_a();











