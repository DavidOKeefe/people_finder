# People Finder

## Implementation:
- Service object to interact with the API.
- Person model to cache api response data
- PersonMetaData to track last time people data cached
- Worker to fetch updated records
- Class method on Person to determine letter frequency
- Service object to perform fuzzy string comparison
- Method on person to find potential duplicate email addresses.
- PersonsController and routes to return JSON.


## Pending:
- Fuzzy string implementation is a Proof of Concept but would not be performant. I would probably do the comparision async and create an association to link potential duplicate person objects
- React front end to display results.


## Getting Started

### Running natively

1.) Make sure your ruby environment is at least 2.4.1
```
ruby --version
```
2.) Make sure your node version is above 8.5.0
```
node --version
```
3.) bundle install
```
gem install bundle
bundle install
```
4.) npm install
```
npm install
npm install webpack-dev-server -g
```
5.) Create and migrate Sqlite Databases
```
bundle exec rake db:create && bundle exec rake db:migrate
```
6.) Copy the .env.sample to .env and fill out the values
```
cp .env.sample .env
```
7.) Start the development server
```
bundle exec foreman start
```
8.) Navigate to localhost:5000

