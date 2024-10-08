package online_store_project.dao;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.SneakyThrows;
import online_store_project.entity.Order;
import online_store_project.util.ConnectionManager;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class OrderDao implements Dao<Integer,Order>{

    @Getter
    private static final OrderDao INSTANCE = new OrderDao();
    private static final String ADD_ORDER = """
    INSERT INTO orders(date_of_the_order, user_id, quantity, price) VALUES (?,?,?,?) RETURNING *;
    """;
    private static final String GET_ORDERS = "SELECT * FROM orders WHERE user_id=?";

    @Override
    public Order save(Order entity) {
        return null;
    }

    @Override
    public void add(Order order) {

    }

    @Override
    public List<Order> findAll() {
        return List.of();
    }


    @Override
    public void delete(Integer id) {

    }

    @Override
    public Optional<Order> find(Integer id) {
        return Optional.empty();
    }


    public Optional<Order> addOrder(Order entity){
        try(Connection connection = ConnectionManager.get()){
            PreparedStatement preparedStatement = connection.prepareStatement(ADD_ORDER);
            preparedStatement.setObject(1, entity.getDate_of_the_order());
            preparedStatement.setObject(2, entity.getUser_id());
            preparedStatement.setObject(3, entity.getQuantity());
            preparedStatement.setObject(4, entity.getPrice());

            ResultSet resultSet = preparedStatement.executeQuery();

            if(resultSet.next()){
                Order order = orderBuilder(resultSet);
                return Optional.of(order);
            }

            return Optional.empty();

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public List<Order> getOrders(int userId) {
        try(Connection connection = ConnectionManager.get()) {
            PreparedStatement preparedStatement = connection.prepareStatement(GET_ORDERS);
            preparedStatement.setInt(1, userId);

            ResultSet resultSet = preparedStatement.executeQuery();

            List<Order> orders = new ArrayList<>();
            while(resultSet.next()){
                Order order = orderBuilder(resultSet);
                orders.add(order);
            }

            return orders;

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @SneakyThrows
    public Order orderBuilder(ResultSet resultSet){
        return Order.builder()
                .user_id(resultSet.getInt("user_id"))
                .orders_id(resultSet.getInt("orders_id"))
                .date_of_the_order(resultSet.getString("date_of_the_order"))
                .order_number(resultSet.getInt("order_number"))
                .price(resultSet.getDouble("price"))
                .quantity(resultSet.getInt("quantity"))
                .build();
    }

}
