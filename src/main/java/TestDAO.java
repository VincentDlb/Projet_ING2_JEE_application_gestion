import com.rsv.bdd.EmployeDAO;
import com.rsv.model.Employe;
import java.util.List;

public class TestDAO {
    public static void main(String[] args) {
        System.out.println("=== TEST DAO ===");
        
        try {
            EmployeDAO dao = new EmployeDAO();
            List<Employe> liste = dao.listerTous();
            
            System.out.println("Nombre d'employés : " + liste.size());
            
            for (Employe e : liste) {
                System.out.println("- " + e.getNom() + " " + e.getPrenom());
            }
            
            System.out.println("=== TEST RÉUSSI ===");
            
        } catch (Exception e) {
            System.err.println("=== ERREUR ===");
            e.printStackTrace();
        }
    }
}