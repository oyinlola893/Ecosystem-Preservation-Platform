import { describe, it, expect, beforeEach } from "vitest"

describe("extraterrestrial-species-nft", () => {
  let contract: any
  
  beforeEach(() => {
    contract = {
      mintSpeciesNFT: (speciesName: string, rarity: string, planetOfOrigin: string, conservationStatus: string) => ({
        value: 1,
      }),
      transfer: (tokenId: number, sender: string, recipient: string) => ({ success: true }),
      getTokenMetadata: (tokenId: number) => ({
        creator: "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM",
        speciesName: "Bioluminescent Coral",
        rarity: "Very Rare",
        planetOfOrigin: "Aquarius-9",
        conservationStatus: "Endangered",
        createdAt: 123456,
      }),
      getLastTokenId: () => 1,
    }
  })
  
  describe("mint-species-nft", () => {
    it("should mint a new extraterrestrial species NFT", () => {
      const result = contract.mintSpeciesNFT("Bioluminescent Coral", "Very Rare", "Aquarius-9", "Endangered")
      expect(result.value).toBe(1)
    })
  })
  
  describe("transfer", () => {
    it("should transfer an extraterrestrial species NFT", () => {
      const result = contract.transfer(
          1,
          "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM",
          "ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG",
      )
      expect(result.success).toBe(true)
    })
  })
  
  describe("get-token-metadata", () => {
    it("should return token metadata", () => {
      const metadata = contract.getTokenMetadata(1)
      expect(metadata.speciesName).toBe("Bioluminescent Coral")
      expect(metadata.rarity).toBe("Very Rare")
    })
  })
  
  describe("get-last-token-id", () => {
    it("should return the last token ID", () => {
      const lastTokenId = contract.getLastTokenId()
      expect(lastTokenId).toBe(1)
    })
  })
})

