package com.feedback.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.time.format.DateTimeFormatter;

/**
 * Model class representing a Student Feedback record.
 * Demonstrates Java Bean conventions (private fields, getters/setters, serializable).
 */
public class Feedback implements Serializable {

    private static final long serialVersionUID = 1L;

    private int id;
    private String studentName;
    private String email;
    private String category;
    private String message;
    private int rating;
    private Timestamp createdAt;

    // Default no-argument constructor (required for JavaBeans)
    public Feedback() {
    }

    // Constructor for creating new feedback before database insertion (no ID yet)
    public Feedback(String studentName, String email, String category, String message, int rating) {
        this.studentName = studentName;
        this.email = email;
        this.category = category;
        this.message = message;
        this.rating = rating;
    }

    // Full constructor (for records retrieved from database)
    public Feedback(int id, String studentName, String email, String category, String message, int rating, Timestamp createdAt) {
        this.id = id;
        this.studentName = studentName;
        this.email = email;
        this.category = category;
        this.message = message;
        this.rating = rating;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    /**
     * Helper to return human-friendly formatted date for display in JSP.
     */
    public String getFormattedDate() {
        if (createdAt == null) {
            return "N/A";
        }
        return createdAt.toLocalDateTime().format(DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a"));
    }

    /**
     * Helper to return star characters for simple visual rating display.
     */
    public String getStarsDisplay() {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < rating; i++) {
            sb.append("★");
        }
        for (int i = rating; i < 5; i++) {
            sb.append("☆");
        }
        return sb.toString();
    }

    @Override
    public String toString() {
        return "Feedback{" +
                "id=" + id +
                ", studentName='" + studentName + '\'' +
                ", email='" + email + '\'' +
                ", category='" + category + '\'' +
                ", rating=" + rating +
                ", createdAt=" + createdAt +
                '}';
    }
}
