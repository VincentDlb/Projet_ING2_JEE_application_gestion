package com.rsv.bdd;

import com.rsv.model.Departement;
import com.rsv.model.Employe;
import com.rsv.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.ArrayList;
import java.util.List;

/**
 * DAO pour gérer les départements dans la base de données.
 * 
 * @author RowTech Team
 * @version 2.1
 */
public class DepartementDAO {

    /**
     * Ajoute un nouveau département
     */
    public boolean ajouterDepartement(Departement departement) {
        Session session = null;
        Transaction transaction = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();

            session.persist(departement);

            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    /**
     * Modifie un département existant
     */
    public boolean modifierDepartement(Departement departement) {
        Session session = null;
        Transaction transaction = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();

            session.merge(departement);

            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }
    
    /**
     * Modifie uniquement la description d'un département.
     * Cette méthode recharge le département dans une nouvelle session Hibernate
     * pour éviter les problèmes de lazy loading avec les objets détachés.
     * 
     * @param departementId ID du département à modifier
     * @param nouvelleDescription Nouvelle description
     * @return true si la modification a réussi, false sinon
     */
    public boolean modifierDescription(Integer departementId, String nouvelleDescription) {
        Session session = null;
        Transaction transaction = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            
            // Recharger le département dans cette session
            Departement departement = session.get(Departement.class, departementId);
            
            if (departement == null) {
                transaction.rollback();
                return false;
            }
            
            // Modifier la description
            departement.setDescription(nouvelleDescription);
            
            // Hibernate détecte automatiquement le changement car l'objet est attaché à la session
            // Le flush se fait automatiquement au commit
            
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    /**
     * Supprime un département par son ID
     */
    public boolean supprimerDepartement(Integer id) {
        Session session = null;
        Transaction transaction = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();

            Departement departement = session.get(Departement.class, id);
            if (departement != null) {
                session.remove(departement);
                transaction.commit();
                return true;
            }

            transaction.rollback();
            return false;
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    /**
     * Récupère un département par son ID
     */
    public Departement getDepartementById(Integer id) {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            return session.get(Departement.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    /**
     * Liste tous les départements
     */
    public List<Departement> listerTous() {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            String hql = "FROM Departement ORDER BY nom";
            Query<Departement> query = session.createQuery(hql, Departement.class);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    /**
     * Récupère les employés d'un département
     */
    public List<Employe> getEmployesByDepartement(Integer departementId) {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            String hql = "FROM Employe WHERE departement.id = :deptId ORDER BY nom, prenom";
            Query<Employe> query = session.createQuery(hql, Employe.class);
            query.setParameter("deptId", departementId);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    /**
     * Compte le nombre de départements
     */
    public long compterDepartements() {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            String hql = "SELECT COUNT(d) FROM Departement d";
            Query<Long> query = session.createQuery(hql, Long.class);
            Long count = query.uniqueResult();
            return count != null ? count : 0L;
        } catch (Exception e) {
            e.printStackTrace();
            return 0L;
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    /**
     * Récupère tous les départements (alias pour listerTous)
     */
    public List<Departement> getAllDepartements() {
        return listerTous();
    }

    /**
     * Récupère un département par nom
     */
    public Departement getDepartementByNom(String nom) {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            String hql = "FROM Departement WHERE nom = :nom";
            Query<Departement> query = session.createQuery(hql, Departement.class);
            query.setParameter("nom", nom);
            return query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    /**
     * Récupère le département dont l'employé est chef.
     * 
     * @param chefId ID de l'employé chef
     * @return Le département où l'employé est chef, ou null
     */
    public Departement getDepartementParChef(Integer chefId) {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();

            String hql = "FROM Departement d WHERE d.chefDepartement.id = :chefId";
            Query<Departement> query = session.createQuery(hql, Departement.class);
            query.setParameter("chefId", chefId);
            query.setMaxResults(1);

            List<Departement> results = query.list();
            if (results != null && !results.isEmpty()) {
                return results.get(0);
            }
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    /**
     * Vérifie si un employé est chef d'un département donné.
     * 
     * @param departementId ID du département
     * @param employeId     ID de l'employé
     * @return true si l'employé est chef du département, false sinon
     */
    public boolean verifierEstChefDepartement(Integer departementId, Integer employeId) {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();

            String hql = "SELECT COUNT(d) FROM Departement d WHERE d.id = :deptId AND d.chefDepartement.id = :empId";
            Query<Long> query = session.createQuery(hql, Long.class);
            query.setParameter("deptId", departementId);
            query.setParameter("empId", employeId);

            Long count = query.uniqueResult();
            return count != null && count > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    /**
     * Récupère les employés d'un département (pour les fiches de paie).
     * Utilisé par le chef pour consulter les fiches de paie de son équipe.
     * 
     * @param departementId ID du département
     * @return Liste des employés du département
     */
    public List<Employe> getEmployesDuDepartement(Integer departementId) {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();

            String hql = "FROM Employe e WHERE e.departement.id = :deptId ORDER BY e.nom, e.prenom";
            Query<Employe> query = session.createQuery(hql, Employe.class);
            query.setParameter("deptId", departementId);

            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }
}