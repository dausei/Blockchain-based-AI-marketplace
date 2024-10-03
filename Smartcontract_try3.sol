// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract AIMarketplace {
    struct Model {
        string name;
        string description;
        uint256 price;
        address payable creator;
        uint8 ratingCount;
        uint256 totalRating;
    }

    Model[] public models;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function listModel(string memory name, string memory description, uint256 price) public {
        models.push(Model({
            name: name,
            description: description,
            price: price,
            creator: payable(msg.sender),
            ratingCount: 0,
            totalRating: 0
        }));
    }

    function purchaseModel(uint256 modelId) public payable {
        require(modelId < models.length, "Model does not exist");
        require(msg.value == models[modelId].price, "Incorrect value sent");

        models[modelId].creator.transfer(msg.value);
    }

    function rateModel(uint256 modelId, uint8 rating) public {
        require(modelId < models.length, "Model does not exist");
        require(rating >= 1 && rating <= 5, "Rating must be between 1 and 5");

        models[modelId].ratingCount++;
        models[modelId].totalRating += rating;
    }

    function withdrawFunds() public {
        require(msg.sender == owner, "Only owner can withdraw funds");
        payable(msg.sender).transfer(address(this).balance);
    }

    function getModelDetails(uint256 modelId) public view returns (string memory, string memory, uint256, address, uint8, uint256) {
        require(modelId < models.length, "Model does not exist");
        Model memory model = models[modelId];
        return (model.name, model.description, model.price, model.creator, model.ratingCount, model.totalRating);
    }

    function modelCount() public view returns (uint256) {
        return models.length;
    }
    function getOwner() public view returns (address) {
    return owner;
}
}
