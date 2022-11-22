#Study of TCP performance - TCP.tcl
#Create a simulator object
set ns [new Simulator]
#Open trace files
set f [open droptail-queue-out.tr w]
$ns trace-all $f
#Open the nam trace file
set nf [open droptail-queue-out.nam w]
$ns namtrace-all $nf
#s1, s2 and s3 act as sources.
set s1 [$ns node]
set s2 [$ns node]
set s3 [$ns node]
#G acts as a gateway
set G [$ns node]
#r acts as a receiver
set r [$ns node]
#Define different colors for data flows
$ns color 1 red
$ns color 2 SeaGreen
$ns color 3 blue
#Create links between the nodes
$ns duplex-link $s1 $G 6Mb 10ms DropTail
$ns duplex-link $s2 $G 6Mb 10ms DropTail
$ns duplex-link $s3 $G 6Mb 10ms DropTail
$ns duplex-link $G $r 3Mb 10ms DropTail
#Define the layout of the nodes
$ns duplex-link-op $s1 $G orient right-up
$ns duplex-link-op $s2 $G orient right
$ns duplex-link-op $s3 $G orient right-down
$ns duplex-link-op $G $r orient right
#Define the queue size for the link between node G and r
$ns queue-limit $G $r 5
#Monitor the queues for links vertically
$ns duplex-link-op $s1 $G queuePos 0.5
$ns duplex-link-op $s2 $G queuePos 0.5
$ns duplex-link-op $s3 $G queuePos 0.5
$ns duplex-link-op $G $r queuePos 0.5
#Create a TCP agent and attach it to node s1
set tcp1 [new Agent/TCP/Reno]
$ns attach-agent $s1 $tcp1
$tcp1 set window_ 8
$tcp1 set fid_ 1
#Create a TCP agent and attach it to node s2
set tcp2 [new Agent/TCP/Reno]
$ns attach-agent $s2 $tcp2
$tcp2 set window_ 8
$tcp2 set fid_ 2
#Create a TCP agent and attach it to node s3
set tcp3 [new Agent/TCP/Reno]
$ns attach-agent $s3 $tcp3
$tcp3 set window_ 4
$tcp3 set fid_ 3
#Create TCP sink agents and attach them to node r
set sink1 [new Agent/TCPSink]
set sink2 [new Agent/TCPSink]
set sink3 [new Agent/TCPSink]
$ns attach-agent $r $sink1
$ns attach-agent $r $sink2
$ns attach-agent $r $sink3
#Connect the traffic sources with the traffic sinks
$ns connect $tcp1 $sink1
$ns connect $tcp2 $sink2
$ns connect $tcp3 $sink3
#Create FTP applications and attach them to agents
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
set ftp3 [new Application/FTP]
$ftp3 attach-agent $tcp3
#Define a 'finish' procedure
proc finish {} {
global ns
$ns flush-trace
puts "running nam..."
exec nam -a droptail-queue-out.nam &
exit 0
}
#Define label for nodes
$ns at 0.0 "$s1 label Sender1"
$ns at 0.0 "$s2 label Sender2"
$ns at 0.0 "$s3 label Sender3"
$ns at 0.0 "$G label Gateway"
$ns at 0.0 "$r label Receiver"
#Schedule ftp events
$ns at 0.1 "$ftp1 start"
$ns at 0.1 "$ftp2 start"
$ns at 0.1 "$ftp3 start"
$ns at 5.0 "$ftp1 stop"
$ns at 5.0 "$ftp2 stop"
$ns at 5.0 "$ftp3 stop"
#Call finish procedure after 5 seconds of simulation time
$ns at 5.25 "finish"
#Run the simulation
$ns run
