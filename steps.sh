export CORE_PEER_LOCALMSPID=nasaMSP
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/test-network/organizations/peerOrganizations/nasa.com/peers/peer0.nasa.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/test-network/organizations/peerOrganizations/nasa.com/users/User1@nasa.com/msp
export CORE_PEER_ADDRESS=localhost:7051
export ORDERER_CA=${PWD}/test-network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export CORE_PEER_TLS_ENABLED=true
export FABRIC_CFG_PATH=$PWD/config/


export FABRIC_CA_CLIENT_HOME=${PWD}/test-network/organizations/peerOrganizations/nasa.com
fabric-ca-client register --id.name creator1 --id.secret creator1pw --id.type client --id.affiliation nasa --id.attrs 'role=CSE:' --tls.certfiles "${PWD}/test-network/organizations/fabric-ca/nasa/tls-cert.pem"
fabric-ca-client enroll -u https://creator1:creator1pw@localhost:7054 --caname ca-nasa --enrollment.attrs "role" -M "${PWD}/test-network/organizations/peerOrganizations/nasa.com/users/creator1@nasa.com/msp" --tls.certfiles "${PWD}/test-network/organizations/fabric-ca/nasa/tls-cert.pem"
cp "${PWD}/test-network/organizations/peerOrganizations/nasa.com/msp/config.yaml" "${PWD}/test-network/organizations/peerOrganizations/nasa.com/users/creator1@nasa.com/msp/config.yaml"


export FABRIC_CA_CLIENT_HOME=${PWD}/test-network/organizations/peerOrganizations/nasa.com
fabric-ca-client register --id.name reader1 --id.secret reader1pw --id.type client --id.affiliation nasa --id.attrs 'role=admin:' --tls.certfiles "${PWD}/test-network/organizations/fabric-ca/nasa/tls-cert.pem"
fabric-ca-client enroll -u https://reader1:reader1pw@localhost:7054 --caname ca-nasa --enrollment.attrs "role" -M "${PWD}/test-network/organizations/peerOrganizations/nasa.com/users/reader1@nasa.com/msp" --tls.certfiles "${PWD}/test-network/organizations/fabric-ca/nasa/tls-cert.pem"
cp "${PWD}/test-network/organizations/peerOrganizations/nasa.com/msp/config.yaml" "${PWD}/test-network/organizations/peerOrganizations/nasa.com/users/reader1@nasa.com/msp/config.yaml"

#Create Asset
peer chaincode invoke -o localhost:7050 --tls --cafile $ORDERER_CA -C mbsemodel -n fabcar -c '{"function":"CreateAsset","Args":["Asset3","blue","20","100"]}'
peer chaincode query -C mbsemodel -n fabcar -c '{"function":"ReadAsset","Args":["Asset3"]}'
export CORE_PEER_MSPCONFIGPATH=${PWD}/test-network/organizations/peerOrganizations/nasa.com/users/reader1@nasa.com/msp
peer chaincode query -C mbsemodel -n fabcar -c '{"function":"ReadAssetabac","Args":["Asset3"]}'

#Transfer Asset
export RECIPIENT="x509::CN=creator1,OU=nasa+OU=client,O=Hyperledger,ST=North Carolina,C=US::CN=ca.nasa.com,O=nasa.com,L=Durham,ST=North Carolina,C=US"
peer chaincode invoke -o localhost:7050 --tls --cafile $ORDERER_CA -C mbsemodel -n fabcar -c '{"function":"TransferAsset","Args":["Asset3","'"$RECIPIENT"'"]}'
peer chaincode query -C mbsemodel -n fabcar -c '{"function":"ReadAsset","Args":["Asset3"]}'


export CORE_PEER_MSPCONFIGPATH=${PWD}/test-network/organizations/peerOrganizations/nasa.com/users/creator1@nasa.com/msp
peer chaincode invoke -o localhost:7050 --tls --cafile $ORDERER_CA -C mbsemodel -n fabcar -c '{"function":"UpdateAsset","Args":["Asset3","green","20","100"]}'

peer chaincode query -C mbsemodel -n fabcar -c '{"function":"GetAllAssets","Args":[""]}'