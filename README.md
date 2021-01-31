# docker-mautic-noroot
A derivative of docker Mautic intended to run as an arbitrary user.

Targets Mautic version 3.2
Uses the Docker php:7.3-apache base image

## Mautic is ~2/12 factors by default.
There are numerous design decisions that make running Mautic in a Kuberetes environment something of an configuration nightmare. Here's some coverage by factor

### Codebase

Mautic has their code on github - but not all of it - there's a separate build-step that pulls all the dependencies into a release, which can be downloaded separately from the default codbase - you'll note that even Mautic's readme indicates the github relase is not suitable for production.

### Dependencies

Dependencies are isolated and declared, but cannot be satisfied automatically in a stateless fashion - the container has to be fully built and composer is used, on run-time to mutate the container code (in several different directories). This run-time dependency injection is in /var/cache

### Config
Config information is diffused throughout the app, but much of the core info is in a single config file - local.php, which hard-codes the inputs from the installation step (/app/config/local.php) This file is generated during install and its absence is used to trigger the installation GUI. I have included it in this docker image. On first load, the database will not be initialized, but the file will exist, so the system will try to connect as normal - for now, you'll have to shell into the container, remove the file, run the installer, and then trigger a rollout of the image to reinstate the file.

### Backing Services

This is actually done reasonably well - you can put arbitrary configuration values for internal or external services and the application copes fine. I just wish the config values came from the environment - see Config, above.

### Build, Release, Run

This is a real muddle - the application stores a rather convoluted cache of dependency injection components in, appropriately enough, /var/cache. I have not yet tested whether including those in the initial builld works. Thus there's a huge quantity of mutable state in after the container is deployed - which while functional, does increase the cold boot time.

### Processes

App is not properly stateless - there are numerous self-mutating php files littered throughout the app (see above) that store application state outside of the database. The /media/ folder seems to be the destination for uploads.

### Port Binding

App is run entirely within the Apache webserver. A PHP-FPM version of the application is possible, I just haven't had time to investigate what changes would need to happen to the codebase to make it work.

### Concurrency

This is actually mostly built into the PHP runtime architecture - each request spins up an individual PHP process to handle the request, so this is a low-optimization-ceiling.

### Disposability

The application is quite slow to start-up but handles sudden-death reasonably well - this comes built-in to how PHP handles requests (1:1 process:request).

### Dev/Prod Parity

Mautic uses the symfony execution context flags to alter execution behaviour. There is little appetite to actually alter Mautic's internals at this time, so this is most a non-issue.

### Logs

Logs are dumped to the /var/logs directory rather than pushed to a streamm. So, this just isn't done.

### Admin Processes

This is mostly violated by me - as I want to minimize infiltration of the default Mautic release codebase, so I've wrapped it with my changes and annotations here.

## Wishlist

There are numerous enhancements that should be made:

1. Switch execution context to PHP-FPM
2. Create a fork of Mautic with downstream modifications for K8s/OpenShift
3. Rebuild bootstrapping to properly detect need for install step.
4. Create a migration to apply install step automatically as-needed.
5. Replace crontab with cronjob definition YAMLs
6. Stand-up an on-cluster mailing service that brokers connections external providers, queues sends etc. rather than ad-hoc connections. Maybe [Postal] (https://postal.atech.media/)?