package it.bookBorrow;

/**
 *
 * @author alessandro
 */
public class Ordina {

    public static Object[][] order(Object[][] distanze) {
        if (distanze[0].length > 1) {
            for (int j = 0; j < distanze[0].length; j++) {
                boolean flag = false;
                for (int k = 0; k < distanze[0].length - 1; k++) {
                    if (Double.compare((Double) distanze[1][k], (Double) distanze[1][k + 1]) > 0) {
                        Double temp1 = (Double) distanze[1][k];
                        int temp2 = (int) distanze[0][k];
                        distanze[0][k] = distanze[0][k + 1];
                        distanze[1][k] = distanze[1][k + 1];
                        distanze[0][k + 1] = temp2;
                        distanze[1][k + 1] = temp1;
                        flag = true;
                    }
                    if (!flag) {
                        break;
                    }
                }
            }
        }
        return distanze;
    }
}
