alter table rss_gen_subscrs rename column summary_context_id to old_summary_context_id;

alter table rss_gen_subscrs add summary_context_id integer
  constraint rss_gen_subscrs_context_id_nn not null
  constraint rss_gen_subscrs_context_id_fk references acs_objects(object_id);

update rss_gen_subscrs
set summary_context_id = old_summary_context_id::integer;

alter table rss_gen_subscrs drop column old_summary_context_id;
