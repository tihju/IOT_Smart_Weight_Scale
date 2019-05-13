package cmpe273.lab2.project.models;

import java.util.Date;

public class Payment {
    private double amount;
    private Date date;
    private String status;

    public Payment() {}

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Payment{" +
                "amount=" + amount +
                ", date=" + date +
                ", status='" + status + '\'' +
                '}';
    }
}
