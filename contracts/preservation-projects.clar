;; Preservation Projects Management Contract

(define-data-var project-counter uint u0)

(define-map preservation-projects uint {
    creator: principal,
    planet: (string-ascii 50),
    star-system: (string-ascii 50),
    description: (string-utf8 1000),
    status: (string-ascii 20),
    start-date: uint,
    last-updated: uint
})

(define-public (create-preservation-project (planet (string-ascii 50)) (star-system (string-ascii 50)) (description (string-utf8 1000)))
    (let
        ((new-id (+ (var-get project-counter) u1)))
        (map-set preservation-projects new-id {
            creator: tx-sender,
            planet: planet,
            star-system: star-system,
            description: description,
            status: "active",
            start-date: block-height,
            last-updated: block-height
        })
        (var-set project-counter new-id)
        (ok new-id)
    )
)

(define-public (update-project-status (project-id uint) (new-status (string-ascii 20)))
    (let
        ((project (unwrap! (map-get? preservation-projects project-id) (err u404))))
        (asserts! (is-eq tx-sender (get creator project)) (err u403))
        (ok (map-set preservation-projects project-id
            (merge project {
                status: new-status,
                last-updated: block-height
            })))
    )
)

(define-read-only (get-preservation-project (project-id uint))
    (map-get? preservation-projects project-id)
)

(define-read-only (get-project-count)
    (var-get project-counter)
)

