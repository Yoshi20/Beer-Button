# BeerButton

BeerButton web application.

## Start rails server (puma) with esbuild and cssbundling

```
bin/dev
```

## DNS

http://beerbutton.ch

## Host

Hetzner Server (Nürnberg)
IPv4: 91.107.228.193
IPv6: 2a01:4f8:1c1e:685a::/64

## Deployment

```
git c prod
git merge main
git push
mina deploy
```

## Revert deployment

```
git c prod
git reset --hard <working_commit>
git push -f
mina deploy
```

## Console

```
ssh deployer@91.107.228.193
cd /var/www/beerbutton/current/
bin/rails console
```

## Logs

```
mina log
```
or
```
ssh deployer@91.107.228.193
tail -f /var/www/beerbutton/current/log/production.log
```

```
sudo tail -f /var/log/nginx/error.log
```

## Set ENVs

```
ssh deployer@91.107.228.193
vim ~/.bashrc
source ~/.bashrc
```

## Full Restart

```
sudo service nginx stop
sudo service nginx start
```

```
ps -ef | grep nginx
```

## delayed_jobs

```
bin/delayed_job start
bin/delayed_job stop
bin/delayed_job status
```

## (Update Debian packages)

Updating passenger fixed: cookie name containing a unrecognized character like ["session_id instead of session_id in production
```
sudo apt-get update
sudo apt-get upgrade
```

## PWA

1. https://hi.teloslabs.co/post/make-your-rails-app-work-offline-part-1-pwa-setup
2. https://hi.teloslabs.co/post/make-your-rails-app-work-offline-part-2-caching-assets-and-adding-an-offline-fallback
3. https://hi.teloslabs.co/post/make-your-rails-app-work-offline-part-3-crud-actions-with-indexeddb-and-stimulus
