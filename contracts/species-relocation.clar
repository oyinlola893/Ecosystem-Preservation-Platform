;; Species Relocation Initiatives Contract

(define-data-var relocation-counter uint u0)

(define-map relocation-initiatives uint {
    coordinator: principal,
    species-name: (string-ascii 100),
    origin-planet: (string-ascii 50),
    destination-planet: (string-ascii 50),
    population-size: uint,
    status: (string-ascii 20),
    start-date: uint,
    completion-date: uint
})

(define-public (create-relocation-initiative (species-name (string-ascii 100)) (origin-planet (string-ascii 50)) (destination-planet (string-ascii 50)) (population-size uint))
    (let
        ((new-id (+ (var-get relocation-counter) u1)))
        (map-set relocation-initiatives new-id {
            coordinator: tx-sender,
            species-name: species-name,
            origin-planet: origin-planet,
            destination-planet: destination-planet,
            population-size: population-size,
            status: "planned",
            start-date: block-height,
            completion-date: u0
        })
        (var-set relocation-counter new-id)
        (ok new-id)
    )
)

(define-public (update-relocation-status (initiative-id uint) (new-status (string-ascii 20)))
    (let
        ((initiative (unwrap! (map-get? relocation-initiatives initiative-id) (err u404))))
        (asserts! (is-eq tx-sender (get coordinator initiative)) (err u403))
        (ok (map-set relocation-initiatives initiative-id
            (merge initiative {
                status: new-status,
                completion-date: (if (is-eq new-status "completed") block-height u0)
            })))
    )
)

(define-read-only (get-relocation-initiative (initiative-id uint))
    (map-get? relocation-initiatives initiative-id)
)

(define-read-only (get-relocation-count)
    (var-get relocation-counter)
)

