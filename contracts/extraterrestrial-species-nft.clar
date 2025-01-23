;; Extraterrestrial Species NFT Contract

(define-non-fungible-token extraterrestrial-species-nft uint)

(define-data-var token-id-counter uint u0)

(define-map token-metadata uint {
    creator: principal,
    species-name: (string-ascii 100),
    rarity: (string-ascii 20),
    planet-of-origin: (string-ascii 50),
    conservation-status: (string-ascii 20),
    created-at: uint
})

(define-public (mint-species-nft (species-name (string-ascii 100)) (rarity (string-ascii 20)) (planet-of-origin (string-ascii 50)) (conservation-status (string-ascii 20)))
    (let
        ((new-id (+ (var-get token-id-counter) u1)))
        (try! (nft-mint? extraterrestrial-species-nft new-id tx-sender))
        (map-set token-metadata new-id {
            creator: tx-sender,
            species-name: species-name,
            rarity: rarity,
            planet-of-origin: planet-of-origin,
            conservation-status: conservation-status,
            created-at: block-height
        })
        (var-set token-id-counter new-id)
        (ok new-id)
    )
)

(define-public (transfer (token-id uint) (sender principal) (recipient principal))
    (begin
        (asserts! (is-eq tx-sender sender) (err u403))
        (nft-transfer? extraterrestrial-species-nft token-id sender recipient)
    )
)

(define-read-only (get-token-metadata (token-id uint))
    (map-get? token-metadata token-id)
)

(define-read-only (get-last-token-id)
    (var-get token-id-counter)
)

