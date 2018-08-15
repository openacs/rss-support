-- 
-- 
-- 
-- @author Dave Bauer (dave@thedesignexperience.org)
-- @creation-date 2005-01-23
-- @cvs-id $Id$
--

-- old define_function_args ('rss_gen_subscr__new','subscr_id,impl_id,summary_context_id,timeout,lastbuild,object_type,creation_date;now,creation_user,creation_ip,context_id')
-- new
select define_function_args('rss_gen_subscr__new','p_subscr_id,p_impl_id,p_summary_context_id,p_timeout,p_lastbuild;now,p_object_type;rss_gen_subscr,p_creation_date;now,p_creation_user;null,p_creation_ip;null,p_context_id;null');


select define_function_args('rss_gen_subscr__del','subscr_id');


--
-- procedure rss_gen_subscr__del/1
--
CREATE OR REPLACE FUNCTION rss_gen_subscr__del(
   p_subscr_id integer
) RETURNS integer AS $$
DECLARE
BEGIN
	delete from acs_permissions
		   where object_id = p_subscr_id;

	delete from rss_gen_subscrs
		   where subscr_id = p_subscr_id;

	raise NOTICE 'Deleting subscription...';
	PERFORM acs_object__delete(p_subscr_id);

	return 0;

END;
$$ LANGUAGE plpgsql;



-- added
select define_function_args('rss_gen_subscr__delete','subscr_id');

--
-- procedure rss_gen_subscr__delete/1
--
CREATE OR REPLACE FUNCTION rss_gen_subscr__delete(
   p_subscr_id integer
) RETURNS integer AS $$
DECLARE
BEGIN
  return rss_gen_subscr__del (p_subscr_id);
END;
$$ LANGUAGE plpgsql;
