ad_page_contract {

    Present an admin page for adding or editing subscriptions.

    It would be very tempting to accept impl_name as an argument
    instead of impl_id.  However, the "apply" call in acs_sc_call
    raises the ugly possibility of code-smuggling through the url,
    so we will force the use of the easily validated impl_id instead.

} {
    impl_id:notnull,naturalnum
    summary_context_id:notnull,naturalnum
    return_url:optional
    {meta:optional 1}
}

set context_bar [ad_context_bar]

# Validate the impl_id and get its name
if ![db_0or1row get_impl_name_and_count {
    select acs_sc_impl__get_name(impl_id) as impl_name
    from acs_sc_impls
    where impl_id = :impl_id
}] {
    ad_return_complaint 1 "No implementation found for this id."
}

# Get subscription timeout, if exists.
set timeout [db_string susbcr_timeout {
    select timeout
    from rss_gen_subscrs
    where summary_context_id = :summary_context_id
      and impl_id = :impl_id
} -default 3600]

if !$meta {
    set channel_title "Summary Context $summary_context_id"
    set channel_link ""
} else {
    # Pull out channel data by generating a summary.
    # This is a convenient way to use a contracted operation
    # but is not terribly efficient since we only need the channel title
    # and link, and not the whole summary.
    foreach {name val} [acs_sc_call RssGenerationSubscriber datasource \
	    $summary_context_id $impl_name] {
	if { [lsearch {channel_title channel_link} $name] >= 0 } {
	    set $name $val
	}
    } 
}

set formvars [export_entire_form]