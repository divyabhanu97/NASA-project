cd blockchainservice
./test-network/scripts/startFabric.sh

enter orgname:nasa, orgdomain:nasa.com
once it is onboarded successfully
./test-network/scripts/addOrg3.sh uhcl uhcl.com
./test-network/scripts/addOrg3.sh mbse mbse.com
./test-network/scripts/addOrg3.sh tietronix tietronix.com

from the above steps 4 orgs will be onboarded along with chaincode installation 

Now you need to modify the installation to have private collection

export CORE_PEER_LOCALMSPID=nasaMSP
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/test-network/organizations/peerOrganizations/nasa.com/peers/peer0.nasa.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/test-network/organizations/peerOrganizations/nasa.com/users/Admin@nasa.com/msp
export CORE_PEER_ADDRESS=localhost:7051
export ORDERER_CA=${PWD}/test-network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export CORE_PEER_TLS_ENABLED=true

peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls true --cafile ${PWD}/test-network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --channelID mbsemodel --name fabcar --version 1 --package-id fabcar_1:317edf78e900a143c2cdabd5f0bd864ed678dacb2d4c474c5a5f44a09c81aa7a --sequence 2 --collections-config ./chaincode-go/collections_config.json

peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls true --cafile ${PWD}/testnetwork/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --channelID mbsemodel --name fabcar --peerAddresses localhost:7056 --tlsRootCertFiles ${PWD}/test-network/organizations/peerOrganizations/uhcl.com/peers/peer0.uhcl.com/tls/ca.crt --version 1 --sequence 2 --collections-config ./chaincode-go/collections_config.json



export CORE_PEER_LOCALMSPID=uhclMSP
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/test-network/organizations/peerOrganizations/uhcl.com/peers/peer0.uhcl.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/test-network/organizations/peerOrganizations/uhcl.com/users/Admin@uhcl.com/msp
export CORE_PEER_ADDRESS=localhost:7056
export ORDERER_CA=${PWD}/test-network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export CORE_PEER_TLS_ENABLED=true

peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls true --cafile ${PWD}/test-network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --channelID mbsemodel --name fabcar --version 1 --package-id fabcar_1:317edf78e900a143c2cdabd5f0bd864ed678dacb2d4c474c5a5f44a09c81aa7a --sequence 2 --collections-config ./chaincode-go/collections_config.json


export CORE_PEER_LOCALMSPID=mbseMSP
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/test-network/organizations/peerOrganizations/mbse.com/peers/peer0.mbse.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/test-network/organizations/peerOrganizations/mbse.com/users/Admin@mbse.com/msp
export CORE_PEER_ADDRESS=localhost:7061
export ORDERER_CA=${PWD}/test-network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export CORE_PEER_TLS_ENABLED=true

peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls true --cafile ${PWD}/test-network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --channelID mbsemodel --name fabcar --version 1 --package-id fabcar_1:317edf78e900a143c2cdabd5f0bd864ed678dacb2d4c474c5a5f44a09c81aa7a --sequence 2 --collections-config ./chaincode-go/collections_config.json

CORE_PEER_LOCALMSPID=tietronixMSP
CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/test-network/organizations/peerOrganizations/tietronix.com/peers/peer0.tietronix.com/tls/ca.crt
CORE_PEER_MSPCONFIGPATH=${PWD}/test-network/organizations/peerOrganizations/tietronix.com/users/Admin@tietronix.com/msp
CORE_PEER_ADDRESS=localhost:7066
ORDERER_CA=${PWD}/test-network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
CORE_PEER_TLS_ENABLED=true

peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls true --cafile ${PWD}/test-network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem --channelID mbsemodel --name fabcar --version 1 --package-id fabcar_1:317edf78e900a143c2cdabd5f0bd864ed678dacb2d4c474c5a5f44a09c81aa7a --sequence 2 --collections-config ./chaincode-go/collections_config.json


to test the chaincode 




export ASSET_PROPERTIES=$(echo -n "{\"ActionId\":\"action001\",\"ActionName\":\"\",\"BCAssetId\":\"bcasset001\",\"BCAssetType\":\"\",\"BCAsset\":{\"BCAssetId\":\"bcasset001\",\"BCAssetType\":\"\",\"ProjectBCAssetId\":\"\",\"BCAssetName\":\"\",\"Description\":\"\",\"CRSubmissionTime\":\"\",\"IsWithdrawn\":false,\"WithdrawnTime\":\"\",\"CRDecision\":{\"CRDecisionTime\":\"\",\"CRDecisionNum\":0,\"CRDecisionStatus\":\"\"},\"CRComments\":{\"CommentTime\":\"\",\"Comment\":\"\",\"CommenterId\":\"\"},\"Project\":{\"IsTopLevel\":false,\"PORTType\":null,\"OrgRoles\":null,\"OrgUserRoleTypes\":null,\"OrgUserRoles\":null,\"BCAssetTypeRoleTypes\":null,\"BCAssetTypeRoles\":null,\"ParentProjectId\":\"\"}},\"AttributesToRead\":null,\"AttributesToUpdate\":{\"CRSubmissionTime\":\"\",\"CRDecision\":{\"CRDecisionTime\":\"\",\"CRDecisionNum\":0,\"CRDecisionStatus\":\"\"}}}" | base64 | tr -d \\n)

peer chaincode invoke -o localhost:7050 --tls --cafile $ORDERER_CA -C mbsemodel -n fabcar -c '{"function":"CreateCR","Args":[]}' --transient "{\"asset_properties\":\"$ASSET_PROPERTIES\"}"

peer chaincode query -C mbsemodel -n fabcar -c '{"Args":["AssetExists","bcasset001"]}'

peer chaincode query -C mbsemodel -n fabcar -c '{"Args":["ReadCR",{"ActionId":"action001","ActionName":"","BCAssetId":"bcasset001","BCAssetType":"","BCAsset":{"BCAssetId":"bcasset001","BCAssetType":"","ProjectBCAssetId":"","BCAssetName":"","Description":"","CRSubmissionTime":"","IsWithdrawn":false,"WithdrawnTime":"","CRDecision":{"CRDecisionTime":"","CRDecisionNum":0,"CRDecisionStatus":""},"CRComments":{"CommentTime":"","Comment":"","CommenterId":""},"Project":{"IsTopLevel":false,"PORTType":null,"OrgRoles":null,"OrgUserRoleTypes":null,"OrgUserRoles":null,"BCAssetTypeRoleTypes":null,"BCAssetTypeRoles":null,"ParentProjectId":""}},"AttributesToRead":null,"AttributesToUpdate":{"CRSubmissionTime":"","CRDecision":{"CRDecisionTime":"","CRDecisionNum":0,"CRDecisionStatus":""}}}]}'


