<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN"
"http://www.thecodemill.biz/repository/xql.dtd">
<!--  -->
<!-- @author Dave Bauer (dave@thedesignexperience.org) -->
<!-- @creation-date 2005-01-23 -->
<!-- @cvs-id $Id$ -->

<queryset>
  <fullquery
    name="rss_support::subscription_exists.subscription_exists">
    <querytext>
      select 1 from rss_gen_subscrs r,acs_sc_impls a
      where r.summary_context_id=:summary_context_id
      and a.impl_name=:impl_name
      and a.impl_id=r.impl_id
    </querytext>
  </fullquery>

  <fullquery name="rss_support::add_subscription.get_impl_id">
    <querytext>
      select impl_id
      from acs_sc_impls
      where impl_name=:impl_name
      and impl_contract_name='RssGenerationSubscriber'
      and impl_owner_name=:owner
    </querytext>
  </fullquery>

</queryset>
