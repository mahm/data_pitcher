# DataPitcher

DataPitcher send SQL result data to your Google Spreadsheet.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'data_pitcher'
```

Download and install by running:

```bash
$ bundle install
```

Initialize with:

```bash
$ bundle exec rails generate data_pitcher:install
```

This adds the following files which are used for configuration:

* config/data_pitcher.yml
* config/initializer/data_pitcher.rb

Check the comments in each file for more information.

## How to use

### Authorization

DataPicther use a [service account](https://developers.google.com/identity/protocols/OAuth2ServiceAccount) for accessing Google Spreadsheet. Service account can only access documents explicitly shared (or created) with the service account. It means that your program can only access documents that can be accessed with your service account.

To use a service account, follow these steps:

1. Go to the [credentials page](https://console.developers.google.com/apis/credentials) in the Google Developer Console.
2. Create a new project, or select an exisiting project.
3. Click "Create credentials" -> "Service account".
4. Click "Create" and download the keys a JSON file.
5. Activate the Drive API for your project in the [Google API Console](https://console.developers.google.com/apis/library).
6. Rename your JSON file to "service_account.json", and put to "[RAILS_ROOT]/config/service_account.json"

Optionally, you can change the path, and the file name. When you change these items, please change the following code so as not to forget.

```ruby
# config/initializer/data_pitcher.rb
DataPitcher.configure do |config|
  config.google_service_account_json_path = Rails.root.join('config', 'service_account.json')
end
```

### Setting the YAML file

DataPicther sends SQL results to the specified spreadsheet. To do this, you need to set the key of the destination spreadsheet and the path to the SQL file.

For example:

* Spreadsheet URL: `https://docs.google.com/spreadsheets/d/1QlOBVmsEau8EupE5Kj7AqoHLQTjInoq0GpwPkW7_WdU/edit#gid=0`
* SQL file path: `[RAILS_ROOT]/lib/sqls/conversion_rates.sql`

```yaml
# config/data_pitcher.yml
data_pitcher:
  - spreadsheet_key: 1QlOBVmsEau8EupE5Kj7AqoHLQTjInoq0GpwPkW7_WdU
    sql_path: <%= Rails.root.join('lib', 'sqls', 'conversion_rates.sql') %>
```

To send multiple SQLs to multiple spreadsheets, add them to the array in the YAML file.

### Send data

The easiest way is to set the following Rake task to cron. This task executes all the commands defined in the YAML file.

```bash
$ bundle exec rake data_pitcher:export:run
```

Or, you can manually execute sending data programmatically as follows:

```ruby
DataPitcher::Spreadsheet.new('<SPREADSHEET KEY>').replace_worksheet_with_query('<SQL QUERY STRING>')
```

### (Optionally) Check YAML definition

By executing the following command, you can check whether the definition of YAML file is correct without actually sending data.

```bash
$ bundle exec rake data_pitcher:export:dry_run
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
