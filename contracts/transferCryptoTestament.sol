// SPDX-License-Identifier: GPL-3.0
pragma solidity >0.8.0;

contract transferCryptoTestament  {
    receive() external payable {
            emit updateData("receive",msg.sender,msg.value);
    }
    // owner of testoment
    address private owner;
    //remain percent of property
    uint private remain;
    uint private cnt;
    //address of Beneficiaries
    address[] addrBeneficiaries;
    //mapp address -> their percent will receive
    bool private death;
    //checkpoint
    uint checkPoint;
    event updateData(string action,address mem, uint percent);
    mapping(address => uint) private beneficiaries;
    constructor(){
        cnt=0;
        death=false;
        owner=tx.origin;
        remain=100;
        checkPoint=block.timestamp+31556926*2;
    }
    //some modifire function
    modifier onlyOwner{
        require(msg.sender==owner,"You're not a owner");
        _;
    }
    modifier alive{
        require(!death,"owner was death");
        _;
    }
    modifier wasDeath{
        require(death,"owner still have alived");
        _;
    }
    //some get function
    function getDeath() public returns(uint lefttime,string memory mess){
        if (death){
            return(0,"owner was death");
        }
        if (checkPoint<=block.timestamp){
            death=true;
            return(checkPoint-block.timestamp,"owner was death");
        }
        return(checkPoint-block.timestamp,"owner alive");
    }
    function getTimeLeft() public view returns(uint leftTime){
        return checkPoint-block.timestamp;
    }
    function getMount() public view returns(uint) {
        return address(this).balance;
    }
    function getRemain() public view returns(uint){
        return remain;
    }
    function getOwner() public view returns(address){
        return owner;
    }

    function getAddrBeneficiaries() public view returns(address [] memory mem){
        return addrBeneficiaries;
    }
    function getPercentAddress(address mem) public view returns(uint){
        return beneficiaries[mem];
    }
    //add member
    function addBeneficiary(address mem,uint percent) public alive onlyOwner{
        require(remain>=percent,"not enouth");
        if(beneficiaries[mem]==0){
            addrBeneficiaries.push(mem);
            cnt++;
        }
        beneficiaries[mem]+=percent;
        remain-=percent;
        emit updateData("addMem",mem,percent);
    }
    //rm member
    //TODO
    function rmBeneficiary(address mem) public alive{
        require(beneficiaries[mem]>0,"not exist");
        remain+=beneficiaries[mem];
        emit updateData("remove Mem",mem,beneficiaries[mem]);
        uint temp;
        for (uint i=0;i<cnt;i++){
            if (addrBeneficiaries[i]==mem){
                temp=i;
                break;
            }
        }
        for (uint i=temp;i<cnt-1;i++){
            addrBeneficiaries[i]=addrBeneficiaries[i+1];
        }
        beneficiaries[mem]=0;
    }
    function withdraw(uint _mount) public payable alive{
        require(_mount<=address(this).balance,"Not enouth");
        payable(owner).transfer(_mount);
        emit updateData("withdraw",owner,_mount);
    }
    function testament() public payable wasDeath(){
        uint total=address(this).balance;
        for (uint i=0;i<addrBeneficiaries.length;i++){   
            address tmpAddr=addrBeneficiaries[i];
            payable(tmpAddr).transfer(total*beneficiaries[tmpAddr]/100);
            emit updateData("testament",tmpAddr,total*beneficiaries[tmpAddr]/100);
        }
    }

    //TODO
    function rollUp()public alive onlyOwner{
        if (block.timestamp>checkPoint)
            turnDeath();
        else if (block.timestamp>checkPoint-31556926*2)
            checkPoint+=31556926*2;

    }
    function turnDeath() public alive onlyOwner{
        death=true;
    }

}

contract MutiTestament{
    mapping(address=>transferCryptoTestament) testamentOwner;
    address[] owners;
    address a=0x0000000000000000000000000000000000000000;
    function getTestamentAddress(address _owner) public view returns(transferCryptoTestament){
        return testamentOwner[_owner];
    }
    modifier notExist(address _owner){
        require(address(testamentOwner[_owner])==a,"has testament");
        _;
    }
    function newTestament() public notExist(msg.sender) returns(transferCryptoTestament){
        testamentOwner[msg.sender]=new transferCryptoTestament();
        owners.push(msg.sender);
        return testamentOwner[msg.sender];
    }

}
