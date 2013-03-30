--
-- Adding defaulting for v_summary_context_id, to support
-- the file-storage implementation of RssGenerationSubscriber.
--

drop function rss_gen_subscr__new (
    integer,                   -- subscr_id
    integer,                   -- impl_id
    varchar,                   -- summary_context_id
    integer,                   -- timeout
    timestamptz,               -- lastbuild
    varchar,                   -- object_type
    timestamptz,               -- creation_date
    integer,                   -- creation_user
    varchar,                   -- creation_ip
    integer                    -- context_id
);



-- added

-- old define_function_args('rss_gen_subscr__new','subscr_id,impl_id,summary_context_id,timeout,lastbuild,object_type;rss_gen_subscr,creation_date;now(),creation_user;null,creation_ip;null,context_id;null')
-- new
select define_function_args('rss_gen_subscr__new','p_subscr_id,p_impl_id,p_summary_context_id,p_timeout,p_lastbuild;now,p_object_type;rss_gen_subscr,p_creation_date;now,p_creation_user;null,p_creation_ip;null,p_context_id;null');


--
-- procedure rss_gen_subscr__new/10
--
CREATE OR REPLACE FUNCTION rss_gen_subscr__new(
   p_subscr_id integer,
   p_impl_id integer,
   p_summary_context_id varchar,
   p_timeout integer,
   p_lastbuild timestamptz,
   p_object_type varchar,       -- default 'rss_gen_subscr'
   p_creation_date timestamptz, -- default now()
   p_creation_user integer,     -- default null
   p_creation_ip varchar,       -- default null
   p_context_id integer         -- default null

) RETURNS integer AS $$
DECLARE
  v_subscr_id			rss_gen_subscrs.subscr_id%TYPE;
  v_summary_context_id  rss_gen_subscrs.summary_context_id%TYPE;
BEGIN
	v_subscr_id := acs_object__new (
		p_subscr_id,
		p_object_type,
		p_creation_date,
		p_creation_user,
		p_creation_ip,
		p_context_id
	);

        if p_summary_context_id is null then
          v_summary_context_id := v_subscr_id;
        else
          v_summary_context_id := p_summary_context_id;
        end if;

	insert into rss_gen_subscrs
	  (subscr_id, impl_id, summary_context_id, timeout, lastbuild)
	values
	  (v_subscr_id, p_impl_id, v_summary_context_id, p_timeout, p_lastbuild);

	return v_subscr_id;

END;
$$ LANGUAGE plpgsql;
