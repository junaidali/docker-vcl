#!/usr/bin/perl -w
use DBI;
use Socket;

my $ip_address = inet_ntoa(
	scalar gethostbyname( $ENV{'HOSTNAME'} || 'localhost' )
);

print "Configuring VCL Database";

print "\n[VCL DB CONFIG] Connnecting to VCL Database";
my $dsn = "DBI:mysql:database=$ENV{'MYSQL_DATABASE'};host=$ENV{'MYSQL_HOST'}";
my $dbh = DBI->connect($dsn, $ENV{'MYSQL_USER'}, $ENV{'MYSQL_PASSWORD'}) or die('ERROR - Could not connect to VCL database');

print "\n[VCL DB CONFIG] Connnected to VCL Database";

# check if node is already part of the managementnode table
my $mgmt_node_exists = 0;
my $select_statement = <<EOF;
SELECT * 
FROM managementnode 
WHERE hostname = '$ENV{'HOSTNAME'}'
EOF

my $sth = $dbh->prepare($select_statement);
$sth->execute();
while (my $ref = $sth->fetchrow_hashref()) {
	print "\n[VCL DB CONFIG] Row: id = $ref->{'id'}, hostname = $ref->{'hostname'}";
	$mgmt_node_exists = 1;
}

# if management node already exists, update IP address
if ($mgmt_node_exists) {
	print "\n[VCL DB CONFIG] Management Node already exists. Updating IP Address";
    my $update_managementnode = <<EOF;
UPDATE managementnode 
SET IPaddress = '$ip_address'
WHERE 
hostname = '$ENV{'HOSTNAME'}'
EOF
	$sth = $dbh->prepare($update_managementnode);
	$sth->execute();	
	print "\n[VCL DB CONFIG] managementnode ip address updated";
}
# create new management node entry to database
else {
	print "\n[VCL DB CONFIG] Management Node does not already exists. Updating managementnode table";
	my $update_managementnode = <<EOF;
INSERT INTO managementnode 
(IPaddress, hostname, stateid, `keys`, availablenetworks)
VALUES	
('$ip_address', '$ENV{'HOSTNAME'}', '2', '/etc/vcl-ssh-keys/vcl.key', 'NULL')
EOF
	$sth = $dbh->prepare($update_managementnode);
	$sth->execute();	
	print "\n[VCL DB CONFIG] managementnode table updated";

	print "\n[VCL DB CONFIG] Updating resource table";
	my $update_resource = <<EOF;
INSERT INTO vcl.resource 
(resourcetypeid, subid) 
VALUES 
('16', (SELECT id FROM vcl.managementnode WHERE hostname = '$ENV{'HOSTNAME'}'))
EOF
	$sth = $dbh->prepare($update_resource);
	$sth->execute();
	print "\n[VCL DB CONFIG] resource table updated";

	print "\n[VCL DB CONFIG] Updating resourcegroupmembers";
	my $update_resourcegroupmembers = <<EOF;
INSERT INTO 
vcl.resourcegroupmembers (resourceid, resourcegroupid) 
SELECT vcl.resource.id, vcl.resourcegroup.id 
FROM vcl.resource, vcl.resourcegroup 
WHERE vcl.resource.resourcetypeid = 16 
AND vcl.resourcegroup.resourcetypeid = 16
EOF

	$sth = $dbh->prepare($update_resourcegroupmembers);
	$sth->execute();
	print "\n[VCL DB CONFIG] resourcegroupmembers table updated";

}

# add to allManagementNodes group - insert into resourcegroupmembers (resourceid, resourcegroupid) VALUES (10, 3);
print "\n[VCL DB CONFIG] Adding to allManagementNodes Group";
print "\n[VCL DB CONFIG] getting resource id";

my $mgmt_node_resourceid = 0;
$select_statement = <<EOF;
SELECT r.id as rid 
FROM managementnode as m 
JOIN resource as r 
WHERE m.id = r.subid 
AND r.resourcetypeid = 16 
AND m.hostname =  '$ENV{'HOSTNAME'}'
EOF

$sth = $dbh->prepare($select_statement);
$sth->execute();
while (my $ref = $sth->fetchrow_hashref()) {
	print "\n[VCL DB CONFIG] Row: id = $ref->{'rid'}";
	$mgmt_node_resourceid = $ref->{'rid'};
}

if ($mgmt_node_resourceid) {
	# add to resource group allManagementNodes
	$update_resourcegroupmembers = <<EOF;
INSERT INTO resourcegroupmembers (resourceid, resourcegroupid)
VALUES ($mgmt_node_resourceid, 3)
EOF

	$sth = $dbh->prepare($update_resourcegroupmembers);
	$sth->execute();
	print "\n[VCL DB CONFIG] resourcegroupmembers table updated";
}

$sth->finish();

print "\n[VCL DB CONFIG] Disconnecting from the VCL Database";
$dbh->disconnect();
print "\n[VCL DB CONFIG] Disconnected from the VCL Database\n[VCL DB CONFIG] ";