ip netns add pc1
ip netns add r1
ip netns add r2
ip netns add r3
ip netns add pc2

ip link add pc1r1 type veth peer name r1pc1
ip link add r1r2 type veth peer name r2r1
ip link add r2r3 type veth peer name r3r2
ip link add r3pc2 type veth peer name pc2r3

ip link set pc1r1 netns pc1
ip link set r1pc1 netns r1
ip link set r1r2 netns r1
ip link set r2r1 netns r2
ip link set r2r3 netns r2
ip link set r3r2 netns r3
ip link set r3pc2 netns r3
ip link set pc2r3 netns pc2

ip netns exec pc1 ip link set pc1r1 up
ip netns exec r1 ip link set r1pc1 up
ip netns exec r1 ip link set r1r2 up
ip netns exec r2 ip link set r2r1 up
ip netns exec r2 ip link set r2r3 up
ip netns exec r3 ip link set r3r2 up
ip netns exec r3 ip link set r3pc2 up
ip netns exec pc2 ip link set pc2r3 up

ip netns exec pc1 ip addr add 192.168.1.2/24 dev pc1r1
ip netns exec r1 ip addr add 192.168.1.1/24 dev r1pc1
ip netns exec r1 ip addr add 192.168.3.1/24 dev r1r2
ip netns exec r2 ip addr add 192.168.3.2/24 dev r2r1
ip netns exec r2 ip addr add 192.168.4.1/24 dev r2r3
ip netns exec r3 ip addr add 192.168.4.2/24 dev r3r2
ip netns exec r3 ip addr add 192.168.5.2/24 dev r3pc2
ip netns exec pc2 ip addr add 192.168.5.1/24 dev pc2r3


ip netns exec pc1 ip route add default via 192.168.1.1
ip netns exec pc2 ip route add default via 192.168.5.2


echo 1 > /proc/sys/net/ipv4/conf/all/forwarding

ip netns exec r1 bird -c bird_r1.conf -P bird_r1.pid -s bird_r1.socket
ip netns exec r2 bird -c bird_r2.conf -P bird_r2.pid -s bird_r2.socket
ip netns exec r3 bird -c bird_r3.conf -P bird_r3.pid -s bird_r3.socket


# ip netns exec r1 systemctl disable --now bird
# ip netns exec r2 systemctl disable --now bird
# ip netns exec r3 systemctl disable --now bird


# ip netns exec pc1 ping 192.168.1.1
# ip netns exec pc1 ping 192.168.5.1
