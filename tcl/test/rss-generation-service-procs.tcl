ad_library {
    Tests for procs concerning RSS generation
}

aa_register_case \
    -cats {api smoke} \
    -procs {
        rss_gen_report_file
        rss_gen_report
        rss_support::get_subscr_id
        rss_support::subscription_exists
        rss_gen
        rss_gen_091
        rss_gen_100
        rss_gen_200
    } \
    rss__gen_report {
        Test rss_gen_report and other api
    } {
        if {![db_0or1row get_data {
            select summary_context_id,
                   impl_owner_name,
                   impl_name
              from rss_gen_subscrs r,
                   acs_sc_impls i
            where r.impl_id = i.impl_id
              and i.impl_contract_name = 'RssGenerationSubscriber'
            order by summary_context_id asc
            fetch first 1 rows only
        }]} {
            aa_log "No RSS subscription found, exiting..."
            return
        }

        aa_true "rss_support::subscription_exists tells that a subscription exists" \
            [rss_support::subscription_exists \
                 -summary_context_id $summary_context_id \
                 -impl_name $impl_name]

        set report_file [rss_gen_report_file \
                             -summary_context_id $summary_context_id \
                             -impl_name $impl_name]

        aa_log "Deleting '$report_file'"
        file delete -- $report_file
        aa_false "File '$report_file' does not exist" [file exists $report_file]

        aa_log "Generating the report"
        set subscr_id [rss_support::get_subscr_id \
                           -summary_context_id $summary_context_id \
                           -impl_name $impl_name \
                           -owner $impl_owner_name]
        rss_gen_report $subscr_id

        aa_true "File '$report_file' was created as expected" [file exists $report_file]

        set rfd [open $report_file r]
        set xml [read $rfd]
        close $rfd

        aa_false "File '$report_file' contains valid XML" [catch {
            dom parse $xml doc
        }]
    }
