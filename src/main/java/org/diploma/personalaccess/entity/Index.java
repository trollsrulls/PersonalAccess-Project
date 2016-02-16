package org.diploma.personalaccess.entity;

import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;
import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "`index`")
public class Index implements Serializable {

    @Id
    @GeneratedValue(generator = "increment")
    @GenericGenerator(name = "increment", strategy = "increment")
    private long id;

    @Column(name = "name", length = 400)
    private String name;

    @Column(name = "estimate")
    private int estimate;

    @Column(name = "multiplier")
    private int multiplier;

    @Column(name = "work_name", length = 50)
    private String workName;

    @OneToMany(cascade = CascadeType.ALL, mappedBy = "index")
    private Set<UserIndex> userIndexes = new HashSet<>();

    @ManyToMany
    @JoinTable(name = "available_index",
            joinColumns = {@JoinColumn(name = "index_id", nullable = false)},
            inverseJoinColumns = {@JoinColumn(name = "position_id", nullable = false)})
    private Set<Position> availablePositions = new HashSet<>();

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getEstimate() {
        return estimate;
    }

    public void setEstimate(int estimate) {
        this.estimate = estimate;
    }

    public int getMultiplier() {
        return multiplier;
    }

    public void setMultiplier(int multiplier) {
        this.multiplier = multiplier;
    }

    public String getWorkName() {
        return workName;
    }

    public void setWorkName(String workName) {
        this.workName = workName;
    }

    public Set<UserIndex> getUserIndexes() {
        return userIndexes;
    }

    public void setUserIndexes(Set<UserIndex> userIndexes) {
        this.userIndexes = userIndexes;
    }

    public Set<Position> getAvailablePositions() {
        return availablePositions;
    }

    public void setAvailablePositions(Set<Position> availablePositions) {
        this.availablePositions = availablePositions;
    }

}