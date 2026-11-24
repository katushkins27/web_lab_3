package servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.PointResult;
import model.ResultBean;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AreaCheckServlet", value = "/areaCheck")
public class AreaCheckServlet extends HttpServlet{

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        long startTime = System.nanoTime();
        String xRaw = request.getParameter("x");
        String yRaw = request.getParameter("y");
        String[] rArray = request.getParameterValues("r");

        String acceptHeader = request.getHeader("Accept");
        boolean isAjax = (acceptHeader != null && acceptHeader.contains("application/json"))
                || "true".equalsIgnoreCase(request.getParameter("ajax"));

        if (isAjax){
            if (!isNumber(xRaw) || !isNumber(yRaw) || !isValidRArray(rArray)) {
                sendError(request, response, 422, "Некорректные координаты клика или радиус R");
                return;
            }
        } else {
            if (!isValidX(xRaw)) {
                sendError(request, response, 422, "Некорректное значение X. Выберите значение из кнопок: {-2 .. 2}");
                return;
            }
            if (!isValidY(yRaw)) {
                sendError(request, response, 422, "Некорректное значение Y. Должно быть число строго в интервале (-3 ... 5)");
                return;
            }
            if (!isValidRArray(rArray)) {
                sendError(request, response, 422, "Некорректный радиус R. Выберите хотя бы один чекбокс из {1, 1.5, 2, 2.5, 3}");
                return;
            }
        }
        BigDecimal x = new BigDecimal(xRaw.trim().replace(',', '.'));
        BigDecimal y = new BigDecimal(yRaw.trim().replace(',', '.'));

        HttpSession session = request.getSession();
        ResultBean resultBean = (ResultBean) session.getAttribute("resultBean");
        if (resultBean == null) {
            resultBean = new ResultBean();
            session.setAttribute("resultBean", resultBean);
        }

        long timestamp = System.currentTimeMillis();
        //String currentTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("HH:mm:ss"));
        List<PointResult> currentResults = new ArrayList<>();

        for (String rStr : rArray){
            BigDecimal r = new BigDecimal(rStr);
            boolean isHit = checkArea(x, y, r);
            long executionTimeNano = System.nanoTime() - startTime;

            PointResult result = new PointResult(
                    x.toPlainString(),
                    y.toPlainString(),
                    r.toPlainString(),
                    isHit,
                    timestamp,
                    executionTimeNano
            );
            resultBean.addResult(result);
            currentResults.add(result);
        }
        if (isAjax) {
            response.setContentType("application/json;charset=UTF-8");
            PrintWriter out = response.getWriter();
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < currentResults.size(); i++) {
                PointResult res = currentResults.get(i);
                json.append(String.format("{\"x\": %s, \"y\": \"%s\", \"r\": %s, \"hit\": %b, \"timestamp\": %d, \"executionTime\": \"%.2f мкс\"}",
                        res.getX(),
                        res.getY(),
                        res.getR(),
                        res.isHit(),
                        res.getTimestamp(),
                        res.getExecutionTimeNano() / 1000.0
                ));
                if (i < currentResults.size() - 1) json.append(",");
            }
            json.append("]");
            out.print(json);
            out.flush();
        }else {
            request.setAttribute("lastResults", currentResults);
            request.getRequestDispatcher("/result.jsp").forward(request, response);
        }
    }

    private void sendError(HttpServletRequest request, HttpServletResponse response, int status, String msg) throws IOException {
        String acceptHeader = request.getHeader("Accept");
        if (acceptHeader != null && acceptHeader.contains("application/json")) {
            response.setStatus(status);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write(String.format("{\"error\": \"%s\"}", msg.replace("\"", "\\\"")));
        } else {
            response.sendError(status, msg);
        }
    }

    private static boolean checkArea(BigDecimal x, BigDecimal y, BigDecimal r){
        BigDecimal zero = BigDecimal.ZERO;
        BigDecimal two = new BigDecimal("2");
        BigDecimal rHalf = r.divide(two);

        int xCmp = x.compareTo(zero);
        int yCmp = y.compareTo(zero);
        //треугольник
        if (xCmp >= 0 && yCmp >= 0) {
            BigDecimal line = r.subtract(x.multiply(two));
            return x.compareTo(rHalf) <= 0 && y.compareTo(line) <= 0;
        }
        //пустая вторая четверть
        if (xCmp <0 && yCmp >0){
            return false;
        }
        //прямоугольник
        if (xCmp <= 0 && yCmp <= 0) {
            BigDecimal minusR = r.negate();
            return x.compareTo(minusR) >= 0 && y.compareTo(minusR) >= 0;
        }
        //сектор
        if (xCmp >= 0 && yCmp <= 0) {
            BigDecimal leftSide = x.multiply(x).add(y.multiply(y));
            BigDecimal rightSide = rHalf.multiply(rHalf);
            return leftSide.compareTo(rightSide) <= 0;
        }
        return false;
    }
    private static boolean isValidX(String xStr){
        if (xStr == null || xStr.trim().isEmpty()) {
            return false;
        }
        try{
            BigDecimal x = new BigDecimal(xStr.trim().replace(',', '.'));
            String[] allowed = {"-2", "-1.5", "-1", "-0.5", "0", "0.5", "1", "1.5", "2"};
            for (String val: allowed){
                if (x.compareTo(new BigDecimal(val)) == 0) return true;
            }
        } catch (Exception ignored){}
        return false;
    }

    private static boolean isValidY(String yStr){
        if (yStr == null || yStr.trim().isEmpty()) {
            return false;
        }
        try{
            BigDecimal y = new BigDecimal(yStr.trim().replace(',', '.'));
            BigDecimal min = new BigDecimal("-3");
            BigDecimal max = new BigDecimal("5");
            return y.compareTo(min) > 0 && y.compareTo(max) < 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    private static boolean isValidRArray(String[] rArray) {
        if (rArray == null || rArray.length == 0) {
            return false;
        }
        for (String rStr : rArray) {
            if (!isValidR(rStr)) {
                return false;
            }
        }
        return true;
    }

    private static boolean isValidR(String rStr){
        if (rStr == null || rStr.trim().isEmpty()) {
            return false;
        }
        try{
            BigDecimal r = new BigDecimal(rStr.trim().replace(',', '.'));
            String[] allowed = {"1", "1.5", "2", "2.5", "3"};
            for (String val: allowed){
                if (r.compareTo(new BigDecimal(val)) == 0) return true;
            }
        } catch (Exception ignored){}
        return false;
    }

    private static boolean isNumber(String s){
        if (s==null || s.trim().isEmpty()) return false;
        try{
            new BigDecimal(s.trim().replace(',', '.'));
            return true;
        } catch (Exception e){
            return false;
        }
    }
}
