select acs_sc_msg_type__delete('RssGenerationSubscriber.Datasource.InputType');
select acs_sc_msg_type__delete('RssGenerationSubscriber.Datasource.OutputType');
select acs_sc_operation__delete ('RssGenerationSubscriber','Datasource');


select acs_sc_msg_type__delete('RssGenerationSubscriber.LastUpdated.InputType');
select acs_sc_msg_type__delete('RssGenerationSubscriber.LastUpdated.OutputType');
select acs_sc_operation__delete ('RssGenerationSubscriber','LastUpdated');

select acs_sc_contract__delete('RssGenerationSubscriber');

