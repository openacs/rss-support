ad_page_contract {
    Insert or update the subscription.
} {
    impl_id:notnull,naturalnum
    summary_context_id:notnull,naturalnum
    return_url:optional
    timeout:notnull,naturalnum
    timeout_units:notnull
    {meta:optional 1}
}

switch $timeout_units {
    m { set timeout [expr $timeout * 60] }
    h { set timeout [expr $timeout * 3600] }
    d { set timeout [expr $timeout * 86400] }
}

if [db_0or1row get_susbcr_id {
    select subscr_id
    from rss_gen_subscrs
    where summary_context_id = :summary_context_id
      and impl_id = :impl_id
}] {
    # Subscription exists
    db_dml update_subscr {
	update rss_gen_subscrs
	set timeout = :timeout
	where subscr_id = :subscr_id
    }
} else {
    # Create a new subscription.
    set creation_user [ad_conn user_id]
    set creation_ip [ns_conn peeraddr]
    db_exec_plsql create_subscr {
	select rss_gen_subscr__new (
	    null,				-- subscr_id
            :impl_id,				-- impl_id
            :summary_context_id,		-- summary_context_id
            :timeout,			        -- timeout
            null,				-- lastbuild
            'rss_gen_subscr',		        -- object_type
            now(),				-- creation_date
            :creation_user,			-- creation_user
            :creation_ip,			-- creation_ip
            :summary_context_id			-- context_id
	)
    }
}


set context_bar [ad_context_bar]

set review_url subscr-ae?[export_url_vars impl_id summary_context_id return_url meta]