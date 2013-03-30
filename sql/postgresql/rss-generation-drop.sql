--
-- procedure inline_0/0
--
CREATE OR REPLACE FUNCTION inline_0(

) RETURNS integer AS $$
DECLARE
 subscr record;
 v_result integer;
BEGIN
 for subscr in select subscr_id from rss_gen_subscrs loop
   select rss_gen_subscr__delete(subscr.subscr_id) into v_result;
 end loop;
 return 0;
END;
$$ LANGUAGE plpgsql;

select inline_0 ();
drop function inline_0 ();

select acs_object_type__drop_type('rss_gen_subscr','f');

drop table rss_gen_subscrs;
drop function rss_gen_subscr__new (integer,integer,varchar,integer,timestamptz,varchar,timestamptz,integer,varchar,integer);
drop function rss_gen_subscr__name (integer);
drop function rss_gen_subscr__del (integer);
drop function rss_gen_subscr__delete (integer);
