<?xml version="1.0"?>

<queryset>
  <rdbms>
    <type>oracle</type>
    <version>8.1.6</version>
  </rdbms>

  <fullquery name="get_contract_id">      
    <querytext>
	select acs_sc_contract.get_id('RssGenerationSubscriber') from dual
    </querytext>
  </fullquery>

</queryset>