package model;
import java.io.Serializable;

public class PointResult implements Serializable{
    private String x;
    private String y;
    private String r;
    private boolean hit;
    private long timestamp;
    private long executionTimeNano;
    public PointResult(String x, String y, String r, boolean hit, long timestamp, long executionTimeNano) {
        this.x = x;
        this.y = y;
        this.r = r;
        this.hit = hit;
        this.timestamp = timestamp;
        this.executionTimeNano = executionTimeNano;
    }
    public String getX() { return x; }
    public String getY() { return y; }
    public String getR() { return r; }
    public boolean isHit() { return hit; }
    public long getTimestamp() { return timestamp; }
    public long getExecutionTimeNano() { return executionTimeNano; }
    public String getExecutionTimeFormatted() {
        return String.format("%.2f мкс", executionTimeNano / 1000.0);
    }
}
