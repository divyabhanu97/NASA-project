function createOrg1 {

  ORG_NAME=$1
  ORG_DOMAIN=$2
  PEERPORT=$3

  echo  "${ORG_NAME} ${ORG_DOMAIN} ${PEERPORT}  in regeister enroll"
	echo "Enroll the CA admin"
  echo
	# mkdir -p ${PWD}/organizations/fabric-ca/${ORG_NAME}/
  # sudo chmod 777 ${PWD}/organizations/fabric-ca/${ORG_NAME}/

  # sudo cp  -r ${PWD}/organizations/fabric-ca/template/template-ca-server-config.yaml  ${PWD}/organizations/fabric-ca/${ORG_NAME}/fabric-ca-server-config.yaml
  # sed -i "s/ORG_NAME/${ORG_NAME}/g;s/ORG_DOMAIN/${ORG_DOMAIN}/g" ${PWD}/organizations/fabric-ca/${ORG_NAME}/fabric-ca-server-config.yaml

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/${ORG_DOMAIN}/
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:${CAPORT} --caname ca-${ORG_NAME} --tls.certfiles ${PWD}/organizations/fabric-ca/${ORG_NAME}/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-'${CAPORT}'-ca-'${ORG_NAME}'.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-'${CAPORT}'-ca-'${ORG_NAME}'.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-'${CAPORT}'-ca-'${ORG_NAME}'.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-'${CAPORT}'-ca-'${ORG_NAME}'.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/peerOrganizations/${ORG_DOMAIN}/msp/config.yaml

  echo
	echo "Register peer0"
  echo
  set -x
	fabric-ca-client register --caname ca-${ORG_NAME} --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/${ORG_NAME}/tls-cert.pem
  set +x

  echo
  echo "Register user"
  echo
  set -x
  # [{ name: ‘role’, value: ‘approver’, ecert: true }]
  fabric-ca-client register --caname ca-${ORG_NAME} --id.name user1 --id.secret user1pw --id.type client --id.affiliation ${ORG_NAME} --id.attrs 'role=CSE:' --tls.certfiles ${PWD}/organizations/fabric-ca/${ORG_NAME}/tls-cert.pem
  # fabric-ca-client register --caname ca-${ORG_NAME} --id.name user2 --id.secret user2pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/${ORG_NAME}/tls-cert.pem
  set +x

  echo
  echo "Register the org admin"
  echo
  set -x
  fabric-ca-client register --caname ca-${ORG_NAME} --id.name ${ORG_NAME}admin --id.secret ${ORG_NAME}adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/${ORG_NAME}/tls-cert.pem
  set +x
 
	mkdir -p organizations/peerOrganizations/${ORG_DOMAIN}/peers

  mkdir -p organizations/peerOrganizations/${ORG_DOMAIN}/peers/peer0.${ORG_DOMAIN}
  chmod 777 organizations/peerOrganizations/${ORG_DOMAIN}/peers
  chmod 777 organizations/peerOrganizations/${ORG_DOMAIN}/peers/peer0.${ORG_DOMAIN}

  echo
  echo "## Generate the peer0 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:${CAPORT} --caname ca-${ORG_NAME} -M ${PWD}/organizations/peerOrganizations/${ORG_DOMAIN}/peers/peer0.${ORG_DOMAIN}/msp --csr.hosts peer0.${ORG_DOMAIN} --tls.certfiles ${PWD}/organizations/fabric-ca/${ORG_NAME}/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/${ORG_DOMAIN}/msp/config.yaml ${PWD}/organizations/peerOrganizations/${ORG_DOMAIN}/peers/peer0.${ORG_DOMAIN}/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:${CAPORT} --caname ca-${ORG_NAME} -M ${PWD}/organizations/peerOrganizations/${ORG_DOMAIN}/peers/peer0.${ORG_DOMAIN}/tls --enrollment.profile tls --csr.hosts peer0.${ORG_DOMAIN} --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/${ORG_NAME}/tls-cert.pem
  set +x


  cp ${PWD}/organizations/peerOrganizations/${ORG_DOMAIN}/peers/peer0.${ORG_DOMAIN}/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/${ORG_DOMAIN}/peers/peer0.${ORG_DOMAIN}/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/${ORG_DOMAIN}/peers/peer0.${ORG_DOMAIN}/tls/signcerts/* ${PWD}/organizations/peerOrganizations/${ORG_DOMAIN}/peers/peer0.${ORG_DOMAIN}/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/${ORG_DOMAIN}/peers/peer0.${ORG_DOMAIN}/tls/keystore/* ${PWD}/organizations/peerOrganizations/${ORG_DOMAIN}/peers/peer0.${ORG_DOMAIN}/tls/server.key

  mkdir ${PWD}/organizations/peerOrganizations/${ORG_DOMAIN}/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/${ORG_DOMAIN}/peers/peer0.${ORG_DOMAIN}/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/${ORG_DOMAIN}/msp/tlscacerts/ca.crt

  mkdir ${PWD}/organizations/peerOrganizations/${ORG_DOMAIN}/tlsca
  cp ${PWD}/organizations/peerOrganizations/${ORG_DOMAIN}/peers/peer0.${ORG_DOMAIN}/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/${ORG_DOMAIN}/tlsca/tlsca.${ORG_DOMAIN}-cert.pem

  mkdir ${PWD}/organizations/peerOrganizations/${ORG_DOMAIN}/ca
  cp ${PWD}/organizations/peerOrganizations/${ORG_DOMAIN}/peers/peer0.${ORG_DOMAIN}/msp/cacerts/* ${PWD}/organizations/peerOrganizations/${ORG_DOMAIN}/ca/ca.${ORG_DOMAIN}-cert.pem

  mkdir -p organizations/peerOrganizations/${ORG_DOMAIN}/users
  mkdir -p organizations/peerOrganizations/${ORG_DOMAIN}/users/User1@${ORG_DOMAIN}

  echo
  echo "## Generate the user msp"
  echo
  set -x
	
  fabric-ca-client enroll -u https://user1:user1pw@localhost:${CAPORT} --caname ca-${ORG_NAME} --enrollment.attrs "role" -M ${PWD}/organizations/peerOrganizations/${ORG_DOMAIN}/users/User1@${ORG_DOMAIN}/msp --tls.certfiles ${PWD}/organizations/fabric-ca/${ORG_NAME}/tls-cert.pem
  
  cp ${PWD}/organizations/peerOrganizations/${ORG_DOMAIN}/msp/config.yaml ${PWD}/organizations/peerOrganizations/${ORG_DOMAIN}/users/User1@${ORG_DOMAIN}/msp/config.yaml
  set +x

  mkdir -p organizations/peerOrganizations/${ORG_DOMAIN}/users/Admin@${ORG_DOMAIN}

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://${ORG_NAME}admin:${ORG_NAME}adminpw@localhost:${CAPORT} --caname ca-${ORG_NAME} -M ${PWD}/organizations/peerOrganizations/${ORG_DOMAIN}/users/Admin@${ORG_DOMAIN}/msp --tls.certfiles ${PWD}/organizations/fabric-ca/${ORG_NAME}/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/${ORG_DOMAIN}/msp/config.yaml ${PWD}/organizations/peerOrganizations/${ORG_DOMAIN}/users/Admin@${ORG_DOMAIN}/msp/config.yaml

}

function createOrderer {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/ordererOrganizations/example.com

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/example.com
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml


  echo
	echo "Register orderer"
  echo
  set -x
	fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
    set +x

  echo
  echo "Register the orderer admin"
  echo
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  mkdir -p organizations/ordererOrganizations/example.com/orderers
  mkdir -p organizations/ordererOrganizations/example.com/orderers/example.com

  mkdir -p organizations/ordererOrganizations/example.com/orderers/orderer.example.com

  echo
  echo "## Generate the orderer msp"
  echo
  set -x
	fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/config.yaml

  echo
  echo "## Generate  the orderer-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls --enrollment.profile tls --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key

  mkdir ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir -p organizations/ordererOrganizations/example.com/users
  mkdir -p organizations/ordererOrganizations/example.com/users/Admin@example.com

  echo
  echo "## Generate the admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml


}

