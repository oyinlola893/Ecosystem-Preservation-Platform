;; Ecosystem Modeling and Prediction Contract

(define-data-var model-counter uint u0)

(define-map ecosystem-models uint {
    creator: principal,
    planet: (string-ascii 50),
    model-parameters: (string-utf8 2000),
    prediction-results: (string-utf8 2000),
    stability-score: uint,
    biodiversity-index: uint,
    created-at: uint
})

(define-public (create-ecosystem-model (planet (string-ascii 50)) (model-parameters (string-utf8 2000)) (prediction-results (string-utf8 2000)) (stability-score uint) (biodiversity-index uint))
    (let
        ((new-id (+ (var-get model-counter) u1)))
        (map-set ecosystem-models new-id {
            creator: tx-sender,
            planet: planet,
            model-parameters: model-parameters,
            prediction-results: prediction-results,
            stability-score: stability-score,
            biodiversity-index: biodiversity-index,
            created-at: block-height
        })
        (var-set model-counter new-id)
        (ok new-id)
    )
)

(define-public (update-ecosystem-model (model-id uint) (new-prediction-results (string-utf8 2000)) (new-stability-score uint) (new-biodiversity-index uint))
    (let
        ((model (unwrap! (map-get? ecosystem-models model-id) (err u404))))
        (asserts! (is-eq tx-sender (get creator model)) (err u403))
        (ok (map-set ecosystem-models model-id
            (merge model {
                prediction-results: new-prediction-results,
                stability-score: new-stability-score,
                biodiversity-index: new-biodiversity-index
            })))
    )
)

(define-read-only (get-ecosystem-model (model-id uint))
    (map-get? ecosystem-models model-id)
)

(define-read-only (get-model-count)
    (var-get model-counter)
)

