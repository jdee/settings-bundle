# Guidelines for contributors

Minimally, all contributions must pass CI testing. To test yourself locally:

```bash
bundle exec rake
```

Note that many RuboCop issues can be automatically corrected. If your
contribution fails RuboCop, try:

```bash
bundle exec rubocop -a
```
