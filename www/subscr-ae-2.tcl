ad_page_contract {
    Insert or update the subscription.
} {
    subscr_id:notnull,naturalnum
    impl_id:optional,naturalnum
    summary_context_id:optional,naturalnum
    return_url:localurl,optional
    timeout:notnull,naturalnum
    timeout_units:notnull
    {meta:optional 1}
}

switch $timeout_units {
    m { set timeout [expr {$timeout * 60}] }
    h { set timeout [expr {$timeout * 3600}] }
    d { set timeout [expr {$timeout * 86400}] }
}

if {[db_0or1row subscr_exists_p {
    select 1
    from acs_objects
    where object_id = :subscr_id
}]} {
    # Subscription exists
    permission::require_permission -object_id $subscr_id -privilege admin
    db_dml update_subscr {}
} else {
    # Create a new subscription.
    permission::require_permission -object_id $summary_context_id -privilege admin

    set creation_user [ad_conn user_id]
    set creation_ip [ns_conn peeraddr]
    set subscr_id [db_exec_plsql create_subscr {}]
}


set review_url [export_vars -base subscr-ae {subscr_id impl_id summary_context_id return_url meta}]

set context [list [list $review_url "Edit subscription"] "Done"]


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
