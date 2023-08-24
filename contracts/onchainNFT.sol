// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// Imports
// ========================================================
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

// Contract
// ========================================================
contract onchainNFT is ERC721 {
    // Extending functionality
    using Strings for uint256;

    /**
     * Main constructor
     */
    constructor() ERC721("onchainNFT", "onchainNFT") {}

    /**
     * Main minting function
     */
    function safeMint(address to, uint256 tokenId) public {
        _safeMint(to, tokenId);
    }

    // The following functions are overrides required by Solidity.
    /**
     * @dev See {ERC721}
     */
    function _burn(uint256 tokenId) internal override(ERC721) {
        super._burn(tokenId);
    }

    /**
     * Public function or burning
     */
    function burn (uint256 tokenId) public {
        _burn(tokenId);
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721)
        returns (string memory)
    {
        // Validation
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        
        // SVG Image
        bytes memory imageSVG = abi.encodePacked(
            "<svg width=\"256\" height=\"256\" viewBox=\"0 0 256 256\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\">",
            "<style xmlns=\"http://www.w3.org/2000/svg\">@keyframes rainbow-background { 0% { fill: #ff0000; } 8.333% { fill: #ff8000; } 16.667% { fill: #ffff00; } 25.000% { fill: #80ff00; } 33.333% { fill: #00ff00; } 41.667% { fill: #00ff80; } 50.000% { fill: #00ffff; } 58.333% { fill: #0080ff; } 66.667% { fill: #0000ff; } 75.000% { fill: #8000ff; } 83.333% { fill: #ff00ff; } 91.667% { fill: #ff0080; } 100.00% { fill: #ff0000; }} #background { animation: rainbow-background 5s infinite; } #text { font-family: \"Helvetica\", \"Arial\", sans-serif; font-weight: bold; font-size: 72px; }</style>",
            "<g clip-path=\"url(#clip0_108_2)\">",
            "<rect id=\"background\" width=\"256\" height=\"256\" fill=\"#ff0000\"/>",
            "<rect x=\"28\" y=\"28\" width=\"200\" height=\"200\" fill=\"white\"/>",
            "</g>",
            "<defs>",
            "<clipPath id=\"clip0_108_2\">",
            "<rect width=\"256\" height=\"256\" fill=\"white\"/>",
            "</clipPath>",
            "</defs>",
            "<text xmlns=\"http://www.w3.org/2000/svg\" id=\"text\" x=\"128\" y=\"150\" fill=\"black\" style=\"width: 256px; display: block; text-align: center;\" text-anchor=\"middle\">""HQ""</text>",
            "</svg>"
        );

        // JSON
        bytes memory dataURI = abi.encodePacked(
            "{",
                "\"name\": \"HQNFT #", tokenId.toString(), "\",",
                "\"image\": \"data:image/svg+xml;base64,", Base64.encode(bytes(imageSVG)), "\",",
                "\"description\": \"You have successfully completed the Quiz!","\",",
                "\"background_color\": \"ffffff","\",",
                "\"animation_url\": \"https://www.youtube.com/watch?v=kPcu_5RkJpU\",",
                "\"youtube_url\": \"https://www.youtube.com/watch?v=sLZ_5RIO7Xw\""
            "}"
        );

        // Returned JSON
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }
}
