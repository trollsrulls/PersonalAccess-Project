package org.diploma.personalaccess.entity;

import com.google.gson.annotations.Expose;
import org.apache.commons.lang3.builder.EqualsBuilder;
import org.hibernate.validator.constraints.Length;
import org.springframework.core.style.ToStringCreator;

import javax.persistence.*;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import java.sql.Date;

/**
 * Simple JavaBean domain object representing an user work indexes.
 *
 * @author Maksim Patapenka
 */
@Entity
@Table(name = "user_index")
public class UserIndex extends BaseEntity {

    @Expose
    @Column(name = "self_estimate")
    @Min(0)
    private int selfEstimate;

    @Expose
    @Column(name = "lead_estimate")
    @Min(0)
    private int leadEstimate;

    @Expose(deserialize = false)
    @Column(name = "fill_date")
    @NotNull
    private Date fillDate;

    @Expose
    @Column(name = "description", length = 500)
    @Length(max = 500)
    private String description;

    @Expose
    @ManyToOne
    @JoinColumn(name = "index_id")
    private Index index;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @Expose
    @ManyToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "document_id")
    private Document document;

    public int getSelfEstimate() {
        return selfEstimate;
    }

    public void setSelfEstimate(int selfEstimate) {
        this.selfEstimate = selfEstimate;
    }

    public int getLeadEstimate() {
        return leadEstimate;
    }

    public void setLeadEstimate(int leadEstimate) {
        this.leadEstimate = leadEstimate;
    }

    public Date getFillDate() {
        return fillDate;
    }

    public void setFillDate(Date fillDate) {
        this.fillDate = fillDate;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Index getIndex() {
        return index;
    }

    public void setIndex(Index index) {
        this.index = index;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Document getDocument() {
        return document;
    }

    public void setDocument(Document document) {
        this.document = document;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }

        if (o == null || getClass() != o.getClass()) {
            return false;
        }

        UserIndex userIndex = (UserIndex) o;
        return new EqualsBuilder()
                .append(selfEstimate, userIndex.selfEstimate)
                .append(leadEstimate, userIndex.leadEstimate)
                .append(fillDate, userIndex.fillDate)
                .append(description, userIndex.description)
                .append(index, userIndex.index)
                .append(user, userIndex.user)
                .append(document, userIndex.document)
                .isEquals();
    }

    @Override
    public String toString() {
        return new ToStringCreator(this)
                .append("id", getId())
                .append("selfEstimate", getSelfEstimate())
                .append("leadEstimate", getLeadEstimate())
                .append("fillDate", getFillDate())
                .append("description", getDescription())
                .append("index", getIndex())
                .append("user", getUser())
                .append("document", getDocument())
                .toString();
    }

}
