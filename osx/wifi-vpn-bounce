#!/bin/bash
# Disconnect and reconnect every connected WireGuard tunnel when the Wi-Fi
# network changes. Run by the aroberts.wifi-vpn-bounce LaunchAgent.
#
# SSID and BSSID are redacted for non-privileged processes on current macOS,
# so a network change is detected as a change in the Wi-Fi service's
# NetworkSignature (router address and router MAC). Roaming between access
# points on one network keeps it and does not trigger a bounce.
#
# Tunnels are the WireGuard app's (com.wireguard.macos) and are driven with
# scutil --nc, which needs no sudo. Tailscale and other VPNs are left alone.

set -u

# overridable so the logic can be tested without touching Wi-Fi or VPNs
nc=${WIFI_VPN_NC:-scutil --nc}

wifi_if=$(networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/ {getline; print $2; exit}')
wifi_if=${wifi_if:-en0}

log() { printf '%s %s\n' "$(date '+%F %T')" "$*"; }

signature() {
  if [ -n "${WIFI_VPN_SIGNATURE_CMD:-}" ]; then
    $WIFI_VPN_SIGNATURE_CMD
    return
  fi
  local key info sig
  while IFS= read -r key; do
    info=$(scutil <<< "show $key")
    grep -q "^  InterfaceName : $wifi_if\$" <<< "$info" || continue
    sig=$(awk -F' : ' '/^  NetworkSignature :/ {print $2}' <<< "$info")
    # no signature without a router; use the address and mask instead
    [ -n "$sig" ] || sig=$(awk '/^  Addresses : <array>/ {getline; a=$3} /^  SubnetMasks : <array>/ {getline; m=$3} END {if (a) print a "/" m}' <<< "$info")
    echo "$sig"
    return
  done < <(scutil <<< "list State:/Network/Service/[^/]+/IPv4" | awk '/subKey/ {print $NF}')
}

# prints the name of each connected WireGuard tunnel
active_tunnels() {
  $nc list | awk '/^\* \(Connected\)/ && /com\.wireguard\.macos/ {
    if (match($0, /"[^"]*"/)) print substr($0, RSTART + 1, RLENGTH - 2)
  }'
}

wait_for() { # <tunnel> <status> <seconds>
  local i
  for ((i = 0; i < $3 * 2; i++)); do
    [ "$($nc status "$1" | head -1)" = "$2" ] && return 0
    sleep 0.5
  done
  return 1
}

bounce() {
  local name
  while IFS= read -r name; do
    log "bouncing $name"
    $nc stop "$name"
    wait_for "$name" Disconnected 10 || log "$name did not disconnect in 10s"
    $nc start "$name"
  done < <(active_tunnels)
}

watch_events() {
  if [ -n "${WIFI_VPN_WATCH_CMD:-}" ]; then
    $WIFI_VPN_WATCH_CMD
  else
    { printf 'n.add State:/Network/Interface/%s/IPv4\nn.watch\n' "$wifi_if"; exec sleep 2147483647; } | scutil
  fi
}

last=$(signature)
log "watching $wifi_if (network: ${last:-none})"

while IFS= read -r line; do
  case $line in *changedKey*) ;; *) continue ;; esac
  sleep "${WIFI_VPN_SETTLE:-3}" # let DHCP and DNS settle
  current=$(signature)
  # empty while the interface is down; keep the old value and wait for the next network
  [ -n "$current" ] && [ "$current" != "$last" ] || continue
  log "network changed: ${last:-none} -> $current"
  last=$current
  bounce
done < <(watch_events)
