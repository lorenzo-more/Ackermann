import java.util.Scanner;

public class App {
    public static void main (String [] args) {
        System.out.println(
            "Programa Ackermann \nDigite os parâmetros m e n para calcular A(m, n) ou -1 para abortar a execução");

        Scanner sc = new Scanner(System.in);
            int m = sc.nextInt();
                if(m < 0)
                    System.exit(0);
            int n = sc.nextInt();
            sc.close();
            int resposta = ack(m, n);
            System.out.printf("A(%d, %d)=%d", m, n, resposta);
        
    }

    public static int ack(int m, int n) {
        if(m == 0)
            return n + 1;
        else if(m > 0 && n == 0)
            return ack(m - 1, 1);
        else
            return ack(m - 1, ack(m, n - 1));
    }
}



