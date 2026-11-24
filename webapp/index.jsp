<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:useBean id="resultBean" class="model.ResultBean" scope="session" />

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title> Лабораторная работа №3 </title>
    <style>
        body { /*селектор эл-тов + наслед */
            background-color: #ffffff;
            color: #3f2b14;
            font-family: sans-serif;
            margin: 20px;
        }

        .container {
            display: inline-block;
            min-width: 100%;
        }
        #header { /*шапка c фио */
            background-color: #f894d7;
            padding: 15px;
            border-radius: 8px; /*скругл*/
            margin: 0px 0px 20px 0px;
            width: 100%;
            box-sizing: border-box;
        }
        #header > p { /*+ дочерний селектор*/
            font-family: sans-serif;
            font-size: 16px;
            color: #3f2b14;
            margin: 4px 0px;
        }
        input[type="text"], select { /*селектор атрибута*/
            padding: 8px; /*внутр отступ*/
            margin-top: 5px;
            margin-bottom: 5px;      
            border: 1px solid #53391a;
            border-radius: 4px;
        }
        input[type="radio"] { /*селектор атрибута*/
            margin-left: 10px;
            margin-right: 3px;
        }
        input[type="text"]:focus { /*псевдокласс*/
            outline: none;
            border-color: #f894d7;
            box-shadow: 0 0 5px rgba(246, 56, 192, 0.5);
        }
        #submit_btn {
            background-color: #f894d7;
            color: #3f2b14;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        #submit_btn:hover { /*псевдокласс*/
            background-color: #c33c96;
        }

        .x-btn {
            background-color: #f894d7;
            color: #3f2b14;
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.5s ease;
        }
        .x-btn:hover { /*псевдокласс*/
            background-color: #c33c96;
        }

        .x-btn.active {
            background-color: #f488d0;
            color: #ffffff;
            border: 3px solid #3f2b14;
            font-weight: bold;
            box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.2); /* эффект нажатия */
        }
        
        .res_table {
            border: 2px solid #3f2b14;
            background-color: #ffffff;
            border-radius: 12px;
            border-spacing: 0; /*s между границами сосед ячеек*/
            overflow: hidden; /*хайдим для скругл*/
            width: 100%;
            margin-top: 15px;
        }
        /*каскад*/
        .res_table th, .res_table td {
            padding: 10px 15px;
            vertical-align: middle;
            border-bottom: 1px solid #3f2b14;
            color: #333333;
        }
        .res_table td.hit {
            color: #56de8f;
            font-weight: bold;
        }
        .res_table td.miss {
            color: #de5656;
            font-weight: bold;
        }

        .layout_table {
            border: 2px solid #3f2b14;
            background-color: #ffffff;
            border-radius: 12px;
            border-spacing: 0;
            overflow: hidden;
            width: 100%;
        }
        .layout_table td {
            padding: 20px;
            vertical-align: top;
        }
        .error-message {
            color: #de5656;
            font-size: 13px;
            margin-top: 4px;
            font-family: sans-serif;
            min-height: 18px;
        }
        input[type="text"].input-error {
            border-color: #de5656;
            box-shadow: 0 0 5px rgba(185, 58, 43, 0.4);
        }
    </style>
</head>
<body>
    <div class="container">
        <header id="header">
            <p>Сергеенкова Екатерина Владимировна</p>
            <p>Группа P3207</p>
            <p>Вариант 75651</p>
        </header>
        <table border="1" class="layout_table">
            <tr>
                <td>
                    <h3>Таблица расположения элементов</h3>
                    <canvas id="canvas" width="420" height="420"></canvas>
                </td>

                <td>
                    <form id="point_form">
                        <div>
                            <label for="x_input">Изменение X:</label>
                            <div id="x_input">
                                <button type="button" class="x-btn" data-value="-2">-2</button>
                                <button type="button" class="x-btn" data-value="-1.5">-1.5</button>
                                <button type="button" class="x-btn" data-value="-1">-1</button>
                                <button type="button" class="x-btn" data-value="-0.5">-0.5</button>
                                <button type="button" class="x-btn active" data-value="0" >0</button>
                                <button type="button" class="x-btn" data-value="0.5">0.5</button>
                                <button type="button" class="x-btn" data-value="1">1</button>
                                <button type="button" class="x-btn" data-value="1.5">1.5</button>
                                <button type="button" class="x-btn" data-value="2">2</button>
                            </div>
                            <div id="x_error" class="error-message"></div>
                            <input type="hidden" id="x_hidden_input" name="x" value="0">
                        </div>
                        <br>
                        <div>
                            <label for="y_input">Изменение Y: (-3 ... 5)</label>
                            <input type="text" id="y_input" name="y">
                            <div id="y_error" class="error-message"></div>
                        </div>
                        <br>
                        <div>
                            <label for="R_input">Изменение R:</label>
                            <div id="r_input">
                                <label><input type="checkbox" name="r" value="1"> 1</label>
                                <label><input type="checkbox" name="r" value="1.5"> 1.5</label>
                                <label><input type="checkbox" name="r" value="2" checked> 2</label>
                                <label><input type="checkbox" name="r" value="2.5"> 2.5</label>
                                <label><input type="checkbox" name="r" value="3"> 3</label>
                            </div>
                            <div id="r_error" class="error-message"></div>
                        </div>
                        <br>
                        <button type="submit" id="submit_btn">Отправить</button>
                    </form>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <h3>Таблица результатов</h3>
                    <table border="1" id="res_table" class="res_table">
                        <thead>
                            <tr>
                                <th>X</th>
                                <th>Y</th>
                                <th>R</th>
                                <th>Результат</th>
                                <th>Время отправки</th>  
                                <th>Время обработки</th>
                            </tr>
                        </thead>
                        <tbody id="res_body">
                            <c:forEach var="item" items="${resultBean.results}">
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
                </td>
            </tr>
        </table>
    </div>
    <script>
        function formatRussianDate(timestamp) {
            if (!timestamp || isNaN(Number(timestamp))) return "—";
            const date = new Date(Number(timestamp));
            return date.toLocaleString('ru-RU', 
            {year: 'numeric',
                month: '2-digit',
                day: "2-digit",
                hour: "2-digit",
                minute: '2-digit',
                second: '2-digit'
            });
        }
        function formatAllTableDates() {
            document.querySelectorAll('.time-cell').forEach(cell => {
                const ts = cell.getAttribute('data-timestamp');
                if (ts && ts !== "") {
                    cell.textContent = formatRussianDate(ts);
                }
            });
        }
        formatAllTableDates();

        function addLineToTable(data) {
            const newLine = document.createElement('tr'); /*созд новый дом-эл, но физ-ки добавл позже*/
            const statusText = data.hit ? "Попадание" : "Промах";
            const statusClass = data.hit ? "hit" : "miss";
            const ts = data.timestamp || Date.now();

            newLine.innerHTML =
                '<td>' + data.x + '</td>' +
                '<td>' + data.y + '</td>' +
                '<td>' + data.r + '</td>' +
                '<td class="' + statusClass + '">' + statusText + '</td>' +
                '<td class="time-cell" data-timestamp="' + ts + '">' + formatRussianDate(ts) + '</td>' +
                '<td>' + (data.executionTime || "—") + '</td>';


            resBody.prepend(newLine);
        }
        
        function validateY(valStr) {
            if (!valStr || valStr.trim() === "") {
                return "Поле Y не может быть пустым. Введите число в диапазоне (-3 ... 5).";
            }

            const s = valStr.trim().replace(',', '.');

            const numberRegex = /^-?\d+(\.\d+)?$/;
            if (!numberRegex.test(s)) {
                return "Введенное значение должно быть корректным вещественным числом (без букв и спецсимволов).";
            }

            const isNegative = s.startsWith('-');
            const unsignedStr = isNegative ? s.slice(1) : s;
            const parts = unsignedStr.split('.');
            const intPart = parts[0].replace(/^0+/, '') || '0';
            
            if (!isNegative) {
                if (intPart.length > 1 || parseInt(intPart, 10) >= 5) {
                    return "Значение не подходит: Y должен быть строго меньше 5.";
                }
            }

            if (isNegative) {
                if (intPart.length > 1 || parseInt(intPart, 10) >= 3) {
                    return "Значение не подходит: Y должен быть строго больше -3.";
                }
            }
            return null;
        }
        
        const form = document.getElementById('point_form'); /*именно в дом ищет*/
        const yInput = document.getElementById('y_input');
        const resBody = document.getElementById('res_body');

        yInput.addEventListener('input', function() {
            document.getElementById('y_error').textContent = "";
            yInput.classList.remove('input-error');
        });

        const xBtns = document.querySelectorAll('.x-btn');
        const hiddenInputX = document.getElementById('x_hidden_input');

        xBtns.forEach(btn => {
            btn.addEventListener('click', function(){
                xBtns.forEach(b => b.classList.remove('active'));
                this.classList.add('active');
                hiddenInputX.value = this.dataset.value;
                const xErr = document.getElementById('x_error');
                if (xErr) xErr.textContent = "";
            })
        })

        const rCheckBox = document.querySelectorAll('input[name="r"]');
        rCheckBox.forEach(rcb =>{
            rcb.addEventListener('change', function() {
                const rErr = document.getElementById('r_error');
                if (rErr) rErr.textContent="";
                redrawAllPoints();
            })
        })

        form.addEventListener('submit', function (event) {
            //event.preventDefault(); /*чтобы не перегр стр, отм стандрат повед*/
            
            const yError = document.getElementById('y_error');
            const xError = document.getElementById('x_error');
            const rError = document.getElementById('r_error');
            
            if (rError) rError.textContent = "";
            if (xError) xError.textContent = "";
            if (yError) yError.textContent = "";
            yInput.classList.remove('input-error');

            let hasError = false;

            const hiddenInputX = document.getElementById('x_hidden_input');
            if (!hiddenInputX || hiddenInputX.value === "") {
                if (xError) xError.textContent = "Выберите координату X, нажав на кнопку.";
                hasError = true;
            }
            const x = parseFloat(hiddenInputX.value);

            const yLine = yInput.value.trim().replace(',', '.');
            const errorMessage = validateY(yLine);
            if (errorMessage) {
                yError.textContent = errorMessage;
                yInput.classList.add('input-error');
                hasError = true;
            }

            const checkedRBoxes = document.querySelectorAll('input[name="r"]:checked');
            if (checkedRBoxes.length === 0) {
                if (rError) rError.textContent = "Выберите хотя бы один радиус R";
                hasError = true;
            }

            if (hasError) {
                event.preventDefault(); //блокируем переход только если есть ошибк
                return;
            }
            form.action = "controller";
            form.method = "GET";
        });

        const canvas = document.getElementById('canvas');
        const context = canvas.getContext('2d');
        const width = canvas.width;
        const height = canvas.height;
        const centerX = width/2;
        const centerY = height/2;
        const unit = 60;

        function drawShapeForR(r, alpha) {
            const scale = r * unit;
            context.save();
            context.globalAlpha = alpha;
            context.fillStyle = "#f894d7";

            context.beginPath();
            context.moveTo(centerX, centerY);
            context.lineTo(centerX + scale / 2, centerY);
            context.lineTo(centerX, centerY - scale); 
            context.closePath();
            context.fill();
            
            context.fillRect(centerX - scale, centerY, scale, scale);

            context.beginPath();
            context.moveTo(centerX, centerY);
            context.arc(centerX, centerY, scale / 2, 0, 0.5 * Math.PI, false);
            context.closePath();
            context.fill();

            context.restore()
        }

        function drawAxes(){
            context.save();
            context.strokeStyle ="#3f2b14";
            context.fillStyle ="#3f2b14";
            context.lineWidth = 1.0;
            context.font = "11px sans-serif";

            context.beginPath();
            context.moveTo(10, centerY);
            context.lineTo(width-10, centerY);
            context.stroke();

            context.beginPath();
            context.moveTo(centerX, height-10);
            context.lineTo(centerX, 10);
            context.stroke();

            context.beginPath();
            context.moveTo(width-10, centerY);
            context.lineTo(width-18, centerY-4);
            context.lineTo(width-18, centerY+4);
            context.fill();
            context.fillText("x", width-15, centerY-10);

            context.beginPath();
            context.moveTo(centerX, 10);
            context.lineTo(centerX-4, 18);
            context.lineTo(centerX+4, 18);
            context.fill();
            context.fillText("y", centerX+10, 15);

            context.textAlign = "right";
            context.textBaseline = "bottom";
            context.fillText("0", centerX - 5, centerY - 4);

            for (let step = -6; step<=6; step++){
                if (step===0) continue;
                const val = step*0.5;
                const label = val.toString();
                const xPos = centerX + val * unit;
                const yPos = centerY - val * unit;

                context.beginPath();
                context.moveTo(xPos, centerY - 3);
                context.lineTo(xPos, centerY + 3);
                context.stroke();

                context.textAlign = "center";
                context.textBaseline = "top";
                context.fillText(label, xPos, centerY + 6);

                context.beginPath();
                context.moveTo(centerX - 3, yPos);
                context.lineTo(centerX + 3, yPos);
                context.stroke();

                context.textAlign = "left";
                context.textBaseline = "middle";
                context.fillText(label, centerX + 6, yPos);
                }
            context.restore();
        }

        function drawPoint(x, y, isHit, alpha = 0.95, radius = 4){
            const xPixel = centerX + x*unit;
            const yPixel = centerY - y*unit;

            context.save();
            context.globalAlpha = alpha;
            context.beginPath();
            context.arc(xPixel, yPixel, radius, 0, 2 * Math.PI);
            context.fillStyle = isHit ? "#56de8f" : "#de5656";
            context.fill();
            context.strokeStyle = "#3f2b14";
            context.lineWidth = 1;
            context.stroke();
            context.restore();
        }

        canvas.addEventListener('click', function (event){
            const checkedRBoxes = document.querySelectorAll('input[name="r"]:checked');
            const rError = document.getElementById('r_error');

            if (checkedRBoxes.length === 0){
                if (rError) {rError.textContent = "Невозможно определить координаты: сначала выберите хотя бы один радиус R";}
                return;
            }
            if (rError) rError.textContent = "";

            const rect = canvas.getBoundingClientRect();
            const clickX = event.clientX - rect.left;
            const clickY = event.clientY - (rect.top);
            const mathX = ((clickX - centerX) / unit).toFixed(2);
            const mathY = ((centerY - clickY) / unit).toFixed(2);

            const rParams = Array.from(checkedRBoxes).map(cb => 'r=' + encodeURIComponent(cb.value)).join('&');
            const url = 'controller?x=' + encodeURIComponent(mathX) + '&y=' + encodeURIComponent(mathY) + '&' + rParams + '&ajax=true';

            fetch(url, {
                method: 'GET',
                headers: { 'Accept': 'application/json' }
            }).then(res => {
                if (!res.ok) throw new Error('HTTP ' + res.status);
                return res.json();
            })
            .then(dataArray => {
                const results = Array.isArray(dataArray) ? dataArray : [dataArray];
                results.forEach(serverData => {
                    addLineToTable(serverData);
                });
                redrawAllPoints();
            })
            .catch(err => {
                console.error("Ошибка клика:", err);
            });
        });

       function redrawAllPoints(){
            context.clearRect(0, 0, width, height);
            const selectedRs = Array.from(document.querySelectorAll('input[name="r"]:checked')).map(cb => parseFloat(cb.value)).filter(val => !isNaN(val)).sort((a,b) => b-a);
            const count = selectedRs.length;

            selectedRs.forEach((rVal, index) => {
                const areaAlpha = count === 1 ? 0.55 : 0.18 + (index / (count - 1)) * 0.32;
                drawShapeForR(rVal, areaAlpha);
            });

            drawAxes();
            const rows = Array.from(document.querySelectorAll('#res_body tr')).reverse();
            const allPoints = [];
            rows.forEach(row => {
                const cells = row.querySelectorAll('td');
                if (cells.length >= 4) {
                    const x = parseFloat(cells[0].textContent);
                    const y = parseFloat(cells[1].textContent);
                    const r = parseFloat(cells[2].textContent);
                    const isHit = cells[3].classList.contains('hit');
                    if (!isNaN(x) && !isNaN(y) && !isNaN(r)) {
                        allPoints.push({ x, y, r, isHit });
                    }
                }
            });

            selectedRs.forEach((rVal, index) => {
                const pointAlpha = count === 1 ? 0.95 : 0.35 + (index / (count - 1)) * 0.6;
                const pointRadius = count === 1 ? 4 : 6 - (index / (count - 1)) * 3;

                allPoints
                    .filter(pt => Math.abs(pt.r - rVal) < 1e-6)
                    .forEach(pt => {
                        drawPoint(pt.x, pt.y, pt.isHit, pointAlpha, pointRadius);
                    });
            });

        }
        redrawAllPoints();
    </script>
</body>
</html>