if [info exists user_id] {
    set maybe_restrict_to_user "and creation_user = :user_id"
} else {
    set maybe_restrict_to_user ""
}

db_multirow subscrs get_subscrs "
    select s.subscr_id,
           s.timeout,
           person__name(o.creation_user) as creator,
           coalesce(to_char(s.lastbuild,'YYYY-MM-DD HH24:MI:SS'),'never built') as lastbuild,
           s.last_ttb,
           s.channel_title,
           s.channel_link
    from rss_gen_subscrs s,
         acs_objects o
    where o.object_id = s.subscr_id $maybe_restrict_to_user
    order by s.last_ttb desc
" {
    if [string equal $channel_title ""] {
	set channel_title "Subscription #$subscr_id"
    }
}
