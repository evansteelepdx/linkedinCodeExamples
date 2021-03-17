global class togglData extends DataSource.Connection {
  override global List<DataSource.Table> sync() {
    List<DataSource.Column> columns = new List<DataSource.Column>();
    columns.add(DataSource.Column.text('ExternalId', 255));
    columns.add(DataSource.Column.url('DisplayUrl'));
    columns.add(DataSource.Column.text('description'));
    columns.add(DataSource.Column.text('guid'));
    columns.add(DataSource.Column.text('uid'));
    columns.add(DataSource.Column.text('start'));
    columns.add(DataSource.Column.text('stop'));
    columns.add(DataSource.Column.boolean('billable'));
    columns.add(DataSource.Column.integer('duration', 18));
    List<DataSource.Table> tables = new List<DataSource.Table>();
    tables.add(DataSource.Table.get('TimeEntries', 'Name', columns));
    return tables;
  }
  override global DataSource.TableResult query(
    DataSource.QueryContext queryContext
  ) {
    List<Map<String, Object>> properties = DataSource.QueryUtils.process(
      queryContext,
      getTimeEntries()
    );
    DataSource.TableResult tableResult = DataSource.TableResult.get(
      queryContext,
      properties
    );
    return tableResult;
  }
  public List<Map<String, Object>> getTimeEntries() {
    Http httpProtocol = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint('callout:Toggl/api/v8/time_entries');
    request.setMethod('GET');
    HttpResponse response = httpProtocol.send(request);
    List<Map<String, Object>> properties = new List<Map<String, Object>>();
    for (
      Object item : (List<Object>) JSON.deserializeUntyped(response.getBody())
    ) {
      Map<String, Object> property = (Map<String, Object>) item;
      property.put('ExternalId', property.get('guid'));
      property.put('DisplayUrl', 'https://track.toggl.com/');
      properties.add(property);
    }
    return properties;
  }
}
