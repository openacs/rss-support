--
-- ACS-SC Contract: RssGenerationSubscriber
--

select acs_sc_contract__new (
       'RssGenerationSubscriber',		-- contract_name
       'RSS Generation Subscriber'		-- contract_desc
);

select acs_sc_msg_type__new (
       'RssGenerationSubscriber.Datasource.InputType',
       'context_identifier:string'  
);

select acs_sg_msg_type__new (
       'RssGenerationSubscriber.Datasource.OutputType',
       'datasource:string'			-- ????
);

select acs_sc_operation__new (
       'RssGenerationSubscriber',			-- contract_name
       'datasource',					-- operation_name
       'Data Source',					-- operation_desc
       'f',						-- operation_iscachable_p,
       1,						-- operation_nargs
       'RssGenerationSubscriber.Datasource.InputType',  -- operation_inputtype
       'RssGenerationSubscriber.Datasource.OutputType'  -- operation_outputtype
);

select acs_sc_msg_type__new (
       'RssGenerationSubscriber.LastUpdated.InputType',
       'context_identifier:string'  
);

select acs_sg_msg_type__new (
       'RssGenerationSubscriber.LastUpdated.OutputType',
       'lastupdate:timestamp'
);

select acs_sc_operation__new (
       'RssGenerationSubscriber',			-- contract_name
       'lastUpdated',					-- operation_name
       'Last Updated',					-- operation_desc
       'f',						-- operation_iscachable_p,
       1,						-- operation_nargs
       'RssGenerationSubscriber.LastUpdated.InputType',  -- operation_inputtype
       'RssGenerationSubscriber.LastUpdated.OutputType'  -- operation_outputtype
);
