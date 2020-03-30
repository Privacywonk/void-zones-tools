#!/bin/sh

#  void-zones-update.sh
#  void-zones-tools
#
# Shell Script for updating the void zones list by downloading from pre-defined hosts file providers
#
# Created by Dr. Rolf Jansen on 2016-11-16.
# Copyright (c) 2016, projectworld.net. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS
# OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER
# OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
# IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
# THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#
# Updated by Privacywonk 2019-08-31 to include six new sources for blacklists including:
# https://github.com/StevenBlack/hosts
# http://sysctl.org/cameleon/
# Abuse.ch/
# Disconnect.me trackers
# Host-file ad servers
# This should produce a de-duplicate blocking list of over 67,500 domains as of 2018-08-31


### verify the path to the fetch utility
if [ -e "/usr/bin/fetch" ]; then
   FETCH="/usr/bin/fetch"
elif [ -e "/usr/local/bin/fetch" ]; then
   FETCH="/usr/local/bin/fetch"
elif [ -e "/opt/local/bin/fetch" ]; then
   FETCH="/opt/local/bin/fetch"
else
   echo "No fetch utility can be found on the system -- Stopping."
   echo "On Mac OS X, execute either 'sudo port install fetch' or install"
   echo "fetch from source into '/usr/local/bin', and then try again."
   exit 1
fi


### Storage location of the dowloaded void hosts lists
ZONES_DIR="/usr/local/etc/void-zones"
if [ ! -d "$ZONES_DIR" ]; then
   mkdir -p "$ZONES_DIR"
fi
if [ ! -f "$ZONES_DIR/my_void_hosts.txt" ]; then
   echo "# white list"          > "$ZONES_DIR/my_void_hosts.txt"
   echo "1.1.1.1 my.white.dom" >> "$ZONES_DIR/my_void_hosts.txt"
   echo ""                     >> "$ZONES_DIR/my_void_hosts.txt"
   echo "# black list"         >> "$ZONES_DIR/my_void_hosts.txt"
   echo "0.0.0.0 my.black.dom" >> "$ZONES_DIR/my_void_hosts.txt"
fi


### Updating the void zones
$FETCH -o "$ZONES_DIR/pgl_void_hosts.txt"      "http://pgl.yoyo.org/as/serverlist.php?hostformat=hosts&showintro=0&useip=0.0.0.0&mimetype=plaintext"
$FETCH -o "$ZONES_DIR/sowc_void_hosts.txt"     "http://someonewhocares.org/hosts/zero/hosts"
$FETCH -o "$ZONES_DIR/mvps_void_hosts.txt"     "http://winhelp2002.mvps.org/hosts.txt"
$FETCH -o "$ZONES_DIR/mdl_void_hosts.txt"      "http://www.malwaredomainlist.com/hostslist/hosts.txt"
$FETCH -o "$ZONES_DIR/away_void_hosts.txt"     "https://adaway.org/hosts.txt"
$FETCH -o "$ZONES_DIR/jdom_void_list.txt"      "http://mirror1.malwaredomains.com/files/justdomains"
$FETCH -o "$ZONES_DIR/ucky_void_host.txt"     "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/UncheckyAds/hosts"
$FETCH -o "$ZONES_DIR/wintelm_void_hosts.txt" "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt"
#Added by PrivacyWonk
$FETCH -o "$ZONES_DIR/stevenblack_void_hosts.txt" "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
$FETCH -o "$ZONES_DIR/sysctl_void_hosts.txt" "http://sysctl.org/cameleon/hosts"
$FETCH -o "$ZONES_DIR/zeustracker_void_hosts.txt" "https://zeustracker.abuse.ch/blocklist.php?download=domainblocklist"
$FETCH -o "$ZONES_DIR/disconnectmeTracking_void_hosts.txt" "https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt"
$FETCH -o "$ZONES_DIR/disconnectmeAd_void_hosts.txt" "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt"
$FETCH -o "$ZONES_DIR/hostfileAd_hosts.txt" "https://hosts-file.net/ad_servers.txt"
$FETCH -o "$ZONES_DIR/covid_hosts.txt" "https://raw.githubusercontent.com/COVID-19-CTI-LEAGUE/PUBLIC_RELEASE/master/COVID-19-CTI-LEAGUE-PIHOLE-DOMAIN-BLACKLIST.txt"



if [ ! -f "$ZONES_DIR/pgl_void_hosts.txt" ] ; then
   echo "# No hosts from pgl." > "$ZONES_DIR/pgl_void_hosts.txt"
fi

if [ ! -f "$ZONES_DIR/sowc_void_hosts.txt" ] ; then
   echo "# No hosts from sowc." > "$ZONES_DIR/sowc_void_hosts.txt"
fi

if [ ! -f "$ZONES_DIR/mvps_void_hosts.txt" ] ; then
   echo "# No hosts from mvps." > "$ZONES_DIR/mvps_void_hosts.txt"
fi

if [ ! -f "$ZONES_DIR/mdl_void_hosts.txt" ] ; then
   echo "# No hosts from mdl." > "$ZONES_DIR/mdl_void_hosts.txt"
fi

if [ ! -f "$ZONES_DIR/away_void_hosts.txt" ] ; then
   echo "# No hosts from adaway." > "$ZONES_DIR/away_void_hosts.txt"
fi

if [ ! -f "$ZONES_DIR/jdom_void_list.txt" ] ; then
   echo "# No domain list from DNS-BH – Malware Domain Blocklist." > "$ZONES_DIR/jdom_void_list.txt"
fi

if [ ! -f "$ZONES_DIR/ucky_void_host.txt" ] ; then
   echo "# No hosts from FadeMind/unchecky." > "$ZONES_DIR/ucky_void_host.txt"
fi

if [ ! -f "$ZONES_DIR/wintelm_void_hosts.txt" ] ; then
   echo "# No hosts from WindowsSpyBlocker/hosts/spy." > "$ZONES_DIR/wintelm_void_hosts.txt"
fi

#PrivacyWonk Added
if [ ! -f "$ZONES_DIR/stevenblack_void_hosts.txt" ] ; then
   echo "# No hosts from Steven Black." > "$ZONES_DIR/stevenblack_void_hosts.txt"
fi
if [ ! -f "$ZONES_DIR/sysctl_void_hosts.txt" ] ; then
   echo "# No hosts from sysctl." > "$ZONES_DIR/sysctl_void_hosts.txt"
fi
if [ ! -f "$ZONES_DIR/zeustracker_void_hosts.txt" ] ; then
   echo "# No hosts from zeus tracker." > "$ZONES_DIR/zeustracker_void_hosts.txt"
fi
if [ ! -f "$ZONES_DIR/disconnectmeTracking_void_hosts.txt" ] ; then
   echo "# No hosts from disconnectme tracking." > "$ZONES_DIR/disconnectmeTracking_void_hosts.txt"
fi

if [ ! -f "$ZONES_DIR/disconnectmeAd_void_hosts.txt" ] ; then
   echo "# No hosts from disconnectme ad." > "$ZONES_DIR/disconnectmeAd_void_hosts.txt"
fi
if [ ! -f "$ZONES_DIR/hostfileAd_hosts.txt" ] ; then
   echo "# No hosts from https://hosts-file.net/ad_servers.txt." > "$ZONES_DIR/hostfileAd_hosts.txt"
fi
if [ ! -f "$ZONES_DIR/covid_hosts.txt" ] ; then
   echo "# No hosts from COVID-19-CTI-LEAGUE." > "$ZONES_DIR/covid_hosts.txt"
fi


/usr/local/bin/hosts2zones /tmp/local-void.zones \
                           "$ZONES_DIR/my_void_hosts.txt" \
                           "$ZONES_DIR/pgl_void_hosts.txt" \
                           "$ZONES_DIR/sowc_void_hosts.txt" \
                           "$ZONES_DIR/mvps_void_hosts.txt" \
                           "$ZONES_DIR/mdl_void_hosts.txt" \
                           "$ZONES_DIR/away_void_hosts.txt" \
                           "$ZONES_DIR/jdom_void_list.txt" \
                           "$ZONES_DIR/ucky_void_host.txt" \
                           "$ZONES_DIR/wintelm_void_hosts.txt" \
                           "$ZONES_DIR/x_void_list.txt" \
                           "$ZONES_DIR/y_void_list.txt" \
                           "$ZONES_DIR/z_void_list.txt" \
							"$ZONES_DIR/stevenblack_void_hosts.txt" \
							"$ZONES_DIR/sysctl_void_hosts.txt" \
							"$ZONES_DIR/zeustracker_void_hosts.txt" \
							"$ZONES_DIR/disconnectmeTracking_void_hosts.txt" \
							"$ZONES_DIR/disconnectmeAd_void_hosts.txt" \
							"$ZONES_DIR/hostfileAd_hosts.txt" \
							"$ZONES_DIR/covid_hosts.txt" \
  && /bin/mv /tmp/local-void.zones /var/unbound/local-void.zones
