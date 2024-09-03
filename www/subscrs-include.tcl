ad_include_contract {
    Displays subscriptions for every user or specified user.
} {
    {user_id:naturalnum ""}
}

db_multirow -extend { lastbuild_pretty } subscrs get_subscrs {
        select s.subscr_id,
           s.timeout,
           o.creation_user as creator,
           to_char(s.lastbuild,'YYYY-MM-DD HH24:MI:SS') as lastbuild_ansi,
           s.last_ttb,
           s.channel_title,
           s.channel_link
    from rss_gen_subscrs s,
         acs_objects o
    where o.object_id = s.subscr_id
      and (:user_id is null or creation_user = :user_id)
    order by s.last_ttb desc
} {
    set creator [acs_user::get -user_id $creator -element name]
    if {$lastbuild_ansi ne ""} {
        set lastbuild_ansi [lc_time_system_to_conn $lastbuild_ansi]
        set lastbuild_pretty [lc_time_fmt $lastbuild_ansi "%x %X"]
    } else {
        set lastbuild_pretty "never built"
    }

    if {$channel_title eq ""} {
	set channel_title "Subscription #$subscr_id"
    }
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
