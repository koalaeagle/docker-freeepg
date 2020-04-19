# docker-freeepg
## Introduction

This container sets up an environment to run these perl scripts: https://github.com/markcs/xml_tv (credit to the author) - the output can be saved to a mapped volume or shared over a light web server. The output can be shared to a media server such as Plex or Emby.

Note: This is not intended to be shared over the internet, just over your own LAN. Please consider the risks of sharing this externally.

## Examples
### Web server enabled on port 10081, output mapped to /var/lib/freeepg/data. Both scripts enabled (default), with regions set for Sydney, PUID/GUID set to 1000 (default)

```
sudo docker run -d --name freeepg \
        -e TZ=Australia/Melbourne \
        -e DARKHTTPD_ENABLED=1 \
        -e YOURTV_REGION=73 \
        -e FREEEPG_REGION=region_nsw_sydney \
        -p 10081:80 \
        -v /var/lib/freeepg/cache:/cache \
        -v /var/lib/freeepg/data:/srv/http \
        koalaeagle/freeepg
```
        
### Web server disabled, output mapped to /var/lib/freeepg/data, only freeepg script enabled, region set to Melbourne (default), PUID/GUID set to 1005

```
sudo docker run -d --name freeepg \
        -e TZ=Australia/Melbourne \
        -e DARKHTTPD_ENABLED=0 \
        -e YOURTV_ENABLED=0 \
        -e PUID=1005 \
        -e PGID=1005 \
        -v /var/lib/freeepg/cache:/cache \
        -v /var/lib/freeepg/data:/srv/http \
        koalaeagle/freeepg
```

## Volumes
### /cache
This is the cache directory used by the scripts. Mapping this is not required, although, if not mapped the scripts will have to start from scratch if the container deleted and re-created which could take 1-2 hours.
### /srv/http
This is where the scripts will output the xmltv files. This volume can then be mapped to a plex/emby docker container, or used by a native container. Alternatively, these can be used via http by using soemthing like http://(docker host IP):(port)/yourtv_out.xmltv
#### yourtv
/srv/http/yourtv_out.xmltv \
mapped: if "-v /var/lib/freeepg/data:/srv/http", then /var/lib/freeepg/data/yourtv_out.xmltv \
web: http://(docker host IP):(port)/yourtv_out.xmltv \
web example: http://192.168.1.10:8888/yourtv_out.xmltv
#### freeepg
/srv/http/epg_out.xmltv \
mapped: if "-v /var/lib/freeepg/data:/srv/http", then /var/lib/freeepg/data/epg_out.xmltv \
web: http://(docker host IP):(port)/epg_out.xmltv \
web example: http://192.168.1.10:8888/epg_out.xmltv


## Variables


|Variable         |Default|Description                 |
|-----------------|----|-------------------------------|
|TZ               |UTC | Timezone |
|PUID             |1000|UID to run process as  |
|GUID             |1000|GID to run process as  |
|DARKHTTPD_ENABLED|1|Enable(1)/Disable(2) Web Server   |
|YOURTV_ENABLED   |1|Enable(1)/Disable(2) yourtv script              |
|YOURTV_DELAY     |10800| Delay(s) between yourtv script runs|
|YOURTV_REGION    |94| yourtv script region, see below for more details|
|FREEEPG_ENABLED   |1|Enable(1)/Disable(2) freeepg script              |
|FREEEPG_DELAY     |10800| Delay(s) between freeepg script runs|
|FREEEPG_REGION    |region_vic_melbourne| freeepg script region, see below for more details|


## Outputs

yourtv: /srv/http/yourtv_out.xmltv
mapped: if "-v /var/lib/freeepg/data:/srv/http", then /var/lib/freeepg/data/yourtv_out.xmltv

## Regions
For an updated list with the container running:
sudo docker exec -it freeepg /xml_tv/yourtv.pl --help
sudo docker exec -it freeepg /xml_tv/free_epg.pl --help


### YourTV
101     =       Perth \
81      =       Adelaide \
88      =       Hobart \
94      =       Melbourne \
75      =       Brisbane \
73      =       Sydney \
126     =       Canberra \
74      =       Darwin \
83      =       Riverland \
342     =       Mandurah \
93      =       Geelong \
78      =       Gold Coast \
184     =       Newcastle \
293     =       Launceston \
255     =       Sunshine Coast \
86      =       Spencer Gulf \
343     =       Bunbury \
71      =       Wollongong \
90      =       Ballarat \
266     =       Bendigo \
82      =       Port Augusta \
256     =       Toowoomba \
344     =       Albany \
258     =       Wide Bay \
259     =       South Coast \
102     =       Regional WA \
98      =       Gippsland \
85      =       South East SA \
69      =       Tamworth \
66      =       Central Coast \
254     =       Rockhampton \
267     =       Shepparton \
253     =       Mackay \
268     =       Albury/Wodonga \
263     =       Taree/Port Macquarie \
261     =       Lismore \
95      =       Mildura/Sunraysia \
257     =       Townsville \
292     =       Coffs Harbour \
79      =       Cairns \
114     =       Remote and Central \
108     =       Regional NT \
262     =       Orange/Dubbo \
107     =       Remote and Central \
264     =       Wagga Wagga \
67      =       Griffith \
63      =       Broken Hill \
106     =       Remote and Central \
168     =       Foxtel \
371     =       Foxtel Now \
192     =       Optus TV feat. Foxtel \
284     =       Fetch \

## freeepg
region_national \
region_nsw_sydney \
region_nsw_newcastle \
region_nsw_taree \
region_nsw_tamworth \
region_nsw_orange_dubbo_wagga \
region_nsw_northern_rivers \
region_nsw_wollongong \
region_nsw_canberra \
region_nt_regional \
region_vic_albury \
region_vic_shepparton \
region_vic_bendigo \
region_vic_melbourne \
region_vic_ballarat \
region_vic_gippsland \
region_qld_brisbane \
region_qld_goldcoast \
region_qld_toowoomba \
region_qld_maryborough \
region_qld_widebay \
region_qld_rockhampton \
region_qld_mackay \
region_qld_townsville \
region_qld_cairns \
region_sa_adelaide \
region_sa_regional \
region_wa_perth \
region_wa_regional_wa \
region_tas_hobart \
region_tas_launceston
