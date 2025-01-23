;; Terraforming Operations Contract

(define-data-var operation-counter uint u0)

(define-map terraforming-operations uint {
    operator: principal,
    planet: (string-ascii 50),
    target-conditions: (string-utf8 1000),
    current-progress: uint,
    status: (string-ascii 20),
    start-date: uint,
    estimated-completion: uint
})

(define-public (initiate-terraforming (planet (string-ascii 50)) (target-conditions (string-utf8 1000)) (estimated-completion uint))
    (let
        ((new-id (+ (var-get operation-counter) u1)))
        (map-set terraforming-operations new-id {
            operator: tx-sender,
            planet: planet,
            target-conditions: target-conditions,
            current-progress: u0,
            status: "initiated",
            start-date: block-height,
            estimated-completion: estimated-completion
        })
        (var-set operation-counter new-id)
        (ok new-id)
    )
)

(define-public (update-terraforming-progress (operation-id uint) (new-progress uint) (new-status (string-ascii 20)))
    (let
        ((operation (unwrap! (map-get? terraforming-operations operation-id) (err u404))))
        (asserts! (is-eq tx-sender (get operator operation)) (err u403))
        (ok (map-set terraforming-operations operation-id
            (merge operation {
                current-progress: new-progress,
                status: new-status
            })))
    )
)

(define-read-only (get-terraforming-operation (operation-id uint))
    (map-get? terraforming-operations operation-id)
)

(define-read-only (get-operation-count)
    (var-get operation-counter)
)

