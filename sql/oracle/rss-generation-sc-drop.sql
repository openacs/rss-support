declare
begin

    acs_sc_operation.delete(contract_name => 'RssGenerationSubscriber',operation_name => 'Datasource');

    acs_sc_msg_type.delete(msg_type_name => 'RssGenerationSubscriber.Datasource.InputType');
    acs_sc_msg_type.delete(msg_type_name => 'RssGenerationSubscriber.Datasource.OutputType');

    acs_sc_operation.delete(contract_name => 'RssGenerationSubscriber',operation_name => 'LastUpdated');

    acs_sc_msg_type.delete(msg_type_name => 'RssGenerationSubscriber.LastUpdated.InputType');
    acs_sc_msg_type.delete(msg_type_name => 'RssGenerationSubscriber.LastUpdated.OutputType');

    acs_sc_contract.delete(contract_name => 'RssGenerationSubscriber');

end;
/
show errors

delete from acs_sc_bindings where contract_id = acs_sc_contract.get_id('RssGenerationSubscriber');