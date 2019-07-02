#!/usr/bin/env bash 

function main() {

if [ -z $1 ]; then 
	echo "Usage: $0 keyname" 
	exit 1 
else
	NAME=$1
fi 

configFile="$(getConfigFile)"

#openssl rand -writerand .rnd
# create CA key and certificate and self-sign it (-new -x509)
printf "\n[ -+ Creating CA key and certificate +- ]\n"
openssl req -new -newkey rsa:2048 -keyout ca_$NAME.key -x509 -days 3653 -out ca_$NAME.crt -config <(getConfigFile)
# create the request for a certificate (-reqexts need to tell it to pull that section from the main config)
printf "\n[ -+ Creating request for signer certificate +- ]\n"
openssl genrsa -out $NAME.key 2048
openssl req -new -key $NAME.key -reqexts v3_req -out $NAME.csr -config <(getConfigFile)
# sign the code signing cert with the certificate authority (only v3_req from config ***WITHOUT HEADER***)
printf "\n[ -+ Signing codesign certificate +- ]\n"
openssl x509 -req -days 3653 -in $NAME.csr -CA ca_$NAME.crt -CAkey ca_$NAME.key -set_serial 01 -out $NAME.crt -extfile <(getConfigFile | tail -n 5)
#expoort key and crt into a PKCS12
openssl pkcs12 -export -out $NAME.pfx -inkey $NAME.key -in $NAME.crt

}

function getConfigFile() {
cat <<EOF
HOME			= .
RANDFILE		= .rnd
oid_section		= new_oids
[ new_oids ]
tsa_policy1 = 1.2.3.4.1
tsa_policy2 = 1.2.3.4.5.6
tsa_policy3 = 1.2.3.4.5.7
[ ca ]
default_ca	= CA_default		# The default ca section
[ CA_default ]
dir		= ./demoCA		# Where everything is kept
certs		= $dir/certs		# Where the issued certs are kept
crl_dir		= $dir/crl		# Where the issued crl are kept
database	= $dir/index.txt	# database index file.
new_certs_dir	= $dir/newcerts		# default place for new certs.
certificate	= $dir/cacert.pem 	# The CA certificate
serial		= $dir/serial 		# The current serial number
crlnumber	= $dir/crlnumber	# the current crl number
crl		= $dir/crl.pem 		# The current CRL
private_key	= $dir/private/cakey.pem# The private key
RANDFILE	= $dir/private/.rand	# private random number file
x509_extensions	= usr_cert		# The extentions to add to the cert
name_opt 	= ca_default		# Subject Name options
cert_opt 	= ca_default		# Certificate field options
default_days	= 365			# how long to certify for
default_crl_days= 30			# how long before next CRL
default_md	= default		# use public key default MD
preserve	= no			# keep passed DN ordering
policy		= policy_match
[ policy_match ]
countryName		= match
stateOrProvinceName	= match
organizationName	= match
organizationalUnitName	= optional
commonName		= supplied
emailAddress		= optional
[ policy_anything ]
countryName		= optional
stateOrProvinceName	= optional
localityName		= optional
organizationName	= optional
organizationalUnitName	= optional
commonName		= supplied
emailAddress		= optional
[ req ]
default_bits		= 1024
default_keyfile 	= privkey.pem
distinguished_name	= req_distinguished_name
attributes		= req_attributes
x509_extensions	= v3_ca	# The extentions to add to the self signed cert
string_mask = utf8only
[ req_distinguished_name ]
countryName			= Country Name (2 letter code)
countryName_default		= IN
countryName_min			= 2
countryName_max			= 2
stateOrProvinceName		= State or Province Name (full name)
stateOrProvinceName_default	= Sri
localityName			= Locality Name (eg, city)
0.organizationName		= Organization Name (eg, company)
0.organizationName_default	= gvaduha@gmail.com
organizationalUnitName		= Organizational Unit Name (eg, section)
commonName			= Common Name (e.g. server FQDN or YOUR name)
commonName_default  = gvaduha@gmail.com
commonName_max			= 64
emailAddress			= Email Address
emailAddress_default	= gvaduha@gmail.com
emailAddress_max		= 64
[ req_attributes ]
challengePassword		= A challenge password
challengePassword_min		= 4
challengePassword_max		= 20
unstructuredName		= An optional company name
[ tsa ]
default_tsa = tsa_config1	# the default TSA section
[ tsa_config1 ]
dir		= ./demoCA		# TSA root directory
serial		= $dir/tsaserial	# The current serial number (mandatory)
crypto_device	= builtin		# OpenSSL engine to use for signing
signer_cert	= $dir/tsacert.pem 	# The TSA signing certificate
certs		= $dir/cacert.pem	# Certificate chain to include in reply
signer_key	= $dir/private/tsakey.pem # The TSA private key (optional)
default_policy	= tsa_policy1		# Policy if request did not specify it
other_policies	= tsa_policy2, tsa_policy3	# acceptable policies (optional)
digests		= md5, sha1		# Acceptable message digests (mandatory)
accuracy	= secs:1, millisecs:500, microsecs:100	# (optional)
clock_precision_digits  = 0	# number of digits after dot. (optional)
ordering		= yes	# Is ordering defined for timestamps?
tsa_name		= yes	# Must the TSA name be included in the reply?
ess_cert_id_chain	= no	# Must the ESS cert id chain be included?
#[ usr_cert ]
#basicConstraints=CA:FALSE
#nsComment			= "OpenSSL Generated Certificate"
#subjectKeyIdentifier=hash
#authorityKeyIdentifier=keyid,issuer
#[ crl_ext ]
#authorityKeyIdentifier=keyid:always
#[ proxy_cert_ext ]
#basicConstraints=CA:FALSE
#nsComment			= "OpenSSL Generated Certificate"
#subjectKeyIdentifier=hash
#authorityKeyIdentifier=keyid,issuer
#proxyCertInfo=critical,language:id-ppl-anyLanguage,pathlen:3,policy:foo
[ v3_ca ]
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid:always,issuer
basicConstraints = CA:true
#extendedKeyUsage = codeSigning, msCodeInd, msCodeCom
[ v3_req  ] 
subjectKeyIdentifier=hash
basicConstraints = CA:FALSE
keyUsage = digitalSignature
extendedKeyUsage = codeSigning, msCodeInd, msCodeCom
nsCertType = client, email, objsign
EOF
}

main "$@"
