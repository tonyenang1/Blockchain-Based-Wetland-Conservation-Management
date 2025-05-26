;; Restoration Verification Contract
;; Validates wetland restoration projects and progress

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u500))
(define-constant ERR_PROJECT_NOT_FOUND (err u501))
(define-constant ERR_INVALID_PROJECT (err u502))
(define-constant ERR_MILESTONE_NOT_FOUND (err u503))

;; Data structures
(define-map restoration-projects
  { project-id: uint }
  {
    wetland-id: uint,
    project-manager: principal,
    project-name: (string-ascii 100),
    start-date: uint,
    planned-end-date: uint,
    actual-end-date: uint,
    total-budget: uint,
    spent-budget: uint,
    restoration-type: (string-ascii 50),
    target-area-hectares: uint,
    restored-area-hectares: uint,
    status: (string-ascii 20),
    success-rate: uint
  }
)

(define-map project-milestones
  { project-id: uint, milestone-id: uint }
  {
    description: (string-ascii 200),
    target-date: uint,
    completion-date: uint,
    budget-allocated: uint,
    budget-spent: uint,
    completed: bool,
    verified: bool,
    verifier: (optional principal)
  }
)

(define-map restoration-techniques
  { technique-id: uint }
  {
    name: (string-ascii 100),
    description: (string-ascii 200),
    effectiveness-rating: uint,
    cost-per-hectare: uint,
    suitable-conditions: (string-ascii 100)
  }
)

(define-map project-techniques
  { project-id: uint, technique-id: uint }
  { area-applied-hectares: uint, implementation-date: uint, success-rate: uint }
)

(define-data-var next-project-id uint u1)
(define-data-var next-technique-id uint u1)

;; Public functions
(define-public (create-restoration-project
  (wetland-id uint)
  (project-name (string-ascii 100))
  (planned-end-date uint)
  (total-budget uint)
  (restoration-type (string-ascii 50))
  (target-area-hectares uint))

  (let ((project-id (var-get next-project-id)))
    (asserts! (> wetland-id u0) ERR_INVALID_PROJECT)
    (asserts! (> planned-end-date block-height) ERR_INVALID_PROJECT)
    (asserts! (> total-budget u0) ERR_INVALID_PROJECT)
    (asserts! (> target-area-hectares u0) ERR_INVALID_PROJECT)

    (map-set restoration-projects
      { project-id: project-id }
      {
        wetland-id: wetland-id,
        project-manager: tx-sender,
        project-name: project-name,
        start-date: block-height,
        planned-end-date: planned-end-date,
        actual-end-date: u0,
        total-budget: total-budget,
        spent-budget: u0,
        restoration-type: restoration-type,
        target-area-hectares: target-area-hectares,
        restored-area-hectares: u0,
        status: "planning",
        success-rate: u0
      }
    )
    (var-set next-project-id (+ project-id u1))
    (ok project-id)
  )
)

(define-public (add-project-milestone
  (project-id uint)
  (milestone-id uint)
  (description (string-ascii 200))
  (target-date uint)
  (budget-allocated uint))

  (let ((project (unwrap! (map-get? restoration-projects { project-id: project-id }) ERR_PROJECT_NOT_FOUND)))
    (asserts! (is-eq tx-sender (get project-manager project)) ERR_UNAUTHORIZED)
    (asserts! (> target-date block-height) ERR_INVALID_PROJECT)

    (map-set project-milestones
      { project-id: project-id, milestone-id: milestone-id }
      {
        description: description,
        target-date: target-date,
        completion-date: u0,
        budget-allocated: budget-allocated,
        budget-spent: u0,
        completed: false,
        verified: false,
        verifier: none
      }
    )
    (ok true)
  )
)

(define-public (complete-milestone (project-id uint) (milestone-id uint) (budget-spent uint))
  (let ((project (unwrap! (map-get? restoration-projects { project-id: project-id }) ERR_PROJECT_NOT_FOUND))
        (milestone (unwrap! (map-get? project-milestones { project-id: project-id, milestone-id: milestone-id }) ERR_MILESTONE_NOT_FOUND)))

    (asserts! (is-eq tx-sender (get project-manager project)) ERR_UNAUTHORIZED)
    (asserts! (not (get completed milestone)) ERR_INVALID_PROJECT)

    (map-set project-milestones
      { project-id: project-id, milestone-id: milestone-id }
      (merge milestone {
        completion-date: block-height,
        budget-spent: budget-spent,
        completed: true
      })
    )

    ;; Update project spent budget
    (map-set restoration-projects
      { project-id: project-id }
      (merge project { spent-budget: (+ (get spent-budget project) budget-spent) })
    )
    (ok true)
  )
)

(define-public (verify-milestone (project-id uint) (milestone-id uint))
  (let ((milestone (unwrap! (map-get? project-milestones { project-id: project-id, milestone-id: milestone-id }) ERR_MILESTONE_NOT_FOUND)))
    (asserts! (get completed milestone) ERR_INVALID_PROJECT)
    (asserts! (not (get verified milestone)) ERR_INVALID_PROJECT)

    (map-set project-milestones
      { project-id: project-id, milestone-id: milestone-id }
      (merge milestone {
        verified: true,
        verifier: (some tx-sender)
      })
    )
    (ok true)
  )
)

(define-public (update-restoration-progress (project-id uint) (restored-area-hectares uint))
  (let ((project (unwrap! (map-get? restoration-projects { project-id: project-id }) ERR_PROJECT_NOT_FOUND)))
    (asserts! (is-eq tx-sender (get project-manager project)) ERR_UNAUTHORIZED)
    (asserts! (<= restored-area-hectares (get target-area-hectares project)) ERR_INVALID_PROJECT)

    (let ((success-rate (/ (* restored-area-hectares u100) (get target-area-hectares project))))
      (map-set restoration-projects
        { project-id: project-id }
        (merge project {
          restored-area-hectares: restored-area-hectares,
          success-rate: success-rate
        })
      )
    )
    (ok true)
  )
)

(define-public (register-restoration-technique
  (name (string-ascii 100))
  (description (string-ascii 200))
  (effectiveness-rating uint)
  (cost-per-hectare uint)
  (suitable-conditions (string-ascii 100)))

  (let ((technique-id (var-get next-technique-id)))
    (asserts! (<= effectiveness-rating u100) ERR_INVALID_PROJECT)

    (map-set restoration-techniques
      { technique-id: technique-id }
      {
        name: name,
        description: description,
        effectiveness-rating: effectiveness-rating,
        cost-per-hectare: cost-per-hectare,
        suitable-conditions: suitable-conditions
      }
    )
    (var-set next-technique-id (+ technique-id u1))
    (ok technique-id)
  )
)

;; Read-only functions
(define-read-only (get-restoration-project (project-id uint))
  (map-get? restoration-projects { project-id: project-id })
)

(define-read-only (get-project-milestone (project-id uint) (milestone-id uint))
  (map-get? project-milestones { project-id: project-id, milestone-id: milestone-id })
)

(define-read-only (get-restoration-technique (technique-id uint))
  (map-get? restoration-techniques { technique-id: technique-id })
)

(define-read-only (calculate-project-efficiency (project-id uint))
  (match (map-get? restoration-projects { project-id: project-id })
    project (let ((budget-efficiency (if (> (get spent-budget project) u0)
                                         (/ (* (get success-rate project) (get total-budget project))
                                            (get spent-budget project))
                                         u0))
                  (time-efficiency (if (and (> (get actual-end-date project) u0)
                                           (> (get planned-end-date project) (get start-date project)))
                                      (/ (* u100 (get planned-end-date project))
                                         (get actual-end-date project))
                                      u100)))
               (/ (+ budget-efficiency time-efficiency) u2))
    u0
  )
)

(define-read-only (get-next-project-id)
  (var-get next-project-id)
)
