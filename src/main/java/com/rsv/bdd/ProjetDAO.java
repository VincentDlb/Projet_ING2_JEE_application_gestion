package com.rsv.bdd;

import com.rsv.model.Projet;
import com.rsv.model.Employe;
import com.rsv.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.ArrayList;
import java.util.List;

/**
 * DAO pour gérer les projets.
 
  
 * @author RowTech Team
 * @version 2.0
 */
public class ProjetDAO {

    /**
     * Ajoute un nouveau projet
     */
    public boolean ajouterProjet(Projet projet) {
        Session session = null;
        Transaction transaction = null;
        
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            
            session.persist(projet);
            
            transaction.commit();
            return true;
            
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
            return false;
        } finally {
            if (session != null) session.close();
        }
    }

    /**
     * Liste tous les projets
     */
    public List<Projet> listerTous() {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            
            String hql = "SELECT DISTINCT p FROM Projet p LEFT JOIN FETCH p.employes ORDER BY p.nom";
            Query<Projet> query = session.createQuery(hql, Projet.class);
            
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            if (session != null) session.close();
        }
    }
    
    /**
     
     * @param chefId ID de l'employé chef
     * @return Liste des projets où l'employé est chef
     */
    public List<Projet> listerProjetsParChef(Integer chefId) {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            
            String hql = "SELECT DISTINCT p FROM Projet p " +
                        "LEFT JOIN FETCH p.employes " +
                        "WHERE p.chefDeProjet.id = :chefId " +
                        "ORDER BY p.nom";
            Query<Projet> query = session.createQuery(hql, Projet.class);
            query.setParameter("chefId", chefId);
            
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            if (session != null) session.close();
        }
    }
    
    /**
     
     * @param projetId ID du projet
     * @param employeId ID de l'employé
     * @return true si l'employé est chef du projet, false sinon
     */
    public boolean verifierEstChefProjet(Integer projetId, Integer employeId) {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            
            String hql = "SELECT COUNT(p) FROM Projet p WHERE p.id = :projetId AND p.chefDeProjet.id = :employeId";
            Query<Long> query = session.createQuery(hql, Long.class);
            query.setParameter("projetId", projetId);
            query.setParameter("employeId", employeId);
            
            Long count = query.uniqueResult();
            return count != null && count > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            if (session != null) session.close();
        }
    }
    
    /**
     
     * Utilisé par le chef pour consulter les fiches de paie de son équipe.
     * @param projetId ID du projet
     * @return Liste des employés du projet
     */
    public List<Employe> getEmployesDuProjet(Integer projetId) {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            
            String hql = "SELECT DISTINCT e FROM Employe e " +
                        "JOIN e.projets p " +
                        "WHERE p.id = :projetId " +
                        "ORDER BY e.nom, e.prenom";
            Query<Employe> query = session.createQuery(hql, Employe.class);
            query.setParameter("projetId", projetId);
            
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            if (session != null) session.close();
        }
    }

    /**
     * Récupère un projet par ID
     */
    public Projet getProjetById(Integer id) {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            return session.get(Projet.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            if (session != null) session.close();
        }
    }

    /**
     * Récupère un projet avec ses employés
     */
    public Projet getProjetAvecEmployes(Integer id) {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            
            String hql = "FROM Projet p LEFT JOIN FETCH p.employes WHERE p.id = :id";
            Query<Projet> query = session.createQuery(hql, Projet.class);
            query.setParameter("id", id);
            
            return query.uniqueResult();
            
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            if (session != null) session.close();
        }
    }
    
    /**
     * Récupère tous les projets d'un employé avec les employés chargés
     */
    public List<Projet> listerProjetsByEmploye(Integer employeId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        List<Projet> projets = new ArrayList<>();
        
        try {
            // Utiliser JOIN FETCH pour charger les employés en même temps
            String hql = "SELECT DISTINCT p FROM Projet p " +
                         "LEFT JOIN FETCH p.employes " +
                         "WHERE p.id IN (SELECT p2.id FROM Projet p2 JOIN p2.employes e WHERE e.id = :employeId) " +
                         "ORDER BY p.nom";
            Query<Projet> query = session.createQuery(hql, Projet.class);
            query.setParameter("employeId", employeId);
            projets = query.list();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            session.close();
        }
        
        return projets;
    }

    /**
     * Modifie un projet
     */
    public boolean modifierProjet(Projet projet) {
        Session session = null;
        Transaction transaction = null;
        
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            
            session.merge(projet);
            
            transaction.commit();
            return true;
            
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
            return false;
        } finally {
            if (session != null) session.close();
        }
    }

    /**
     * Supprime un projet
     */
    public boolean supprimerProjet(Integer id) {
        Session session = null;
        Transaction transaction = null;
        
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            
            Projet projet = session.get(Projet.class, id);
            if (projet != null) {
                session.remove(projet);
                transaction.commit();
                return true;
            }
            
            return false;
            
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
            return false;
        } finally {
            if (session != null) session.close();
        }
    }

    /**
     * Ajoute un employé à un projet
     */
    public boolean ajouterEmployeAuProjet(Integer projetId, Integer employeId) {
        Session session = null;
        Transaction transaction = null;
        
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            
            Projet projet = session.get(Projet.class, projetId);
            Employe employe = session.get(Employe.class, employeId);
            
            if (projet != null && employe != null) {
                projet.getEmployes().add(employe);
                session.merge(projet);
                transaction.commit();
                return true;
            }
            
            return false;
            
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
            return false;
        } finally {
            if (session != null) session.close();
        }
    }

    /**
     * Retire un employé d'un projet
     */
    public boolean retirerEmployeDuProjet(Integer projetId, Integer employeId) {
        Session session = null;
        Transaction transaction = null;
        
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            
            Projet projet = session.get(Projet.class, projetId);
            Employe employe = session.get(Employe.class, employeId);
            
            if (projet != null && employe != null) {
                projet.getEmployes().remove(employe);
                session.merge(projet);
                transaction.commit();
                return true;
            }
            
            return false;
            
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
            return false;
        } finally {
            if (session != null) session.close();
        }
    }

    /**
     * Compte le nombre de projets
     */
    public long compterProjets() {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            String hql = "SELECT COUNT(p) FROM Projet p";
            Query<Long> query = session.createQuery(hql, Long.class);
            return query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        } finally {
            if (session != null) session.close();
        }
    }

    /**
     * Liste les projets par état
     */
    public List<Projet> listerParEtat(String etat) {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            String hql = "FROM Projet WHERE etat = :etat ORDER BY nom";
            Query<Projet> query = session.createQuery(hql, Projet.class);
            query.setParameter("etat", etat);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            if (session != null) session.close();
        }
    }
    
    /**
     * Liste tous les projets
     */
    public List<Projet> listerProjets() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        List<Projet> projets = new ArrayList<>();
        
        try {
            String hql = "FROM Projet p ORDER BY p.nom";
            Query<Projet> query = session.createQuery(hql, Projet.class);
            projets = query.list();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            session.close();
        }
        
        return projets;
    }

    /**
    
    
     * Liste tous les projets auxquels un employé appartient (chef ou membre).
     * 
     * @param employeId ID de l'employé
     * @return Liste des projets
     */
    public List<Projet> listerTousMesProjets(Integer employeId) {
        Session session = null;
        
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            
           
            String hql = "SELECT DISTINCT p FROM Projet p " +
                         "LEFT JOIN FETCH p.employes " +
                         "WHERE p.chefDeProjet.id = :employeId " +
                         "OR :employeId IN (SELECT e.id FROM p.employes e) " +
                         "ORDER BY p.nom";
            
            Query<Projet> query = session.createQuery(hql, Projet.class);
            query.setParameter("employeId", employeId);
            
            return query.list();
            
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            if (session != null) session.close();
        }
    }

   
    /**
     * Vérifie si un employé appartient à un projet (chef OU membre).
     * 
     * @param projetId ID du projet
     * @param employeId ID de l'employé
     * @return true si l'employé appartient au projet, false sinon
     */
    public boolean appartientAuProjet(Integer projetId, Integer employeId) {
        Transaction transaction = null;
        boolean appartient = false;
        
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            
            String hql = "SELECT COUNT(p) FROM Projet p " +
                         "WHERE p.id = :projetId " +
                         "AND (p.chefDeProjet.id = :employeId " +
                         "OR :employeId IN (SELECT e.id FROM p.employes e))";
            
            Long count = session.createQuery(hql, Long.class)
                               .setParameter("projetId", projetId)
                               .setParameter("employeId", employeId)
                               .uniqueResult();
            
            appartient = (count != null && count > 0);
            
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
        
        return appartient;
    }
}