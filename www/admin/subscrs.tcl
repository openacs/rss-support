db_multirow subscrs get_subscrs {
    select s.subscr_id,
           s.timeout,
           person__name(o.creation_user) as creator
    from rss_gen_subscrs s,
         acs_objects o
    where o.object_id = s.subscr_id
}

set context_bar [ad_context_bar Subscriptions]