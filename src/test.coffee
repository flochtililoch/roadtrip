pcap = require 'pcap'

session = pcap.createSession 'wlan0', '(type mgt subtype beacon) or (type mgt subtype probe-req)'
session.on 'packet', (raw_packet) ->
  console.log (raw_packet)
      # with(pcap.decode.packet(raw_packet).link.ieee802_11Frame)
      #   if (type == 0 && subType == 4)
      #     console.log("Probe request",shost, "-> ",bssid)
