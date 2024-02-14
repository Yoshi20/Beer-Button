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
mina deploy
```

## Console

```
ssh deployer@91.107.228.193
cd /var/www/beerbutton/current/
bin/rails console
```

## Set ENVs

```
ssh deployer@91.107.228.193
vim ~/.bashrc
```

## Full Restart

```
sudo service nginx stop
sudo service nginx start
```

## delayed_jobs

```
bin/delayed_job start
bin/delayed_job stop
bin/delayed_job status
```
