Bus
===

Colorgy 專車，便利你的交通生活

## Development Setup

Just run:

```bash
$ ./bin/setup
```

You may want to change the app's default environment variables, which lays in `.env`.


## Deploy

This application is designed under The [Twelve-Factor App](http://12factor.net/) pattern, making its deployment and operations on cloud platforms easy.

It's also aimed to be Heroku deployable: [![Deploy](https://neson.github.io/GitHub-Badges/deploy_to_heroku_xs.svg)](https://heroku.com/deploy)


## Management

Visit `http(s)://url_of_your_app/admin` to access the control panel. The default account and password is `admin` / `password`. Please change it immediately after your first login by clicking your administration account name ("admin") located at the top-right corner.

### Routes

`seat_info` 填入以下的 JSON 格式已建立座位表。

```json
{
  "seating": [
    [ "1",  "2", null, null],
    [ "5",  "6", null,  "3"],
    [ "8",  "9", null,  "7"],
    [ "11", "12", null, "10"],
    ["15", "16", null, "13"],
    ["18", "19", null, "17"],
    ["20", "21", null, "25"],
    ["22", "23", null, "28"],
    ["26", "27", null, "29"],
    ["30", "31", null, "32"],
    ["33", "35", "36", "37"]
  ]
}
```

## Testing

Run the following command to execute all test suites:

```bash
$ bundle exec rake
```

For CI or continuous deployment servers, use the `bin/test` command to automatically retry the entire test suite on failure for up to 3 times.


## Chat

[![Join the chat at https://gitter.im/colorgy/Core](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/colorgy/Bus?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)


## License

Copyright (c) 2015 MISK. Licensed under [GNU AGPL-3.0](https://www.gnu.org/licenses/agpl-3.0.html) with the following conditions:

This software can only be used to power a service where end users are not (able to be) charged for. An additional license should be made if this condition is not obeyed.


## Contributing

1. Fork it.
2. Create your feature branch (`git checkout -b my-new-feature`).
3. Commit your changes (`git commit -m 'add some feature'`).
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request.
