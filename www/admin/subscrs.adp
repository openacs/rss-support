<master>
<property name="title">Report Generation Subscriptions</property>

<h2>Report Generation Subscriptions</h2>
@context_bar@
<hr>

<table cellpadding="2" cellspacing="1" border="0">
<tr bgcolor=e0e0e0>
 <th>Name</th>
 <th>Timeout</th>
 <th>Last Built</th>
 <th>Last Time To Build</th>
 <th>Created By</th>
 <th>Actions</th>
</tr>
<multiple name="subscrs">
<tr><td>Subscription #@subscrs.subscr_id@</td>
    <td>@subscrs.timeout@s</td>
    <td></td>
    <td></td>
    <td>@subscrs.creator@</td>
    <td>edit,run,delete</td>
</tr>
</multiple>
</table>
