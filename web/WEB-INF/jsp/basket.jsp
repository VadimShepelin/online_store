<%--
  Created by IntelliJ IDEA.
  User: kocic
  Date: 07.09.2024
  Time: 21:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="locale.jsp"%>

<!DOCTYPE html>
<html lang="ru">
<head>
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Корзина товаров</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
        }
        .cart {
            max-width: 800px;
            margin: auto;
            background: #fff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .cart-item {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }
        .cart-item img {
            width: 100px;
            height: 100px;
            margin-right: 20px;
        }
        .cart-item h3 {
            flex: 1;
            font-size: 12px;
        }
        .cart-item input {
            width: 50px;
            margin-right: 20px;
        }
        .total {
            font-size: 1.5em;
            margin-top: 20px;
            color: red;
        }
        .checkout-button {
            padding: 10px 20px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .checkout-button:hover {
            background-color: #218838;
        }
        .delete-button{
            padding: 10px 20px;
            background-color: red;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .delete-button:hover{
            background-color:darkred;
        }
    </style>
</head>
<body>
<div class="cart">
    <h1>Корзина товаров</h1>
    <form action="/basket" method="post" enctype="multipart/form-data" onsubmit="return updateInputPrice()">
    <c:forEach var="product" items="${sessionScope.basketList}">
        <div class="cart-item" data-price="${product.getNew_price()}">
            <img src="images/${product.getImage()}" alt="Image Error">
            <h3>${product.getProduct_name()}</h3>
            <span class="price" id="new_price"  style="color: green">${product.getNew_price()} ₽</span>&nbsp;&nbsp;
            <label>
                <input type="number" name="count${product.getProduct_id()}" value="1" min="1" class="quantity" onchange="updatePrice(this)">
            </label>
        </div>
    </c:forEach>


        <input type="hidden" name="totalPrice" id="totalPriceInput" value="0">
        <div class="total" >Итого: <span id="totalPrice"></span></div>
        <button class="checkout-button" onclick="checkout()">Оформить заказ</button>
        <button formaction="/deleteBasket" class="delete-button w3-right-align"  onclick="checkout()">Удалить товары</button>
    </form>

    <c:if test="${requestScope.error!=null}">
        <font color="red">${requestScope.error}</font>
    </c:if>

    <c:if test="${requestScope.success!=null}">
        <font color="#006400">${requestScope.success}</font>
    </c:if>


</div>

<form action="/main" method="get" enctype="multipart/form-data">
    <button class="w3-button w3-padding-16 w3-display-bottomleft w3-panel w3-round-xxlarge w3-container w3-teal w3-opacity" style="width: 130px" >Назад</button>
</form>

<script>
    function updatePrice(input) {
        // Get the price of the product from the data attribute
        const pricePerUnit = parseInt(input.closest('.cart-item').getAttribute('data-price'));
        // Get the quantity from the input
        const quantity = parseInt(input.value);
        // Calculate the new total price for this item
        const newPrice = pricePerUnit * quantity;

        // Update the displayed price for this item
        input.closest('.cart-item').querySelector('.price').textContent = newPrice + ' ₽ ';

        // Update the total price
        updateTotalPrice();
    }

    function updateTotalPrice() {
        let total = 0;
        // Loop through each cart item to calculate the total
        document.querySelectorAll('.cart-item').forEach(item => {
            const priceText = item.querySelector('.price').textContent;
            const price = parseFloat(priceText);
            total += price;
        });
        // Update the total price displayed
        document.getElementById('totalPrice').textContent = total + ' ₽ ';
    }

    function updateInputPrice() {
        // Get the value from the span
        const totalPrice = document.getElementById('totalPrice').innerText;

        // Set the value of the hidden input
        document.getElementById('totalPriceInput').value = totalPrice;

        // Optionally, you can log it to the console for debugging
        console.log('Total Price:', totalPrice);

        return true; // Allow the form to submit
    }

    // Calculate total price on page load
    window.onload = updateTotalPrice;
</script>


</body>
</html>
