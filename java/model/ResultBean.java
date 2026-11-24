package model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class ResultBean implements Serializable {
    private final List<PointResult> results = Collections.synchronizedList(new ArrayList<>());
    public ResultBean() {}
    public void addResult(PointResult result) {
        results.add(0, result);
    }
    public List<PointResult> getResults() {
        synchronized (results) {
            return new ArrayList<>(results);
        }
    }
}