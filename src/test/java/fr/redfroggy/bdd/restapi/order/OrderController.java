package fr.redfroggy.bdd.restapi.order;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
public final class OrderController {

    private final OrderService orderService;

    public OrderController(OrderService orderService) {
        this.orderService = orderService;
    }

    @GetMapping("/orders")
    public List<Order> getAll() {
        return orderService.findAll();
    }

    @GetMapping("/orders/{id}")
    public ResponseEntity<Order> get(@PathVariable("id") String id) {
        Order order = orderService.findById(id);
        if (order == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(order);
    }

    @PostMapping("/orders")
    public ResponseEntity<Order> create(@RequestBody Order order) {
        Order created = orderService.create(order);
        if (created == null) {
            return ResponseEntity.badRequest().build();
        }
        return ResponseEntity.status(201).body(created);
    }

    @PutMapping("/orders/{id}/status")
    public ResponseEntity<Order> updateStatus(@PathVariable("id") String id, @RequestBody Map<String, String> body) {
        Order updated = orderService.updateStatus(id, body.get("status"));
        if (updated == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(updated);
    }

    @DeleteMapping("/orders/{id}")
    public ResponseEntity<Void> delete(@PathVariable("id") String id) {
        if (!orderService.delete(id)) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok().build();
    }
}
