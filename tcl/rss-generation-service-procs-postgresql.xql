<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

  <fullquery name="rss_gen_service.timed_out_subscriptions">      
    <querytext>
        select r.subscr_id,
               r.timeout,
               r.summary_context_id,
               i.impl_name,
               case when r.lastbuild = null
                    then 0
                    else date_part('epoch',r.lastbuild)
                    end as lastbuild
        from rss_gen_subscrs r,
             acs_sc_impls i
        where i.impl_id = r.impl_id
          and (r.lastbuild is null
               or now() - r.lastbuild > cast(r.timeout || ' seconds' as interval))	
    </querytext>
  </fullquery>

  <fullquery name="rss_gen_bind.get_contract_id">  
    <querytext>
       	select acs_sc_contract__get_id('RssGenerationSubscriber')
    </querytext>
  </fullquery>

  <fullquery name="rss_gen_bind.bind_impl">
    <querytext>
         select acs_sc_binding__new($contract_id,$impl_id)
    </querytext>
  </fullquery>

</queryset>
