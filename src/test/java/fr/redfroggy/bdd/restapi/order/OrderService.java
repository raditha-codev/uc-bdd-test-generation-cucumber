package fr.redfroggy.bdd.restapi.order;

import org.springframework.stereotype.Service;

import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

@Service
public class OrderService {

    private final List<Order> orders = new CopyOnWriteArrayList<>();

    public List<Order> findAll() {
        return orders;
    }

    public Order findById(String id) {
        return orders.stream().filter(o -> o.getId().equals(id))
                .findFirst()
                .orElse(null);
    }

    public Order create(Order order) {
        if (order == null || order.getId() == null || order.getId().trim().isEmpty() || findById(order.getId()) != null) {
            return null;
        }
        orders.add(order);
        return order;
    }

    public Order updateStatus(String id, String status) {
        Order order = findById(id);
        if (order == null) {
            return null;
        }
        order.setStatus(status);
        return order;
    }

    public boolean delete(String id) {
        return orders.removeIf(o -> o.getId().equals(id));
    }
}
