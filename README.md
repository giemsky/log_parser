# Webserver log parser

Script returns most visited pages by all and unique users.

```
ruby parser.rb logfile [options]
    -l, --limit=LIMIT           Limits results number
```



## Input format

```
/help_page/1 126.318.035.038
/contact 184.123.665.067
/home 184.123.665.067
/about/2 444.701.448.104
/help_page/1 929.398.951.889
/index 444.701.448.104
/help_page/1 722.247.931.582
/about 061.945.150.735
/help_page/1 646.865.545.408
/home 235.313.352.950
/contact 184.123.665.067
/help_page/1 543.910.244.929
/home 316.433.849.805
/about/2 444.701.448.104
/contact 543.910.244.929
/about 126.318.035.038
/about/2 836.973.694.403
/index 316.433.849.805
/index 802.683.925.780
/help_page/1 929.398.951.889
```