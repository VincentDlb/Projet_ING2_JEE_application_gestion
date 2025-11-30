package com.rsv.bdd;

import com.rsv.model.Statistiques;
import org.hibernate.Session;
import org.hibernate.query.Query;
import com.rsv.util.HibernateUtil;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * DAO pour récupérer les statistiques globales de l'application.
 * Version 2.0 avec statistiques salaires, grades et postes.
 * 
 * @author RowTech Team
 * @version 2.0
 */
public class StatistiquesDAO {

    /**
     * Récupère toutes les statistiques de l'application.
     * 
     * @return Objet Statistiques contenant toutes les données
     */
    public Statistiques getStatistiquesGlobales() {
        Statistiques stats = new Statistiques();
        
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            
            // 1. Total des employés
            Long totalEmployes = session.createQuery("SELECT COUNT(e) FROM Employe e", Long.class)
                    .uniqueResult();
            stats.setTotalEmployes(totalEmployes != null ? totalEmployes.intValue() : 0);
            
            // 2. Total des départements
            Long totalDepartements = session.createQuery("SELECT COUNT(d) FROM Departement d", Long.class)
                    .uniqueResult();
            stats.setTotalDepartements(totalDepartements != null ? totalDepartements.intValue() : 0);
            
            // 3. Total des projets
            Long totalProjets = session.createQuery("SELECT COUNT(p) FROM Projet p", Long.class)
                    .uniqueResult();
            stats.setTotalProjets(totalProjets != null ? totalProjets.intValue() : 0);
            
            // 4. Total des fiches de paie
            Long totalFiches = session.createQuery("SELECT COUNT(f) FROM FicheDePaie f", Long.class)
                    .uniqueResult();
            stats.setTotalFichesDePaie(totalFiches != null ? totalFiches.intValue() : 0);
            
            // 5. Statistiques salaires (NOUVEAU)
            calculerStatistiquesSalaires(session, stats);
            
            // 6. Employés par département
            stats.setEmployesParDepartement(getEmployesParDepartement(session));
            
            // 7. Employés par projet
            stats.setEmployesParProjet(getEmployesParProjet(session));
            
            // 8. Projets par état
            stats.setProjetsParEtat(getProjetsParEtat(session));
            
            // 9. Employés par projet et grade
            stats.setEmployesParProjetEtGrade(getEmployesParProjetEtGrade(session));
            
            // 10. Employés par grade (NOUVEAU)
            stats.setEmployesParGrade(getEmployesParGrade(session));
            
            // 11. Employés par poste (NOUVEAU)
            stats.setEmployesParPoste(getEmployesParPoste(session));
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return stats;
    }

    /**
     * Calcule les statistiques salaires (NOUVEAU).
     */
    private void calculerStatistiquesSalaires(Session session, Statistiques stats) {
        try {
            // Masse salariale totale
            String hqlSum = "SELECT COALESCE(SUM(e.salaire), 0.0) FROM Employe e";
            Double masseSalariale = session.createQuery(hqlSum, Double.class).uniqueResult();
            stats.setMasseSalarialeTotal(masseSalariale != null ? masseSalariale : 0.0);
            
            // Salaire moyen
            String hqlAvg = "SELECT COALESCE(AVG(e.salaire), 0.0) FROM Employe e";
            Double salaireMoyen = session.createQuery(hqlAvg, Double.class).uniqueResult();
            stats.setSalaireMoyen(salaireMoyen != null ? salaireMoyen : 0.0);
            
            // Salaire minimum
            String hqlMin = "SELECT COALESCE(MIN(e.salaire), 0.0) FROM Employe e";
            Double salaireMin = session.createQuery(hqlMin, Double.class).uniqueResult();
            stats.setSalaireMin(salaireMin != null ? salaireMin : 0.0);
            
            // Salaire maximum
            String hqlMax = "SELECT COALESCE(MAX(e.salaire), 0.0) FROM Employe e";
            Double salaireMax = session.createQuery(hqlMax, Double.class).uniqueResult();
            stats.setSalaireMax(salaireMax != null ? salaireMax : 0.0);
            
        } catch (Exception e) {
            e.printStackTrace();
            stats.setMasseSalarialeTotal(0.0);
            stats.setSalaireMoyen(0.0);
            stats.setSalaireMin(0.0);
            stats.setSalaireMax(0.0);
        }
    }

    /**
     * Récupère le nombre d'employés par grade (NOUVEAU).
     */
    private Map<String, Integer> getEmployesParGrade(Session session) {
        Map<String, Integer> result = new HashMap<>();
        
        try {
            String hql = "SELECT e.grade, COUNT(e) " +
                        "FROM Employe e " +
                        "GROUP BY e.grade " +
                        "ORDER BY COUNT(e) DESC";
            
            Query<Object[]> query = session.createQuery(hql, Object[].class);
            List<Object[]> rows = query.list();
            
            for (Object[] row : rows) {
                String grade = (String) row[0];
                Long count = (Long) row[1];
                result.put(grade, count.intValue());
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return result;
    }

    /**
     * Récupère le nombre d'employés par poste (NOUVEAU).
     */
    private Map<String, Integer> getEmployesParPoste(Session session) {
        Map<String, Integer> result = new HashMap<>();
        
        try {
            String hql = "SELECT e.poste, COUNT(e) " +
                        "FROM Employe e " +
                        "GROUP BY e.poste " +
                        "ORDER BY COUNT(e) DESC";
            
            Query<Object[]> query = session.createQuery(hql, Object[].class);
            List<Object[]> rows = query.list();
            
            for (Object[] row : rows) {
                String poste = (String) row[0];
                Long count = (Long) row[1];
                result.put(poste, count.intValue());
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return result;
    }

    /**
     * Récupère le nombre d'employés par département.
     */
    private Map<String, Integer> getEmployesParDepartement(Session session) {
        Map<String, Integer> result = new HashMap<>();
        
        try {
            String hql = "SELECT d.nom, COUNT(e) " +
                        "FROM Employe e JOIN e.departement d " +
                        "GROUP BY d.nom " +
                        "ORDER BY COUNT(e) DESC";
            
            Query<Object[]> query = session.createQuery(hql, Object[].class);
            List<Object[]> rows = query.list();
            
            for (Object[] row : rows) {
                String nomDept = (String) row[0];
                Long count = (Long) row[1];
                result.put(nomDept, count.intValue());
            }
            
            // Ajouter les départements sans employés
            String hqlDeptsSansEmployes = "SELECT d.nom FROM Departement d " +
                                         "WHERE d.id NOT IN (SELECT DISTINCT e.departement.id FROM Employe e WHERE e.departement IS NOT NULL)";
            Query<String> queryDepts = session.createQuery(hqlDeptsSansEmployes, String.class);
            List<String> deptsSansEmployes = queryDepts.list();
            
            for (String dept : deptsSansEmployes) {
                result.put(dept, 0);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return result;
    }

    /**
     * Récupère le nombre d'employés par projet.
     */
    private Map<String, Integer> getEmployesParProjet(Session session) {
        Map<String, Integer> result = new HashMap<>();
        
        try {
            String hql = "SELECT p.nom, SIZE(p.employes) " +
                        "FROM Projet p " +
                        "ORDER BY SIZE(p.employes) DESC";
            
            Query<Object[]> query = session.createQuery(hql, Object[].class);
            List<Object[]> rows = query.list();
            
            for (Object[] row : rows) {
                String nomProjet = (String) row[0];
                Integer count = (Integer) row[1];
                result.put(nomProjet, count);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return result;
    }

    /**
     * Récupère le nombre de projets par état.
     */
    private Map<String, Integer> getProjetsParEtat(Session session) {
        Map<String, Integer> result = new HashMap<>();
        
        try {
            String hql = "SELECT p.etat, COUNT(p) " +
                        "FROM Projet p " +
                        "GROUP BY p.etat";
            
            Query<Object[]> query = session.createQuery(hql, Object[].class);
            List<Object[]> rows = query.list();
            
            for (Object[] row : rows) {
                String etat = (String) row[0];
                Long count = (Long) row[1];
                result.put(etat, count.intValue());
            }
            
            // Initialiser les états manquants à 0
            if (!result.containsKey("EN_COURS")) result.put("EN_COURS", 0);
            if (!result.containsKey("TERMINE")) result.put("TERMINE", 0);
            if (!result.containsKey("ANNULE")) result.put("ANNULE", 0);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return result;
    }

    /**
     * Récupère le nombre d'employés par projet et par grade.
     */
    private Map<String, Map<String, Integer>> getEmployesParProjetEtGrade(Session session) {
        Map<String, Map<String, Integer>> result = new HashMap<>();
        
        try {
            String hql = "SELECT p.nom, e.grade, COUNT(e) " +
                        "FROM Projet p JOIN p.employes e " +
                        "GROUP BY p.nom, e.grade " +
                        "ORDER BY p.nom, e.grade";
            
            Query<Object[]> query = session.createQuery(hql, Object[].class);
            List<Object[]> rows = query.list();
            
            for (Object[] row : rows) {
                String nomProjet = (String) row[0];
                String grade = (String) row[1];
                Long count = (Long) row[2];
                
                if (!result.containsKey(nomProjet)) {
                    result.put(nomProjet, new HashMap<>());
                }
                
                result.get(nomProjet).put(grade, count.intValue());
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return result;
    }

    /**
     * Récupère les statistiques pour un département spécifique.
     */
    public Map<String, Object> getStatistiquesDepartement(Integer departementId) {
        Map<String, Object> stats = new HashMap<>();
        
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            
            // Nombre d'employés
            String hql = "SELECT COUNT(e) FROM Employe e WHERE e.departement.id = :deptId";
            Long count = session.createQuery(hql, Long.class)
                    .setParameter("deptId", departementId)
                    .uniqueResult();
            stats.put("nombreEmployes", count != null ? count.intValue() : 0);
            
            // Masse salariale (CORRECTION : salaireBase → salaire)
            String hqlSalaire = "SELECT COALESCE(SUM(e.salaire), 0.0) FROM Employe e WHERE e.departement.id = :deptId";
            Double masseSalariale = session.createQuery(hqlSalaire, Double.class)
                    .setParameter("deptId", departementId)
                    .uniqueResult();
            stats.put("masseSalariale", masseSalariale != null ? masseSalariale : 0.0);
            
            // Répartition par grade
            String hqlGrades = "SELECT e.grade, COUNT(e) FROM Employe e " +
                              "WHERE e.departement.id = :deptId GROUP BY e.grade";
            Query<Object[]> queryGrades = session.createQuery(hqlGrades, Object[].class);
            queryGrades.setParameter("deptId", departementId);
            
            Map<String, Integer> repartitionGrades = new HashMap<>();
            for (Object[] row : queryGrades.list()) {
                repartitionGrades.put((String) row[0], ((Long) row[1]).intValue());
            }
            stats.put("repartitionGrades", repartitionGrades);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return stats;
    }

    /**
     * Récupère les statistiques pour un projet spécifique.
     */
    public Map<String, Object> getStatistiquesProjet(Integer projetId) {
        Map<String, Object> stats = new HashMap<>();
        
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            
            // Nombre d'employés
            String hql = "SELECT SIZE(p.employes) FROM Projet p WHERE p.id = :projetId";
            Integer count = session.createQuery(hql, Integer.class)
                    .setParameter("projetId", projetId)
                    .uniqueResult();
            stats.put("nombreEmployes", count != null ? count : 0);
            
            // Répartition par grade
            String hqlGrades = "SELECT e.grade, COUNT(e) FROM Projet p " +
                              "JOIN p.employes e WHERE p.id = :projetId GROUP BY e.grade";
            Query<Object[]> queryGrades = session.createQuery(hqlGrades, Object[].class);
            queryGrades.setParameter("projetId", projetId);
            
            Map<String, Integer> repartitionGrades = new HashMap<>();
            for (Object[] row : queryGrades.list()) {
                repartitionGrades.put((String) row[0], ((Long) row[1]).intValue());
            }
            stats.put("repartitionGrades", repartitionGrades);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return stats;
    }
}