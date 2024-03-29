pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

/*
COPYRIGHT FRAN CASINO. 2019.
SECURITY CHECKS ARE COMMENTED FOR AN EASY USE TEST.
UNCOMMENT THE CODE FOR A FULLY FUNCTIONAL VERSION. 
YOU WILL NEED TO USE METAMASK OR OTHER EXTENSIONS TO USE THE REQUIRED ADDRESSES
ACTUALLY DATA ARE STORED IN THE SC. TO ENABLE IPFS, FUNCTIONS WILL NOT STORE the values and just the hash in the structs.
This can be changed in the code by calling the hash creation function. 
Nevertheless, the code is kept clear for the sake of understanding. 
TODO - Add into the hash algorithm the structs of the token. Now only initial info is hashed. 
*/

contract Vendors{
 
    struct Vendor{
        uint id; // this especific process, containing id and quantity
        string name; // the vendor
        string timestamp; //
        string description; // other info
        address maker; // who registered
        bool active;
        string hashIPFS; // hash of the elements of the struct, for auditing AND IPFS 
    }

    mapping(uint => Vendor) private vendorChanges; //

    uint private vendorCount;

    // events, since SC is for global accounts it does not have too much sense but is left here 
    event updateEvent ( // triggers update complete
    );
    
    event changeStatusEvent ( // triggers status change
    );

    address constant public vendor = 0xE0f5206BBD039e7b0592d8918820024e2a7437b9; // who registers the token into system. 
    address constant public vendor2 = 0xE0F5206bbd039e7b0592d8918820024E2A743222;

    constructor () public { // constructor, inserts new token in system. we map starting from id=1, hardcoded values of all
        addVendor("Manufacturer","1130009112019","Local producer of vegetables"); //
        
    }
    
    // add stakeholder to the list
    function addVendor (string memory _name, string memory _timestamp, string memory _description) public {
        
        vendorCount++;
        vendorChanges[vendorCount].id = vendorCount;
        vendorChanges[vendorCount].name = _name; 
        vendorChanges[vendorCount].timestamp = _timestamp; 
        vendorChanges[vendorCount].description = _description; 
        vendorChanges[vendorCount].active = true; 
        vendorChanges[vendorCount].maker = msg.sender;
        emit updateEvent(); // trigger event 
    }

    function changeStatus (uint memory _id, bool memory _active) public {
        require(_id > 0 && _id <= vendorCount); 
        vendorChanges[vendorCount].active = _active;
        emit changeStatusEvent(); // trigger event 
    }

    function getVendor (uint memory _id) public view returns (Vendor memory)  {
        require(_id > 0 && _id <= vendorCount);  
        require(msg.sender == vendorChanges[_id].maker); // only if he is the author of the content
        
        return vendorChanges[_id];
    }
    
    // returns global number of status, needed to iterate the mapping and to know info.
    function getNumberOfVendors () public view returns (uint){    
        //tx.origin
        return vendorCount;
    }

}
