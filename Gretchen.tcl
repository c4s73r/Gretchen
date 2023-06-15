puts "
#######################################################################
#                             GRETCHEN                                #
#          A tool to stop the Responder attacks by Caster             #
####################################################################### "

puts "Author: Caster, @c4s73r, <c4s73r@protonmail.com>"
puts "Direction: Network Security"
puts "Genre: Defensive"
puts "Label: Github"
puts " "
puts "Link: github.com/c4s73r/Gretchen"

puts " "
puts "Read the README before running the script!"
puts "This tool creates a special ACL and VACL, preventing Responder attack"
puts " "
proc gretchen {} {
    puts "Enter Extended IPv4 ACL Name:"
    set ipv4_acl [gets stdin]
    ios_config "ip access-list extended $ipv4_acl" "permit udp any eq 5355 any" "permit udp any eq 5353 any" "permit udp any eq 137 any"

    puts "Enter IPv6 ACL Name:"
    set ipv6_acl [gets stdin]

    ios_config "ipv6 access-list $ipv6_acl" "permit udp any eq 5355 any" "permit udp any eq 5353 any" "permit udp any eq 547 any"

    puts "Specify the VLAN where the responder will be blocked:"
    set vlan_id [gets stdin]
    puts " "

    puts "Blocking LLMNR, NBNS, MDNS, DHCPv6..."
    puts "Creating VACL..."
    ios_config "vlan access-map BLOCK-RESPONDER-VMAP 10" "match ip address $ipv4_acl" "match ipv6 address $ipv6_acl" "action drop log"
    ios_config "vlan access-map BLOCK-RESPONDER-VMAP 20" "action forward"

    puts "Setting VACL VLAN filter (VLAN: $vlan_id)"
    ios_config "vlan filter BLOCK-RESPONDER-VMAP vlan-list $vlan_id"

    puts " "
    puts "Now check the configuration with show run and make sure everything is OK"
}

gretchen
