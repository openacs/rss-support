# 

ad_library {
    
    Procedure to add subscriptions
    
    @author Dave Bauer (dave@thedesignexperience.org)
    @creation-date 2005-01-22
    @arch-tag: 601774f4-7b83-4eee-9b36-97c278ba1bd4
    @cvs-id $Id$
}

namespace eval ::rss_support:: {}

ad_proc -public ::rss_support::add_subscription {
    -summary_context_id:required
    -impl_name:required
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

    set impl_id [acs_sc::impl::get_id -name news -owner news -contract RssGenerationSubscriber]

    set var_list [list \
                      [list subscr_id ""] \
                      [list impl_id $impl_id] \
                      [list summary_context_id $summary_context_id] \
                      [list timeout $timeout] \
                      [list lastbuild $lastbuild] \
                      [list object_type $object_type] \
                      [list creation_user $creation_user ] \
                      [list creation_ip $creation_ip] \
                      [list context_id $context_id]
                  ]
    if {[exists_and_not_null creation_date]} {
        lappend var_list [list creation_date $creation_date]
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
 
    @param impl_name implemenation name to delete

    @param owner owner package of implementation
    @return 
    
    @error 
} {
    set impl_id [acs_sc::impl::get_id \
                     -name $impl_name \
                     -contract RssGenerationSubscriber \
                     -owner $owner]
    set subscr_id [db_string get_subscr_id ""]
    set report_dir [rss_gen_report_dir -subscr_id $subscr_id]
    # remove generated RSS reports for this subscription
    file delete -force $report_dir
    ns_log notice "
DB --------------------------------------------------------------------------------
DB DAVE debugging procedure rss_support::del_subscription
DB --------------------------------------------------------------------------------
DB impl_name = '${impl_name}'
DB impl_id = '${impl_id}'
DB subscr_id = '${subscr_id}'

DB --------------------------------------------------------------------------------"
    package_exec_plsql \
        -var_list [list [list subscr_id $subscr_id]] \
        rss_gen_subscr del
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
