<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Результат проверки</title>
    <style>
        body {
            background-color: #ffffff;
            color: #3f2b14;
            font-family: sans-serif;
            margin: 40px auto;
            max-width: 800px;
        }
        h2 {
            color: #3f2b14;
        }
        .res_table {
            border: 2px solid #3f2b14;
            background-color: #ffffff;
            border-radius: 12px;
            border-spacing: 0;
            overflow: hidden;
            width: 100%;
            margin-top: 20px;
            margin-bottom: 25px;
        }
        .res_table th, .res_table td {
            padding: 12px 15px;
            vertical-align: middle;
            border-bottom: 1px solid #3f2b14;
            text-align: center;
        }
        .res_table th {
            background-color: #fce4f4;
        }
        .hit {
            color: #27ae60;
            font-weight: bold;
        }
        .miss {
            color: #de5656;
            font-weight: bold;
        }
        .back-btn {
            display: inline-block;
            background-color: #f894d7;
            color: #3f2b14;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 6px;
            border: 1px solid #3f2b14;
            font-weight: bold;
            transition: 0.2s;
        }
        .back-btn:hover {
            background-color: #c33c96;
            color: #ffffff;
        }
    </style>
</head>
<body>
    <h2>Результат проверки точки</h2>

    <table class="res_table">
        <thead>
            <tr>
                <th>X</th>
                <th>Y</th>
                <th>R</th>
                <th>Результат</th>
                <th>Время отправки</th>
                <th>Время работы</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="item" items="${lastResults}">
                <tr>
                    <td>${item.x}</td>
                    <td>${item.y}</td>
                    <td>${item.r}</td>
                    <td class="${item.hit ? 'hit' : 'miss'}">${item.hit ? 'Попадание' : 'Промах'}</td>
                    <td class="time-cell" data-timestamp="${item.timestamp}"></td>
                    <td>${item.executionTimeFormatted}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    <a href="controller" class="back-btn"> Вернуться к форме</a>
    <script>
        document.querySelectorAll('.time-cell').forEach(function(cell) {
            var ts = cell.getAttribute('data-timestamp');
            if (ts) {
                cell.textContent = new Date(Number(ts)).toLocaleString('ru-RU', {
                    year: 'numeric', month: '2-digit', day: '2-digit',
                    hour: '2-digit', minute: '2-digit', second: '2-digit'
                });
            }
        });
    </script>
</body>
</html>