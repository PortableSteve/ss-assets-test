# Silverstripe assets test repo

This repo can be used to reproduce an issue that results in duplicate entries in the
`RewriteCond` directive for file extensions in `public/assets/.htaccess`

# Reproduction

* Check out this repository.
* `docker compose up`
* `docker compose exec app composer install`
* `docker compose exec app ./vendor/bin/sake dev/build`

Note that the repo includes two config files that both add `svg` to the `allowed_extensions` list:
* `my-project/app/_config/config1.yml`
* `my-project/app/_config/config2.yml`

Look at the contents of `my-project/public/assets/.htaccess` and note that the `RewriteCond`
directive on line 28 includes `svg` twice:
```
RewriteCond %{REQUEST_URI} !^[^.]*[^\/]*\.(?i:css|js|ace|arc|arj|asf|au|avi|bmp|brf|bz2|cab|cda|csv|dmg|doc|docx|dotx|flv|gif|gz|hqx|ico|jpeg|jpg|kml|m4a|m4v|mid|midi|mkv|mov|mp3|mp4|mpa|mpeg|mpg|ogg|ogv|pages|pcx|pdf|png|pps|ppt|pptx|potx|ra|ram|rm|rtf|sit|sitx|tar|tgz|tif|tiff|txt|wav|webm|webp|wma|wmv|xls|xlsx|xltx|zip|zipx|svg|svg|graphql)$
```

Any additional config files that add `svg` to the `allowed_extensions` list will add another
entry to this directive. This includes config files that are part of third-party packages.
This applies to any file extension added through multiple config files.

# Resolution
Add a check for the extension in `\SilverStripe\Assets\File::getAllowedExtensions()` to make sure
that duplicates are not returned.
