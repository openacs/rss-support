ad_proc -private rss_gen_service {} {

    ns_log Debug "rss_gen_service: starting"

    set n 0

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
               or now() - r.lastbuild > interval(r.timeout || ' seconds'))
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
	    set report_dir [ns_info pageroot]/[ad_parameter -package_id [rss_package_id] RssGenOutputDirectory rss-support rss]/$impl_name/${summary_context_id}

	    # Create directory if needed.
	    rss_assert_dir $report_dir

	    # Write report.
	    set fh [open $report_dir/rss.xml w]
	    puts $fh $xml
	    close $fh

	    db_dml update_timestamp {
		update rss_gen_subscrs
		set lastbuild = now()
		where subscr_id = :subscr_id
	    }
	    incr n
	}
    }

    ns_log Debug "rss_gen_service: built $n reports"

}

ad_proc rss_assert_dir path {
    <pre>
    # Steps through path creating each new directory as needed.
    # Accepts full path or relative path, but you probably want
    # to specify the full path.
    # Makes no attempt to catch errors.
    </pre>
} {
    set running_path ""
    foreach dir [split $path /] {
	append running_path ${dir}/
	if ![file exists $running_path] {
	    ns_mkdir $running_path
	}
    }
}
