ad_proc -private rss_gen_service {} {

    db_foreach timed_out_subscriptions {
	select r.subscr_id,
               i.impl_name,
               r.summary_context_id,
               r.timeout,
               case when r.lastbuild = null
                    then 0
                    else date_part('epoch',r.lastbuild)
                    end as lastbuild
        from rss_gen_subscrs r,
             acs_sc_impls i
        where i.impl_id = r.impl_id
          and (r.lastbuild is null
               or age(r.lastbuild) > interval(r.timeout || ' seconds'))
    } {
	set lastupdate [acs_sc_call RssGenerationSubscriber lastUpdated \
		$summary_context_id $impl_name]
	if { $lastupdate > $lastbuild } {
	    # Old report is stale.  Build a new one.
	    set datasource [acs_sc_call RssGenerationSubscriber datasource \
		    $summary_context_id $impl_name]
	    set args ""
	    foreach {name val} $datasource {
		append args "-$name \"$val\" "
	    }
	    set xml [apply rss_gen $args]
	    # TODO: write contents to file system
	    # TODO: update lastbuild for this subscr_id
	    ns_log Notice "rssgen: created report"
	    ns_log Notice "rssgen: $xml"
	}
    }
}

# TODO: run as a scheduled proc