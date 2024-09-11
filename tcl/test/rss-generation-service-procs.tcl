ad_library {
    Tests for procs concerning RSS generation
}

namespace eval rss {}
namespace eval rss::test {}

ad_proc -private rss::test::datasource {
    summary_context_id
} {
    A dummy datasource implementation for testing purposes.
} {
    set pretty_folder_url /test/afolder

    lappend items \
        [list \
             link "anitem" \
             title "A Title" \
             description "A description" \
             timestamp "2023-03-16 14:58:00" \
             enclosure_url "${pretty_folder_url}anitem" \
             enclosure_type file \
             enclosure_length 42] \
        [list \
             link "anitem2" \
             title "A Title 2" \
             description "A description 2" \
             timestamp "2023-03-16 14:58:00" \
             enclosure_url "${pretty_folder_url}anitem2" \
             enclosure_type file \
             enclosure_length 42]

    return [list \
                channel_title "Test title" \
                channel_description "Test description" \
                version 2.0 \
                channel_link $pretty_folder_url \
                image "" \
                channel_lastBuildDate 2023-03-16 \
                items $items \
                channel_language "" \
                channel_copyright "" \
                channel_managingEditor "" \
                channel_webMaster "" \
                channel_rating "" \
                channel_skipDays "" \
                channel_skipHours "" \
               ]
}

ad_proc -private rss::test::lastUpdated {
    summary_context_id
} {
    @return a timestamp for testing purposes
} {
    return "2023-03-16 14:58:00"
}

ad_proc -private rss::test::require_impl_id {} {
    Requires the dummy SC implementation.
} {
    set impl_id [acs_sc::impl::get_id \
                     -owner "rss-support" \
                     -name "test_rss" \
                     -contract "RssGenerationSubscriber"]
    if {$impl_id eq ""} {
        set impl_id [acs_sc::impl::new_from_spec -spec {
            contract_name "RssGenerationSubscriber"
            name "test_rss"
            owner "rss-support"
            aliases {
                datasource rss::test::datasource
                lastUpdated rss::test::lastUpdated
            }
        }]
    }

    return $impl_id
}

rss::test::require_impl_id

aa_register_case \
    -cats {api smoke} \
    -procs {
        rss_gen_report_file
        rss_gen_report
        rss_support::get_subscr_id
        rss_support::subscription_exists
        rss_support::add_subscription
        rss_support::del_subscription
        rss_gen
        rss_gen_091
        rss_gen_100
        rss_gen_200
    } \
    rss__gen_report {
        Test rss_gen_report and other api
    } {
        aa_run_with_teardown -rollback -test_code {
            set impl_id [rss::test::require_impl_id]

            set summary_context_id [db_string any_object_without_subscription {
                select max(object_id) from acs_objects o
                where not exists (select 1 from rss_gen_subscrs
                                  where summary_context_id = o.object_id)
            }]

            set impl_owner_name rss-support
            set impl_name test_rss

            set subscription_id [rss_support::add_subscription \
                                     -summary_context_id $summary_context_id \
                                     -impl_name $impl_name \
                                     -owner $impl_owner_name]

            aa_true "rss_support::subscription_exists tells that a subscription exists" \
                [rss_support::subscription_exists \
                     -summary_context_id $summary_context_id \
                     -impl_name $impl_name]

            aa_equals "API retrieves the subscription" \
                [rss_support::get_subscr_id \
                     -summary_context_id $summary_context_id \
                     -impl_name $impl_name \
                     -owner $impl_owner_name] \
                $subscription_id

            set report_file [rss_gen_report_file \
                                 -summary_context_id $summary_context_id \
                                 -impl_name $impl_name]

            aa_log "Deleting '$report_file'"
            file delete -- $report_file
            aa_false "File '$report_file' does not exist" [file exists $report_file]

            aa_log "Generating the report"
            rss_gen_report $subscription_id

            aa_true "File '$report_file' was created as expected" [file exists $report_file]

            set rfd [open $report_file r]
            set xml [read $rfd]
            close $rfd

            aa_false "File '$report_file' contains valid XML" [catch {
                dom parse $xml doc
            }]

            rss_support::del_subscription \
                -summary_context_id $summary_context_id \
                -impl_name $impl_name \
                -owner $impl_owner_name

            aa_false "Subscription was deleted" [db_0or1row check {
                select 1 from rss_gen_subscrs
                where subscr_id = :subscription_id
            }]
        }
    }
