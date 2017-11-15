<?xml version="1.0"?>

<queryset>

  <fullquery name="rss_gen_report.update_timestamp">  
    <querytext>
        update rss_gen_subscrs
        set lastbuild = CURRENT_TIMESTAMP,
            last_ttb = :last_ttb $extra_sql
            where subscr_id = :subscr_id
    </querytext>
  </fullquery>

  <fullquery name="rss_gen_bind.get_unbound_impls">  
    <querytext>
        select impl_id
        from acs_sc_impls i
        where impl_contract_name = 'RssGenerationSubscriber'
          and not exists (select 1
                          from acs_sc_bindings b
                          where b.impl_id = i.impl_id
                            and b.contract_id = :contract_id)
    </querytext>
  </fullquery>  

  <fullquery name="rss_gen_report.subscr_info">      
    <querytext>
        select i.impl_name,
               r.summary_context_id
        from acs_sc_impls i,
             rss_gen_subscrs r
        where r.subscr_id = :subscr_id
          and i.impl_id = r.impl_id
    </querytext>
  </fullquery>

  <fullquery name="rss_gen_report_dir.subscr_context_and_impl">
    <querytext>
                select s.summary_context_id,
                       i.impl_name
                from rss_gen_subscrs s,
                     acs_sc_impls i
                where i.impl_id = s.impl_id
                  and s.subscr_id = :subscr_id
    </querytext>
  </fullquery>

  <fullquery name="rss_gen_report_file.subscr_context_and_impl">
    <querytext>
                select s.summary_context_id,
                       i.impl_name
                from rss_gen_subscrs s,
                     acs_sc_impls i
                where i.impl_id = s.impl_id
                  and s.subscr_id = :subscr_id
    </querytext>
  </fullquery>

</queryset>
