ad_library {

    Procedure to add subscriptions

    @author Dave Bauer (dave@thedesignexperience.org)
    @creation-date 2005-01-22
    @cvs-id $Id$
}

namespace eval ::rss_support:: {}

ad_proc -public ::rss_support::add_subscription {
    -summary_context_id:required
    -impl_name:required
    -owner:required
    {-creation_user ""}
    {-creation_ip ""}
    {-object_type "rss_gen_subscr"}
    {-timeout 3600}
    {-lastbuild ""}
    -context_id
    -creation_date
} {


    @author Dave Bauer (dave@thedesignexperience.org)
    @creation-date 2005-01-22

    @param summary_context_id object_id to subscribe to
    @param impl_name RssGenSubscr service contract
    implementation name
    @param creation_user
    @param creation_ip
    @param object_type object type to create
    @param timeout time between rebuilds of the rss feed
    @param context_id object this subscription inherits from
    @param creation_date date and time subscription was created

    @return subscr_id

    @error
} {
    if {![info exists context_id]} {
        set context_id $summary_context_id
    }

    set impl_id [db_string get_impl_id ""]
    set sysdate [dt_sysdate]

    set var_list [list \
                      [list p_subscr_id ""] \
                      [list p_impl_id $impl_id] \
                      [list p_summary_context_id $summary_context_id] \
                      [list p_timeout $timeout] \
                      [list p_lastbuild $sysdate] \
                      [list p_object_type $object_type] \
                      [list p_creation_user $creation_user ] \
                      [list p_creation_ip $creation_ip] \
                      [list p_context_id $context_id]
                  ]
    if {([info exists creation_date] && $creation_date ne "")} {
        lappend var_list [list creation_date $creation_date]
    }
    if { $lastbuild ne "" } {
        lappend var_list [list p_lastbuild $lastbuild]
    }

    return [package_exec_plsql \
                -var_list $var_list \
                rss_gen_subscr new]
}

ad_proc -public rss_support::del_subscription {
    -summary_context_id
    -impl_name
    -owner
} {

    @author Dave Bauer (dave@thedesignexperience.org)
    @creation-date 2005-01-23

    @param summary_context_id summary context id to delete

    @param impl_name implementation name to delete

    @param owner owner package of implementation
    @return

    @error
} {
    if {[rss_support::subscription_exists \
            -summary_context_id $summary_context_id \
            -impl_name $impl_name]
    } {
        set subscr_id [rss_support::get_subscr_id \
                           -summary_context_id $summary_context_id \
                           -impl_name $impl_name \
                           -owner $owner]
        set report_dir [rss_gen_report_dir -subscr_id $subscr_id]
        # remove generated RSS reports for this subscription
        file delete -force -- $report_dir
        package_exec_plsql \
            -var_list [list [list subscr_id $subscr_id]] \
            rss_gen_subscr del
    } else {
        ns_log Warning "rss_support::del_subscription \
            (summary_context_id $summary_context_id -impl_name $impl_name) \
            does not exist!"
    }
}

ad_proc -public rss_support::subscription_exists {
    -summary_context_id
    -impl_name
} {

    Check if a subscription exists

    @author Dave Bauer (dave@thedesignexperience.org)
    @creation-date 2005-01-23

    @param summary_context_id summary context id to check

    @return

    @error
} {
    return [db_string subscription_exists "" -default 0]
}

ad_proc -public rss_support::get_subscr_id {
    -summary_context_id
    -impl_name
    -owner
} {

    Return subscription id

    @author Dave Bauer (dave@thedesignexperience.org)
    @creation-date 2005-02-04

    @param summary_context_id Object_id subscribed to

    @param impl_name Implementation (object_type) name

    @param owner Owner of implementation (package_key)
    @return

    @error
} {
    return [db_string get_subscr_id {
        select subscr_id
         from rss_gen_subscrs
        where impl_id = (select impl_id
                          from acs_sc_impls
                         where impl_name = :impl_name
                           and impl_contract_name = 'RssGenerationSubscriber'
                           and impl_owner_name = :owner)
          and summary_context_id = :summary_context_id
    }]
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
