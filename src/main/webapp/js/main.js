/**
 * Student Feedback Portal - JavaScript Helper
 */
document.addEventListener("DOMContentLoaded", function () {

    // 1. Interactive Star Rating Display Label
    const ratingInputs = document.querySelectorAll('.star-rating-group input[type="radio"]');
    const ratingText = document.getElementById("rating-text");
    const ratingLabels = {
        "1": "1 Star - Poor",
        "2": "2 Stars - Fair",
        "3": "3 Stars - Good",
        "4": "4 Stars - Very Good",
        "5": "5 Stars - Excellent"
    };

    if (ratingInputs.length > 0 && ratingText) {
        ratingInputs.forEach(input => {
            if (input.checked && ratingLabels[input.value]) {
                ratingText.textContent = ratingLabels[input.value];
            }
            input.addEventListener("change", function () {
                if (ratingLabels[this.value]) {
                    ratingText.textContent = ratingLabels[this.value];
                    ratingText.className = "text-primary fw-semibold small mt-1";
                }
            });
        });
    }

    // 2. Textarea Character Counter
    const messageInput = document.getElementById("message");
    const charCounter = document.getElementById("char-counter");
    if (messageInput && charCounter) {
        const updateCount = () => {
            const len = messageInput.value.length;
            charCounter.textContent = `${len} / 2000 characters`;
            if (len > 1900) {
                charCounter.className = "text-danger small";
            } else {
                charCounter.className = "text-muted small";
            }
        };
        messageInput.addEventListener("input", updateCount);
        updateCount();
    }

    // 3. Delete Confirmation Modal Population
    const deleteButtons = document.querySelectorAll(".btn-delete-prompt");
    const deleteModalIdInput = document.getElementById("deleteModalId");
    const deleteModalStudentName = document.getElementById("deleteModalStudentName");

    if (deleteButtons.length > 0 && deleteModalIdInput && deleteModalStudentName) {
        deleteButtons.forEach(btn => {
            btn.addEventListener("click", function () {
                const id = this.getAttribute("data-id");
                const name = this.getAttribute("data-name");
                deleteModalIdInput.value = id;
                deleteModalStudentName.textContent = name;
            });
        });
    }

    // 4. Auto dismiss alerts after 5 seconds if present
    const autoAlerts = document.querySelectorAll(".alert-dismissible");
    autoAlerts.forEach(alert => {
        setTimeout(() => {
            if (window.bootstrap && bootstrap.Alert) {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            }
        }, 5000);
    });
});
